import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(appViewModel: appViewModel)
        } detail: {
            switch appViewModel.selection {
            case .session(let sessionId):
                if let session = appViewModel.sessions.first(where: { $0.id == sessionId }),
                   let config = appViewModel.configurations.first(where: { $0.id == session.agentConfigId }) {
                    // Caching ViewModel would be better, but this works for starter code
                    let service = ConnectOnionService()
                    let chatViewModel = ChatViewModel(session: session, configuration: config, service: service)
                    ChatView(viewModel: chatViewModel)
                } else {
                    Text("Session not found")
                        .foregroundColor(.secondary)
                }
                
            case .configuration(let configId):
                if let config = appViewModel.configurations.first(where: { $0.id == configId }) {
                    AgentSettingsView(configuration: config, appViewModel: appViewModel)
                } else {
                    Text("Configuration not found")
                        .foregroundColor(.secondary)
                }
                
            case .none:
                Text("Select a session or configure an agent to begin.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
#Preview {
    ContentView()
}
