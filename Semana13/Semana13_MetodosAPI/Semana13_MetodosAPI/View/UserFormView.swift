//
//  UserFormView.swift
//  Semana13_MetodosAPI
//

import SwiftUI

// Vista para agregar o modificar un usuario
struct UserFormView: View {
    @Environment(\.dismiss) var dismiss

    @State var name: String
    @State var email: String
    var isEditing: Bool
    var onSubmit: (String, String) -> Void

    var emailValido: Bool {
        email.contains("@") && email.contains(".")
    }

    var puedeGuardar: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && emailValido
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $name)
                        .textContentType(.name)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text("Datos del usuario")
                } footer: {
                    if !email.isEmpty && !emailValido {
                        Text("Ingresa un email válido")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(isEditing ? "Editar Usuario" : "Nuevo Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        onSubmit(name, email)
                        dismiss()
                    }
                    .disabled(!puedeGuardar)
                }
            }
        }
    }
}

#Preview {
    UserFormView(name: "", email: "", isEditing: false) { _, _ in }
}
