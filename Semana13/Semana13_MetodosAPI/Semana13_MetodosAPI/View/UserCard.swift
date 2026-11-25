//
//  UserCard.swift
//  Semana13_MetodosAPI
//

import SwiftUI

// Tarjeta de un usuario en la lista
struct UserCard: View {
    let user: User
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            InitialCircle(name: user.name, size: 38)

            Spacer()

            Text(user.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.tinta)
                .lineLimit(2)

            Text(user.email)
                .font(.caption2)
                .foregroundColor(.tinta.opacity(0.6))
                .lineLimit(1)

            HStack {
                Text("Ver perfil")
                    .font(.caption)
                    .foregroundColor(.tinta)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(Color.tinta))
            }
        }
        .padding(16)
        .frame(height: 180)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    UserCard(user: User(id: 1, name: "Leanne Graham", email: "Sincere@april.biz"), color: .celeste)
        .frame(width: 170)
}
