//
//  ContentView.swift
//  Semana13_API
//
//  Created by Tecsup on 23/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                Text(user.name) // Solo el nombre
            }
            .navigationTitle("Usuarios - API")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}
