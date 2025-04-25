//
//  BookAPIService.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import Foundation

class BookAPIService {
    func fetchBooks(query: String = "swift", completion: @escaping ([BookItem]) -> Void) {
        let urlString = "https://openlibrary.org/search.json?q=\(query)&limit=20"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
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
