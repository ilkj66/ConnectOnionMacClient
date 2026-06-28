import Foundation
import Combine
import SwiftUI

enum NavigationItem: Hashable {
    case session(UUID)
    case configuration(UUID)
}

class AppViewModel: ObservableObject {
    @Published var configurations: [AgentConfiguration] = [] {
        didSet { saveConfigurations() }
    }
    @Published var sessions: [ChatSession] = [] {
        didSet { saveSessions() }
    }
    
    @Published var selection: NavigationItem?
    
    private let configKey = "saved_configurations"
    private let sessionKey = "saved_sessions"
    
    init() {
        loadData()
        if configurations.isEmpty && sessions.isEmpty {
            loadDemoData()
        }
    }
    
    func createNewSession(for config: AgentConfiguration) {
        let newSession = ChatSession(agentConfigId: config.id, title: "New Chat with \(config.name)")
        sessions.append(newSession)
        selection = .session(newSession.id)
    }
    
    private func loadDemoData() {
        let config = AgentConfiguration(
            name: "Demo Agent",
            apiKey: "",
            baseURL: "https://api.openai.com/v1",
            model: "gpt-4o-mini",
            systemPrompt: "You are a helpful assistant."
        )
        configurations.append(config)
        
        let session = ChatSession(agentConfigId: config.id, title: "Welcome Chat")
        sessions.append(session)
        selection = .session(session.id)
    }
    
    private func saveConfigurations() {
        if let data = try? JSONEncoder().encode(configurations) {
            UserDefaults.standard.set(data, forKey: configKey)
        }
    }
    
    private func saveSessions() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: sessionKey)
        }
    }
    
    private func loadData() {
        if let configData = UserDefaults.standard.data(forKey: configKey),
           let decodedConfigs = try? JSONDecoder().decode([AgentConfiguration].self, from: configData) {
            configurations = decodedConfigs
        }
        
        if let sessionData = UserDefaults.standard.data(forKey: sessionKey),
           let decodedSessions = try? JSONDecoder().decode([ChatSession].self, from: sessionData) {
            sessions = decodedSessions
        }
    }
}

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isAgentTyping: Bool = false
    
    let session: ChatSession
    let configuration: AgentConfiguration
    let service: ConnectOnionService
    
    private var messageTask: Task<Void, Never>?
    
    init(session: ChatSession, configuration: AgentConfiguration, service: ConnectOnionService) {
        self.session = session
        self.configuration = configuration
        self.service = service
        
        messages.append(ChatMessage(sessionId: session.id, role: .system, content: "Connected to \(configuration.name)"))
        
        setupBindings()
    }
    
    deinit {
        messageTask?.cancel()
    }
    
    private func setupBindings() {
        messageTask = Task {
            for await text in service.incomingMessages.values {
                if Task.isCancelled { break }
                self.isAgentTyping = false
                let newMessage = ChatMessage(sessionId: self.session.id, role: .agent, content: text)
                self.messages.append(newMessage)
            }
        }
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let msg = ChatMessage(sessionId: session.id, role: .user, content: inputText)
        messages.append(msg)
        
        let textToSend = inputText
        inputText = ""
        isAgentTyping = true
        
        Task {
            if !service.isConnected {
                service.connect(with: configuration)
            }
            await service.sendMessage(textToSend, using: configuration)
        }
    }
}
