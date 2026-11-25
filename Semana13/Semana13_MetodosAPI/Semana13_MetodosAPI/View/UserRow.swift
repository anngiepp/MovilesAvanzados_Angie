//
//  UserRow.swift
//  Semana13_MetodosAPI
//

import SwiftUI

// Fila de la lista con la inicial del usuario en un circulo
struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            Text(String(user.name.prefix(1)))
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.blue))

            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    UserRow(user: User(id: 1, name: "Leanne Graham", email: "Sincere@april.biz"))
}
