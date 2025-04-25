//
//  MyBooksView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct MyBooksView: View {
    @StateObject private var viewModel = MyBooksViewModel()
    @State private var showingAddBook = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.myBooks) { book in
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

                        Button(action: {
                            viewModel.toggleFavorite(for: book)
                        }) {
                            Image(systemName: book.isFavorite ? "star.fill" : "star")
                                .foregroundColor(book.isFavorite ? .yellow : .gray)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("My Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddBook.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBook) {
                AddBookView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchMyBooks()
            }
        }
    }
}

#Preview {
    MyBooksView()
}
