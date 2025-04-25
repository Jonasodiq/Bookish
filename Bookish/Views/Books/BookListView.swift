//
//  BookListView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI
import FirebaseAuth

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()
    @StateObject private var myBooksViewModel = MyBooksViewModel()
  @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    @State private var query = "Book"
    @State private var showingAddBookView = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
              Button("Add a Book") {
                showingAddBookView = true
              }
              .padding()
              .font(.headline)
              .buttonStyle(.borderedProminent)
              
                Text("Sök efter böcker")
                .font(.title3.bold())
                    .padding(.horizontal)


                TextField("Search books...", text: $query, onCommit: {
                    viewModel.searchBooks(query: query)
                })
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else if viewModel.books.isEmpty {
                    Text("No books found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.books) { book in
                        HStack {
                            AsyncImage(url: book.coverURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 75)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 50, height: 75)
                                }
                            }

                            VStack(alignment: .leading) {
                                Text(book.title).bold()
                                Text(book.author).font(.subheadline).foregroundColor(.secondary)
                            }
                          
                          Spacer()

                           Button {
                               // Skapa en Book och skicka in
                               let newBook = Book(
                                   title: book.title,
                                   author: book.author,
                                   comment: "",
                                   userId: Auth.auth().currentUser?.uid ?? "",
                                   coverURL: book.coverURL?.absoluteString ?? "",
                                   timestamp: Date(),
                                   isFavorite: true
                               )

                               favoritesViewModel.addToFavorites(book: newBook)
                           } label: {
                               Image(systemName: "star")
                           }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("📖 Upptäck böcker")
            .onAppear {
                viewModel.searchBooks(query: query)
            }
            .sheet(isPresented: $showingAddBookView) {
                AddBookView(viewModel: myBooksViewModel)
            }
        }
    }
}

#Preview {
  BookListView( favoritesViewModel: FavoritesViewModel())
}
