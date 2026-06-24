# ConnectOnion macOS Client Starter Code

This is a starter codebase for the native macOS ConnectOnion client written in SwiftUI. It provides the architectural foundation and minimum viable functionality outlined in the project requirements.

## What's Included

- **Data Models (`Models.swift`)**: Includes models for `AgentConfiguration`, `ChatSession`, and `ChatMessage`.
- **WebSocket Service (`ConnectOnionService.swift`)**: A starter service for connecting to ConnectOnion's relay network using `URLSessionWebSocketTask`. It includes basic `sendMessage` and `receiveMessage` logic.
- **ViewModels (`ViewModels/ViewModels.swift`)**: Contains `AppViewModel` for managing global state (configurations and sessions) and `ChatViewModel` for individual chat sessions.
- **UI Views (`Views/`)**:
  - `ContentView.swift`: Main split view with a navigation structure.
  - `SidebarView.swift`: Displays active sessions and saved agent configurations.
  - `ChatView.swift`: The main chat interface allowing users to see conversation history and send messages.
  - `AgentSettingsView.swift`: Form to edit and save connection details (Name, Address, Relay URL).
- **App Entry Point (`ConnectOnionMacClientApp.swift`)**: The main App struct.

## How to use this starter code

1. Open Xcode and create a new **macOS App** project using **SwiftUI**.
2. Delete the default `ContentView.swift` and `<YourAppName>App.swift` files.
3. Drag and drop all the provided `.swift` files into your Xcode project.
4. Build and run the project!

## Next Steps for Development

- Implement actual message payload formatting according to the ConnectOnion network spec in `ConnectOnionService.swift`.
- Add local persistence (CoreData/SwiftData or `UserDefaults`) for saving configurations and chat history securely.
- Enhance the UI/UX with smooth animations, custom loading states, and error handling dialogs.
