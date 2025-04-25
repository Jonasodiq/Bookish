//
//  AuthViewModel.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        listenToAuthState()
    }

    func listenToAuthState() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    func signIn(email: String, password: String, completion: @escaping (String?) -> Void = {_ in }) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (String?) -> Void = {_ in }) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Sign-out error: \(error.localizedDescription)")
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
