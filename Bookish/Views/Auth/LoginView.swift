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
    @FocusState private var focusedField: Field?

    enum Field {
        case email
        case password
    }


    var body: some View {
      
      ZStack {
        Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
        VStack(alignment: .center, spacing: 32) {
          
          Image(systemName: "person.badge.key")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
          
          
          // MARK: - Card
          VStack(spacing: 24) {
            // MARK: - TextField
            VStack {
              Text(isNewUser ? "Sign Up" : "Sign In")
                .font(.largeTitle.bold())
                .foregroundColor(.blue)
              
              TextField("Email", text: $email)
                  .textFieldStyle(.roundedBorder)
                  .keyboardType(.emailAddress)
                  .autocapitalization(.none)
                  .submitLabel(.next)
                  .focused($focusedField, equals: .email)
                  .onSubmit {
                      focusedField = .password
                  }

              SecureField("Password", text: $password)
                  .textFieldStyle(.roundedBorder)
                  .submitLabel(.go)
                  .focused($focusedField, equals: .password)
                  .onSubmit {
                      authenticate()
                  }
              
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
            } //: - VStack
            // MARK: - BUTTONS
            VStack(spacing: 16) {
              Button(isNewUser ? "Skapa Konto" : "Logga In") {
                authenticate()
              }
              .primaryButton()
              
              Button("Byt till / \(isNewUser ? "Logga In" : "Skapa Konto")") {
                isNewUser.toggle()
                errorMessage = nil
              }
              .secondaryButton()
            } //: - VStack
          }  //: - VStack Card
          .padding()
          .background(Color(.secondarySystemBackground))
          .cornerRadius(12)
          .shadow(radius: 4)
          .padding()
        } //: - VStack
      } //: - ZStack
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
