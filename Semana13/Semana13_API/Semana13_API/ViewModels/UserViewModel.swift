//
//  UserViewModel.swift
//  Semana13_API
//

import Foundation
import Combine

// Maneja la logica de red y los datos de usuarios
class UserViewModel: ObservableObject {

    @Published var users: [User] = []

    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedUsers = try JSONDecoder().decode([User].self, from: data)
                    // Se actualiza en el hilo principal para refrescar la vista
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                    }
                } catch {
                    print("Error al decodificar: \(error)")
                }
            } else if let error = error {
                print("Error de red: \(error)")
            }
        }.resume()
    }
}
