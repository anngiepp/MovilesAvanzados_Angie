//
//  User.swift
//  Semana13_API
//

import Foundation

// Codable: convierte entre esta estructura y JSON
// Identifiable: permite que SwiftUI identifique cada elemento de la lista
struct User: Codable, Identifiable {
    let id: Int
    let name: String
}
