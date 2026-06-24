import SwiftUI

@main
struct ConnectOnionMacClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
        }
        .commands {
            SidebarCommands()
        }
    }
}
