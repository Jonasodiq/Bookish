//
//  HomeGridView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct HomeGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    HomeCardView(
                        title: "📖 Nya böcker",
                        color: .blue,
                        icon: "book.fill",
                        destination: BookListView()
                    )
                    HomeCardView(
                        title: "📚 Mina böcker",
                        color: .green,
                        icon: "books.vertical",
                        destination: MyBooksView()
                    )
                    HomeCardView(
                        title: "📌 Senast läst",
                        color: .orange,
                        icon: "clock",
                        destination: LastReadView()
                    )
                    HomeCardView(
                        title: "📤 Dela en bok",
                        color: .purple,
                        icon: "square.and.arrow.up",
                        destination: ShareBookView()
                    )
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
        .environmentObject(AuthViewModel())
}

