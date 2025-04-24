//
//  Book.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import Foundation
import FirebaseFirestore

struct Book: Identifiable, Codable {
    @DocumentID var id: String?
    
    let title: String
    let author: String
    let comment: String
    let userId: String
    let coverURL: String
    let timestamp: Date
    
    var isFavorite: Bool = false
}
