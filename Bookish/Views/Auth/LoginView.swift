//
//  LoginView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isNewUser = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack {
            Text(isNewUser ? "Sign Up" : "Sign In")
                .font(.largeTitle.bold())
                .padding(.bottom, 20)

            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }

                if isLoading {
                    ProgressView()
                        .padding()
                }

                Button(isNewUser ? "Create Account" : "Login") {
                    authenticate()
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                .buttonStyle(.borderedProminent)
                .padding(.top)

                Button("Switch to \(isNewUser ? "Login" : "Sign Up")") {
                    isNewUser.toggle()
                    errorMessage = nil
                }
                .font(.footnote)
                .padding(.top, 5)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding()
        }
    }

    func authenticate() {
        errorMessage = nil
        isLoading = true

        if isNewUser {
            authViewModel.signUp(email: email, password: password) { error in
                finishAuth(error: error)
            }
        } else {
            authViewModel.signIn(email: email, password: password) { error in
                finishAuth(error: error)
            }
        }
    }

    func finishAuth(error: String?) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = error
        }
    }
}

#Preview {
    LoginView()
}
