//
//  MyBooksViewModel.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MyBooksViewModel: ObservableObject {
    @Published var myBooks: [Book] = []
    @Published var isSaving = false

    private let db = Firestore.firestore()

    // MARK: - Fetch all books for current user
    func fetchMyBooks() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
      
      print("Aktuell användare:", userId) // Temp
      print("Hämtar böcker...") // Temp

        db.collection("books")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching books: \(error.localizedDescription)")
                    return
                }

                self.myBooks = snapshot?.documents.compactMap {
                    try? $0.data(as: Book.self)
                } ?? []
              
            }
    }

    // MARK: - Add new book
  func addBook(title: String, author: String, comment: String, coverURL: String, isFavorite: Bool) {
      guard let userId = Auth.auth().currentUser?.uid else {
          print("❌ No user logged in")
          return
      }

      isSaving = true

      let newBook = Book(
          title: title,
          author: author,
          comment: comment,
          userId: userId,
          coverURL: coverURL,
          timestamp: Date(),
          isFavorite: isFavorite
      )

      do {
          _ = try db.collection("books").addDocument(from: newBook) { [weak self] error in
              DispatchQueue.main.async {
                  self?.isSaving = false
                  if let error = error {
                      print("❌ Error saving book: \(error.localizedDescription)")
                  } else {
                      print("✅ Book saved successfully!")
                      self?.fetchMyBooks()
                  }
              }
          }
      } catch {
          print("❌ Firestore encoding error: \(error.localizedDescription)")
          isSaving = false
      }
  }


    // MARK: - Toggle favorite status
  func toggleFavorite(for book: Book) {
      guard let id = book.id else { return }

      let newValue = !book.isFavorite

      db.collection("books")
          .document(id)
          .setData(["isFavorite": newValue], merge: true) { error in
              if let error = error {
                  print("❌ Failed to update favorite: \(error.localizedDescription)")
              } else {
                  self.fetchMyBooks()
              }
          }
  }
  
  func deleteBook(_ book: Book) {
      guard let id = book.id else { return }

      db.collection("books")
          .document(id)
          .delete { [weak self] error in
              if let error = error {
                  print("❌ Failed to delete book: \(error.localizedDescription)")
              } else {
                  print("✅ Book deleted successfully")
                  self?.fetchMyBooks() // Ladda om böckerna
              }
          }
  }


}

