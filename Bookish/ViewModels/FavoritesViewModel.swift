//
//  FavoritesViewModel.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-25.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth

class FavoritesViewModel: ObservableObject {
    @Published var favoriteBooks: [Book] = []

    private let db = Firestore.firestore()

    func fetchFavoriteBooks() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("books")
            .whereField("userId", isEqualTo: userId)
            .whereField("isFavorite", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching favorites: \(error.localizedDescription)")
                    return
                }

                self.favoriteBooks = snapshot?.documents.compactMap {
                    try? $0.data(as: Book.self)
                } ?? []
            }
    }
  
  func removeFromFavorites(book: Book) {
      guard let id = book.id else { return }

      db.collection("books")
          .document(id)
          .setData(["isFavorite": false], merge: true) { error in
              if let error = error {
                  print("❌ Failed to remove from favorites: \(error.localizedDescription)")
              } else {
                  // Uppdatera listan efter borttagning
                  self.fetchFavoriteBooks()
              }
          }
  }

  
  func addToFavorites(book: Book) {
      guard let id = book.id else { return }

      db.collection("books")
          .document(id)
          .setData(["isFavorite": true], merge: true) { error in
              if let error = error {
                  print("❌ Failed to add to favorites: \(error.localizedDescription)")
              } else {
                  self.fetchFavoriteBooks()
              }
          }
  }


}
