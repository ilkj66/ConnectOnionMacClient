import SwiftUI

struct SidebarView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        List(selection: $appViewModel.selection) {
            Section(header: Text("Sessions")) {
                ForEach(appViewModel.sessions) { session in
                    NavigationLink(value: NavigationItem.session(session.id)) {
                        Label(session.title, systemImage: "bubble.left.and.bubble.right")
                    }
                }
            }
            
            Section(header: Text("Configurations")) {
                ForEach(appViewModel.configurations) { config in
                    NavigationLink(value: NavigationItem.configuration(config.id)) {
                        Label(config.name, systemImage: "gearshape")
                    }
                }
                
                Button(action: {
                    let newConfig = AgentConfiguration(
                        name: "New Agent",
                        apiKey: "",
                        baseURL: "https://api.openai.com/v1",
                        model: "gpt-4o-mini",
                        systemPrompt: "You are a helpful assistant."
                    )
                    appViewModel.configurations.append(newConfig)
                    appViewModel.selection = .configuration(newConfig.id)
                }) {
                    Label("Add Agent", systemImage: "plus")
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("ConnectOnion")
    }
}
