//
//  MyBooksView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct MyBooksView: View {
  @ObservedObject var viewModel: MyBooksViewModel
    
    @State private var showingAddBook = false

    @State private var showFavoriteAlert = false
    @State private var selectedBook: Book?
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showOnlyFavorites = false

    var body: some View {
      let booksToShow = showOnlyFavorites ? viewModel.myBooks.filter { $0.isFavorite } : viewModel.myBooks

        NavigationStack {
          
          Toggle("Favoriter", isOn: $showOnlyFavorites)
              .padding(.horizontal)
          
            List {
                ForEach(booksToShow) { book in
                  
                    HStack {
                        AsyncImage(url: URL(string: book.coverURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(4)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 75)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(.headline)
                            Text(book.author)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button {
                            selectedBook = book
                            showFavoriteAlert = true
                        } label: {
                            Image(systemName: book.isFavorite ? "star.fill" : "star")
                                .foregroundColor(book.isFavorite ? .yellow : .gray)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }  // : ForEach
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("My Books")
            .toolbar {
  
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddBook.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddBook) {
                AddBookView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchMyBooks()
            }
            .alert("Ändra favoritstatus?", isPresented: $showFavoriteAlert, presenting: selectedBook) { book in
                Button("Ja", role: .destructive) {
                    viewModel.toggleFavorite(for: book)
                    toastMessage = book.isFavorite ? "Borttagen som favorit" : "Markerad som favorit"
                    withAnimation {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
                Button("Avbryt", role: .cancel) { }
            } message: { book in
                Text("Vill du ändra favoritstatus för \"\(book.title)\"?")
            }
            .overlay(
                Group {
                    if showToast {
                        Text(toastMessage)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                            .padding(.top, 80)
                    }
                }, alignment: .top
            )
        }
    } //: - Body
  
  private func deleteBooks(at offsets: IndexSet) {
      for index in offsets {
          let book = viewModel.myBooks[index]
          viewModel.deleteBook(book)
      }
  }


}

#Preview {
    MyBooksView(viewModel: MyBooksViewModel())
}

