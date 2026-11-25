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
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: isEditing ? "pencil" : "person.badge.plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Circle().fill(Color.tinta))

                    Text(isEditing ? "Editar usuario" : "Nuevo usuario")
                        .font(.title2)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre")
                            .font(.caption)
                            .foregroundColor(.tinta.opacity(0.6))
                        TextField("Ej. Angie Portocarrero", text: $name)
                            .textContentType(.name)
                            .padding()
                            .background(Color.celeste)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        Text("Email")
                            .font(.caption)
                            .foregroundColor(.tinta.opacity(0.6))
                            .padding(.top, 8)
                        // verbatim para que el correo de ejemplo no se pinte como enlace
                        TextField(text: $email, prompt: Text(verbatim: "Ej. angie@correo.com")) {
                            Text("Email")
                        }
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.rosa)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        if !email.isEmpty && !emailValido {
                            Text("Ingresa un email válido")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    Button("Guardar") {
                        onSubmit(name, email)
                        dismiss()
                    }
                    .buttonStyle(PillButtonStyle())
                    .disabled(!puedeGuardar)
                    .padding(.top, 10)
                }
                .padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
        .tint(.tinta)
    }
}

#Preview {
    UserFormView(name: "", email: "", isEditing: false) { _, _ in }
}
