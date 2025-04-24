//
//  BookListViewModel.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import Foundation

class BookListViewModel: ObservableObject {
    @Published var books: [BookItem] = []
    @Published var isLoading = false

    private let service = BookAPIService()

    func searchBooks(query: String) {
        isLoading = true
        service.fetchBooks(query: query) { [weak self] result in
            self?.books = result
            self?.isLoading = false
        }
    }
}
