import Foundation
import Combine

/// A starter service for connecting to a ConnectOnion agent via WebSockets using async/await
@MainActor
class ConnectOnionService: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession
    private var receiveTask: Task<Void, Never>?
    
    @Published var isConnected: Bool = false
    @Published var connectionError: String? = nil
    
    // Subject for receiving incoming messages from the agent
    let incomingMessages = PassthroughSubject<String, Never>()
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func connect(to agentAddress: String, relayURL: String) async {
        guard let url = URL(string: relayURL) else {
            self.connectionError = "Invalid Relay URL"
            return
        }
        
        var request = URLRequest(url: url)
        // In a real implementation, you would add required headers or auth for ConnectOnion
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        self.isConnected = true
        self.connectionError = nil
        
        startReceiving()
    }
    
    func disconnect() {
        receiveTask?.cancel()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        self.isConnected = false
    }
    
    func sendMessage(_ message: String, to agentAddress: String) async {
        let payload: [String: Any] = [
            "target_address": agentAddress,
            "action": "input",
            "data": message
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: payload),
              let stringData = String(data: data, encoding: .utf8) else { return }
        
        let wsMessage = URLSessionWebSocketTask.Message.string(stringData)
        
        do {
            try await webSocketTask?.send(wsMessage)
        } catch {
            self.connectionError = "Failed to send: \(error.localizedDescription)"
        }
    }
    
    private func startReceiving() {
        receiveTask?.cancel()
        receiveTask = Task {
            while let task = webSocketTask, !Task.isCancelled {
                do {
                    let message = try await task.receive()
                    switch message {
                    case .string(let text):
                        incomingMessages.send(text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            incomingMessages.send(text)
                        }
                    @unknown default:
                        break
                    }
                } catch {
                    if !Task.isCancelled {
                        self.isConnected = false
                        self.connectionError = "Disconnected: \(error.localizedDescription)"
                    }
                    break
                }
            }
        }
    }
}
