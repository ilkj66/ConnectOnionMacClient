import Combine
import ConnectOnion
import Foundation

@MainActor
class ConnectOnionService: ObservableObject {
    private var agent: Agent?
    private var currentConfiguration: AgentConfiguration?

    @Published var isConnected: Bool = false
    @Published var connectionError: String? = nil

    let incomingMessages = PassthroughSubject<String, Never>()

    func connect(with configuration: AgentConfiguration) {
        guard !configuration.apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            connectionError = "Missing API key"
            isConnected = false
            return
        }

        guard let baseURL = URL(string: configuration.baseURL) else {
            connectionError = "Invalid base URL"
            isConnected = false
            return
        }

        let client = OpenAIClient(
            config: .init(
                apiKey: configuration.apiKey,
                model: configuration.model,
                baseURL: baseURL
            )
        )

        agent = Agent(
            name: configuration.name,
            llm: client,
            model: configuration.model,
            systemPrompt: configuration.systemPrompt.isEmpty ? nil : configuration.systemPrompt
        )
        currentConfiguration = configuration
        connectionError = nil
        isConnected = true
    }

    func disconnect() {
        agent = nil
        currentConfiguration = nil
        isConnected = false
    }

    func sendMessage(_ message: String, using configuration: AgentConfiguration) async {
        if agent == nil || currentConfiguration != configuration {
            connect(with: configuration)
        }

        guard let agent else { return }

        do {
            let response = try await agent.input(message)
            incomingMessages.send(response)
        } catch {
            connectionError = error.localizedDescription
            incomingMessages.send("Error: \(error.localizedDescription)")
        }
    }
}
