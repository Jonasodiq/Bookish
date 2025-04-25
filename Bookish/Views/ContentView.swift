//
//  ContentView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var favoritesViewModel = FavoritesViewModel()
  @StateObject private var myBooksViewModel = MyBooksViewModel()

    var body: some View {
        TabView {
            HomeGridView(myBooksViewModel: myBooksViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

          BookListView(favoritesViewModel: favoritesViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            MyBooksView(viewModel: myBooksViewModel)
                .tabItem {
                    Image(systemName: "book")
                    Text("My Books")
                }

          FavoritesView(viewModel: favoritesViewModel)
              .tabItem {
                  Image(systemName: "star.fill")
                  Text("Favorites")
              }

        }
    }
}

#Preview {
    ContentView()
}


/**
 📖 New Books -> BookListView.swift   <-Lista från API
 📚 My Books ->   MyBooksView.swift   <-Sparade böcker från Firestore
 ⏳ Last Read  -> LastReadView.swift   <-Senaste lästa boken
 📤 Share Book-> ShareBookView.swift <-Möjlighet att dela en bok
 ⭐ Favorites ->   FavoritesView.swift    <-Visar favoriter (med filter)
 */
