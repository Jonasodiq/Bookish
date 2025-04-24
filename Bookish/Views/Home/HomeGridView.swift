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
    @EnvironmentObject var authViewModel: AuthViewModel


    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    HomeCardView(title: "📖 Nya böcker", color: .blue) {
                        // navigate to BookListView
                    }
                    HomeCardView(title: "📚 Mina böcker", color: .green) {
                        // navigate to MyBooksView
                    }
                    HomeCardView(title: "📌 Senast läst", color: .orange) {
                        // navigate or show info
                    }
                    HomeCardView(title: "📤 Dela en bok", color: .purple) {
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
