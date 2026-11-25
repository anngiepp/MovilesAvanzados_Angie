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

    let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        header

                        summaryCard
                            .padding(.horizontal)

                        Text("Todos los usuarios")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)

                        userList
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }
                .ignoresSafeArea(edges: .top)
                .refreshable {
                    await viewModel.fetchUsers()
                }

                // Boton para agregar
                Button {
                    editingUser = nil
                    showingForm = true
                } label: {
                    Label("Agregar usuario", systemImage: "plus")
                }
                .buttonStyle(PillButtonStyle())
                .padding(.horizontal, 50)
                .padding(.bottom, 8)
            }
            .toolbar(.hidden, for: .navigationBar)
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
        .tint(.tinta)
    }

    // Cabecera celeste con el buscador
    var header: some View {
        ZStack {
            Color.celeste

            DotsPattern(rows: 3, columns: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 70)
                .padding(.leading, 24)

            Circle()
                .stroke(Color.white.opacity(0.7), lineWidth: 18)
                .frame(width: 140, height: 140)
                .offset(x: 150, y: -40)

            VStack(spacing: 10) {
                Image(systemName: "person.2.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(Circle().fill(Color.tinta))

                Text("Usuarios")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Conecta con tu comunidad")
                    .foregroundColor(.tinta.opacity(0.7))

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Buscar usuario por nombre", text: $viewModel.searchText)
                        .autocorrectionDisabled()
                }
                .padding(12)
                .background(Color.white)
                .clipShape(Capsule())
                .padding(.top, 6)
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 26)
        }
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 36, bottomTrailingRadius: 36))
    }

    // Tarjeta negra con el total de usuarios
    var summaryCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Comunidad")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text("\(viewModel.users.count) usuarios")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.title2)
                .foregroundColor(.tinta)
                .frame(width: 48, height: 48)
                .background(Circle().fill(Color.white))
        }
        .padding(20)
        .background(Color.tinta)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    // Lista de tarjetas en dos columnas
    @ViewBuilder
    var userList: some View {
        if viewModel.isLoading && viewModel.users.isEmpty {
            ProgressView("Cargando usuarios...")
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
        } else if viewModel.filteredUsers.isEmpty && !viewModel.searchText.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else if viewModel.users.isEmpty {
            ContentUnavailableView(
                "Sin usuarios",
                systemImage: "person.2.slash",
                description: Text("Jala hacia abajo para volver a cargar")
            )
        } else {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(Array(viewModel.filteredUsers.enumerated()), id: \.element.id) { index, user in
                    NavigationLink {
                        UserDetailView(viewModel: viewModel, userId: user.id)
                    } label: {
                        UserCard(user: user, color: index % 2 == 0 ? .celeste : .rosa)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            editingUser = user
                            showingForm = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }

                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteUser(id: user.id)
                            }
                        } label: {
                            Label("Eliminar", systemImage: "trash")
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
