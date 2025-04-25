//
//  LastReadView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct LastReadView: View {
    @StateObject private var viewModel = LastReadViewModel()

    var body: some View {
        VStack {
            if let book = viewModel.lastReadBook {
                Text(book.title).font(.title)
                Text(book.author).foregroundColor(.secondary)
            } else {
                Text("You haven’t read any book yet.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.fetchLastReadBook()
        }
        .navigationTitle("Last Read")
    }
}

#Preview {
    LastReadView()
}

