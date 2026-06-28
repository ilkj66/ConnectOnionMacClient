# ConnectOnion macOS Client Starter Code

This is a starter codebase for the native macOS ConnectOnion client written in SwiftUI. It provides the architectural foundation and minimum viable functionality outlined in the project requirements.

## What's Included

- **Data Models (`Models.swift`)**: Includes models for `AgentConfiguration`, `ChatSession`, and `ChatMessage`.
- **ConnectOnion SDK Service (`ConnectOnionService.swift`)**: A starter service that wraps the `connectonion-swift` SDK. It builds an `OpenAIClient`, creates a `ConnectOnion.Agent`, and sends chat input through `agent.input(...)`.
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

## Configuration

Create or edit an agent configuration in the app:

- **API Key**: OpenAI-compatible API key.
- **Base URL**: OpenAI-compatible backend URL, for example `https://api.openai.com/v1`.
- **Model**: Chat model name, for example `gpt-4o-mini`.
- **System Prompt**: Optional behavior prompt for the agent.

## Next Steps for Development

- Add local persistence (CoreData/SwiftData or `UserDefaults`) for saving configurations and chat history securely.
- Enhance the UI/UX with smooth animations, custom loading states, and error handling dialogs.
