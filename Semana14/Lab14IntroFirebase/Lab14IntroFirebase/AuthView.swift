//
//  AuthView.swift
//  Lab14IntroFirebase
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authStateListener: AuthStateDidChangeListenerHandle?

    var body: some View {
        Group {
            if isSignedIn {
                // Muestra los mensajes cuando ya inicio sesion
                MessagesView()
            } else {
                loginForm
            }
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onChange(of: isSignedIn) {
            // Limpia el formulario al cerrar sesion
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }

    // Formulario de inicio de sesion
    var loginForm: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)

                Text("Lab 14: Firebase")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Sign in or create an account")
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Password (min. 6 characters)", text: $password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }

            if isLoading {
                ProgressView()
                    .padding()
            } else {
                VStack(spacing: 12) {
                    Button("Sign In") {
                        signIn()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    Button("Sign Up") {
                        signUp()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 30)
    }

    // MARK: - Authentication Functions

    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Sign in failed: \(error.localizedDescription)"
                showAlert = true
                print("error.localizedDescription: '\(error.localizedDescription)'")
            } else {
                isSignedIn = true
                alertMessage = "Sign in successful!"
                showAlert = true
            }
        }
    }

    func signUp() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                isSignedIn = true
                alertMessage = "Account created successfully!"
                showAlert = true
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            alertMessage = "Signed out successfully"
            showAlert = true
        } catch {
            alertMessage = "Sign out failed: \(error.localizedDescription)"
            showAlert = true
        }
    }

    func checkAuthState() {
        // Escucha los cambios de sesion y guarda el listener
        authStateListener = Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isSignedIn = user != nil
            }
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AuthView()
}
