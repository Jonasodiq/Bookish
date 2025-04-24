//
//  HomeGridView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

import SwiftUI

struct HomeGridView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    HomeCard(title: "📖 Nya böcker", color: .blue) {
                        // navigate to BookListView
                    }
                    HomeCard(title: "📚 Mina böcker", color: .green) {
                        // navigate to MyBooksView
                    }
                    HomeCard(title: "📌 Senast läst", color: .orange) {
                        // navigate or show info
                    }
                    HomeCard(title: "📤 Dela en bok", color: .purple) {
                        // share action or navigate
                    }
                }
                .padding()
            }
            .navigationTitle("Bookish")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logga ut") {
                        authViewModel.signOut()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}


#Preview {
    HomeGridView()
}
