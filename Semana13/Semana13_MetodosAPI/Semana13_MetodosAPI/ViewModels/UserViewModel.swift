//
//  UserViewModel.swift
//  Semana13_MetodosAPI
//
//  Utilizando los métodos GET - POST - PUT - DELETE
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var searchText: String = ""

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { user in
                user.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // GET: Obtener todos los usuarios
    func fetchUsers() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)

            await MainActor.run {
                self.users = decodedUsers
            }
        } catch {
            print("Error al obtener usuarios: \(error)")
        }
    }

    // POST: Crear un nuevo usuario
    func createUser(name: String, email: String) async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newUser = User(id: 0, name: name, email: email) // id lo ignora el servidor

        do {
            request.httpBody = try JSONEncoder().encode(newUser)
            let (data, _) = try await URLSession.shared.data(for: request)
            let createdUser = try JSONDecoder().decode(User.self, from: data)

            await MainActor.run {
                // La API siempre devuelve id 11, asi que le damos uno que no se repita
                let nuevoId = (self.users.map { $0.id }.max() ?? 0) + 1
                self.users.append(User(id: nuevoId, name: createdUser.name, email: createdUser.email))
            }
        } catch {
            print("Error al crear usuario: \(error)")
        }
    }

    // PUT: Actualizar un usuario existente
    func updateUser(user: User) async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(user.id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(user)
            let (_, _) = try await URLSession.shared.data(for: request)

            await MainActor.run {
                if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                    self.users[index] = user
                    print("Usuario actualizado localmente.")
                } else {
                    print("Usuario no encontrado para actualizar.")
                }
            }
        } catch {
            print("Error al actualizar usuario: \(error)")
        }
    }

    // DELETE: Eliminar un usuario por id
    func deleteUser(id: Int) async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (_, _) = try await URLSession.shared.data(for: request)

            await MainActor.run {
                self.users.removeAll { $0.id == id }
                print("Usuario eliminado localmente (simulado)")
            }
        } catch {
            print("Error al eliminar usuario: \(error)")
        }
    }
}
