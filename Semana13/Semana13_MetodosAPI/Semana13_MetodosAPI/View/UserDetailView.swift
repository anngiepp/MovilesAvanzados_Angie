//
//  UserDetailView.swift
//  Semana13_MetodosAPI
//

import SwiftUI

// Perfil de un usuario, desde aqui se puede editar o eliminar
struct UserDetailView: View {
    @ObservedObject var viewModel: UserViewModel
    let userId: Int

    @Environment(\.dismiss) var dismiss
    @State private var showingForm = false
    @State private var showingDeleteAlert = false

    // Se busca en el ViewModel para que se vea actualizado despues de editar
    var user: User? {
        viewModel.users.first { $0.id == userId }
    }

    var body: some View {
        ScrollView {
            if let user = user {
                VStack(spacing: 24) {
                    // Cabecera del perfil
                    ZStack {
                        Color.celeste

                        DotsPattern(rows: 3, columns: 4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(20)

                        Circle()
                            .stroke(Color.white.opacity(0.7), lineWidth: 16)
                            .frame(width: 110, height: 110)
                            .offset(x: -140, y: 70)

                        VStack(spacing: 12) {
                            InitialCircle(name: user.name, size: 96)

                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)

                            Text(user.email)
                                .foregroundColor(.tinta.opacity(0.7))
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 32))

                    // Datos del usuario
                    VStack(spacing: 0) {
                        InfoRow(icon: "number", title: "ID", value: "\(user.id)")
                        Divider()
                        InfoRow(icon: "person", title: "Nombre", value: user.name)
                        Divider()
                        InfoRow(icon: "envelope", title: "Email", value: user.email)
                    }
                    .padding(.horizontal)
                    .background(Color.rosa.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    // Acciones
                    VStack(spacing: 12) {
                        Button {
                            showingForm = true
                        } label: {
                            Label("Editar usuario", systemImage: "pencil")
                        }
                        .buttonStyle(PillButtonStyle())

                        Button {
                            showingDeleteAlert = true
                        } label: {
                            Label("Eliminar usuario", systemImage: "trash")
                        }
                        .buttonStyle(PillButtonStyle(filled: false, color: .red))
                    }
                    .padding(.horizontal, 30)
                }
                .padding()
            }
        }
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingForm) {
            if let user = user {
                UserFormView(name: user.name, email: user.email, isEditing: true) { name, email in
                    let updated = User(id: user.id, name: name, email: email)
                    Task {
                        await viewModel.updateUser(user: updated)
                    }
                }
            }
        }
        .alert("¿Eliminar usuario?", isPresented: $showingDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                Task {
                    await viewModel.deleteUser(id: userId)
                    dismiss()
                }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
    }
}

// Fila con un dato del perfil
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 34, height: 34)
                .background(Circle().fill(Color.tinta))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.tinta.opacity(0.6))
                Text(value)
                    .foregroundColor(.tinta)
            }

            Spacer()
        }
        .padding(.vertical, 12)
    }
}
