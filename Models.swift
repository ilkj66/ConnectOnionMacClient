import Foundation

struct AgentConfiguration: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var apiKey: String
    var baseURL: String
    var model: String
    var systemPrompt: String
    var isConnected: Bool = false
}

struct ChatSession: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var agentConfigId: UUID
    var title: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

enum MessageRole: String, Codable {
    case user
    case agent
    case system
}

struct ChatMessage: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var sessionId: UUID
    var role: MessageRole
    var content: String
    var timestamp: Date = Date()
    var isStreaming: Bool = false
    var status: MessageStatus = .sent
}

enum MessageStatus: String, Codable {
    case sending
    case sent
    case error
}
