import SwiftUI

struct AgentSettingsView: View {
    @State var configuration: AgentConfiguration
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Agent Configuration")) {
                TextField("Name", text: $configuration.name)
                TextField("Agent Address", text: $configuration.agentAddress)
                TextField("Relay URL", text: $configuration.relayURL)
            }
            
            Button("Save Configuration") {
                if let index = appViewModel.configurations.firstIndex(where: { $0.id == configuration.id }) {
                    appViewModel.configurations[index] = configuration
                }
            }
            .padding(.top)
            
            Button("Start Chat") {
                appViewModel.createNewSession(for: configuration)
            }
            .padding(.top)
        }
        .padding()
        .navigationTitle("Settings: \(configuration.name)")
        .frame(minWidth: 300, minHeight: 200)
    }
}
