//
//  ContentView.swift
//  Semana13_MetodosAPI
//
//  Created by Tecsup on 23/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    @State private var showingForm = false
    @State private var editingUser: User? = nil

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.users.isEmpty {
                    ProgressView("Cargando usuarios...")
                } else if viewModel.filteredUsers.isEmpty && !viewModel.searchText.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                } else if viewModel.users.isEmpty {
                    ContentUnavailableView(
                        "Sin usuarios",
                        systemImage: "person.2.slash",
                        description: Text("Revisa tu conexión e inténtalo de nuevo")
                    )
                } else {
                    List(viewModel.filteredUsers) { user in
                        UserRow(user: user)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteUser(id: user.id)
                                    }
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    editingUser = user
                                    showingForm = true
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                    .refreshable {
                        await viewModel.fetchUsers()
                    }
                }
            }
            .navigationTitle("Usuarios")
            .searchable(text: $viewModel.searchText, prompt: "Buscar usuario por nombre")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editingUser = nil
                        showingForm = true
                    } label: {
                        Label("Agregar Usuario", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                // Solo carga la primera vez para no perder los usuarios agregados
                if viewModel.users.isEmpty {
                    Task {
                        await viewModel.fetchUsers()
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                if let user = editingUser {
                    UserFormView(name: user.name, email: user.email, isEditing: true) { name, email in
                        let updated = User(id: user.id, name: name, email: email)
                        Task {
                            await viewModel.updateUser(user: updated)
                        }
                    }
                } else {
                    UserFormView(name: "", email: "", isEditing: false) { name, email in
                        Task {
                            await viewModel.createUser(name: name, email: email)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
