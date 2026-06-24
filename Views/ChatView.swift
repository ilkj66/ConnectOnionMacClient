import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                                .id(message.id)
                        }
                        if viewModel.isAgentTyping {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.5)
                                Text("Agent is typing...")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .id("typingIndicator")
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isAgentTyping) { isTyping in
                    if isTyping {
                        withAnimation {
                            proxy.scrollTo("typingIndicator", anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            HStack {
                TextField("Type a message to ConnectOnion agent...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(viewModel.inputText.isEmpty ? .secondary : .accentColor)
                }
                .disabled(viewModel.inputText.isEmpty)
                .buttonStyle(.plain)
                .padding(.horizontal, 8)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .navigationTitle(viewModel.session.title)
        .navigationSubtitle(viewModel.configuration.name)
        .toolbar {
            ToolbarItem(placement: .status) {
                HStack {
                    Circle()
                        .fill(viewModel.service.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(viewModel.service.isConnected ? "Connected" : "Disconnected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.content)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            } else if message.role == .agent {
                Text(message.content)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(NSColor.windowBackgroundColor))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                Spacer()
            } else {
                Spacer()
                Text(message.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Capsule().fill(Color.secondary.opacity(0.1)))
                Spacer()
            }
        }
    }
}
#Preview {
    ContentView()
}
