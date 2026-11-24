//
//  DatabaseService.swift
//  Lab14IntroFirebase
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class DatabaseService: ObservableObject {

    private let db = Firestore.firestore()
    @Published var messages: [Message] = []

    // Agrega un mensaje a la base de datos
    func addMessage(text: String) {

        guard let user = Auth.auth().currentUser else { return }

        let message = Message(
            id: UUID().uuidString,
            text: text,
            userEmail: user.email ?? "Unknown",
            timestamp: Date()
        )

        do {
            print("message \(message.userEmail)")
            try db.collection("messages").document(message.id).setData(from: message)
        } catch {
            print("Error adding message: \(error)")
        }
    }

    // Escucha los cambios en tiempo real
    func startListening() {
        db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting messages: \(error)")
                    return
                }

                self.messages = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }
}

// Modelo de un mensaje
struct Message: Identifiable, Codable {
    let id: String
    let text: String
    let userEmail: String
    let timestamp: Date
}
