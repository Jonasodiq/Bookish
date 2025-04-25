//
//  LastReadViewModel.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LastReadViewModel: ObservableObject {
    @Published var lastReadBook: Book?

    private let db = Firestore.firestore()

    func fetchLastReadBook() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).getDocument { snapshot, error in
            if let doc = snapshot, let bookId = doc["lastReadBookId"] as? String {
                self.db.collection("books").document(bookId).getDocument { snap, err in
                    if let data = snap, let book = try? data.data(as: Book.self) {
                        self.lastReadBook = book
                    }
                }
            }
        }
    }
}
