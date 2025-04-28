//
//  BookAPIService.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import Foundation

class BookAPIService {
    func fetchBooks(query: String = "swift", language: String = "", searchType: SearchType, completion: @escaping ([BookItem]) -> Void) {
        var urlString = "https://openlibrary.org/search.json?"
        
        switch searchType {
        case .title:
            urlString += "title=\(query)"
        case .author:
            urlString += "author=\(query)"
        }
        
        urlString += "&limit=20"
        
        // Lägg till språkfilter om det finns
        if !language.isEmpty {
            urlString += "&language=\(language)"
        }
        
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }

            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    completion(result.docs)
                }
            } catch {
                print("❌ Decode error:", error)
                completion([])
            }
        }.resume()
    }
}
