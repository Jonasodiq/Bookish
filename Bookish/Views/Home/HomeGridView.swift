//
//  HomeGridView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct HomeGridView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject private var myBooksViewModel = MyBooksViewModel()
  
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                  
                  HomeCardView(
                        title: "✏️ Ny bok",
                        color: .orange,
                        icon: "square.and.pencil",
                        destination: AddBookView(viewModel: myBooksViewModel)
                    )
                  
                    HomeCardView(
                        title: "📖 Böcker",
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
                        color: .yellow,
                        icon: "clock",
                        destination: LastReadView()
                    )
                    HomeCardView(
                        title: "📤 Share book",
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
