//
//  MessageBubble.swift
//  Lab14IntroFirebase
//

import SwiftUI

// Burbuja de un mensaje: a la derecha si es mio, a la izquierda si es de otro
struct MessageBubble: View {
    let message: Message
    let isMine: Bool

    var body: some View {
        HStack {
            if isMine {
                Spacer(minLength: 40)
            }

            VStack(alignment: isMine ? .trailing : .leading, spacing: 4) {
                if !isMine {
                    Text(message.userEmail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(message.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isMine ? Color.blue : Color(.secondarySystemBackground))
                    .foregroundColor(isMine ? .white : .primary)
                    .cornerRadius(18)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !isMine {
                Spacer(minLength: 40)
            }
        }
    }
}

#Preview {
    VStack {
        MessageBubble(message: Message(id: "1", text: "Hola!", userEmail: "otro@test.com", timestamp: Date()), isMine: false)
        MessageBubble(message: Message(id: "2", text: "Hola, ¿cómo estás?", userEmail: "yo@test.com", timestamp: Date()), isMine: true)
    }
    .padding()
}
