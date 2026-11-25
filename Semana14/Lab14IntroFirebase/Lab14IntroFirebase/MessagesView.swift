//
//  MessagesView.swift
//  Lab14IntroFirebase
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""

    private let myEmail = Auth.auth().currentUser?.email ?? ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Lista de mensajes
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(databaseService.messages) { message in
                                MessageBubble(message: message, isMine: message.userEmail == myEmail)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .overlay {
                        if databaseService.messages.isEmpty {
                            ContentUnavailableView(
                                "No messages yet",
                                systemImage: "bubble.left.and.bubble.right",
                                description: Text("Send the first message")
                            )
                        }
                    }
                    .onChange(of: databaseService.messages.count) {
                        // Baja al ultimo mensaje cuando llega uno nuevo
                        if let last = databaseService.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                Divider()

                // Nuevo mensaje
                HStack(spacing: 10) {
                    TextField("Type a message...", text: $newMessage)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                        .submitLabel(.send)
                        .onSubmit {
                            sendMessage()
                        }

                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                    }
                    .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out") {
                        try? Auth.auth().signOut()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            databaseService.startListening()
        }
    }

    func sendMessage() {
        let text = newMessage.trimmingCharacters(in: .whitespaces)
        if !text.isEmpty {
            databaseService.addMessage(text: text)
            newMessage = ""
        }
    }
}

#Preview {
    MessagesView()
}
