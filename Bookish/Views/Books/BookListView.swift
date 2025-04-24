//
//  BookListView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()
    @State private var query = "Search..."

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search books...", text: $query, onCommit: {
                    viewModel.searchBooks(query: query)
                })
                .textFieldStyle(.roundedBorder)
                .padding()

                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.books.isEmpty {
                    Text("No books found")
                        .foregroundColor(.gray)
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
                        }
                    }
                }
            }
            .navigationTitle("Browse Books")
            .onAppear {
                viewModel.searchBooks(query: query)
            }
        }
    }
}


#Preview {
    BookListView()
}
