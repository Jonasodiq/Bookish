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

  func searchBooks(query: String, language: String, searchType: SearchType) {
      isLoading = true
      service.fetchBooks(query: query, language: language, searchType: searchType) { [weak self] result in
          DispatchQueue.main.async {
              self?.books = result
              self?.isLoading = false
          }
      }
  }
}

