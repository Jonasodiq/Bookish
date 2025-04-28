//
//  AddBookView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-25.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MyBooksViewModel

    @State private var title = ""
    @State private var author = ""
    @State private var comment = ""
    @State private var coverURL = ""
    @State private var isFavorite = false

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Book Info")) {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    TextField("Comment", text: $comment)
                    TextField("Cover Image URL", text: $coverURL)
                    Toggle("Mark as Favorite", isOn: $isFavorite)
                }

                Button("Save Book") {
                    if title.isEmpty || author.isEmpty {
                        alertMessage = "Please fill in both title and author."
                        showAlert = true
                        return
                    }
                  
                    viewModel.addBook(
                        title: title,
                        author: author,
                        comment: comment,
                        coverURL: coverURL,
                        isFavorite: isFavorite
                    )
                    showSuccess = true
                }
                .disabled(viewModel.isSaving)
            }
            .navigationTitle("Add New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Saved!", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("The book has been added successfully.")
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    AddBookView(viewModel: MyBooksViewModel())
}
