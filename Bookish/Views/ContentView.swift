//
//  ContentView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        TabView {
            HomeGridView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Hem")
                }

            BookListView() // sök-vy från API
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Sök")
                }

            MyBooksView() // placeholder
                .tabItem {
                    Image(systemName: "book")
                    Text("Mina böcker")
                }

            FavoritesView() // placeholder
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favoriter")
                }
        }
    }
}



#Preview {
    ContentView()
}
