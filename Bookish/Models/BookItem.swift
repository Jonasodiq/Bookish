//
//  BookItem.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import Foundation

struct BookItem: Identifiable, Decodable {
    var id: String { key }
    let key: String
    let title: String
    let author_name: [String]?
    let cover_i: Int?

    var author: String {
        author_name?.first ?? "Unknown Author"
    }

    var coverURL: URL? {
        guard let id = cover_i else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(id)-M.jpg")
    }
}

struct SearchResult: Decodable {
    let docs: [BookItem]
}
