//
//  FavoritesView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct FavoritesView: View {
  @ObservedObject var viewModel: FavoritesViewModel

    @State private var showAlert = false
    @State private var bookToRemove: Book?

    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.favoriteBooks) { book in
                    HStack {
                        AsyncImage(url: URL(string: book.coverURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(4)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 75)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(book.title).font(.headline)
                            Text(book.author).font(.subheadline).foregroundColor(.secondary)
                        }

                        Spacer()

                        Button {
                            bookToRemove = book
                            showAlert = true
                        } label: {
                            Image(systemName: "star.slash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("⭐ Favoriter")
            .onAppear {
                viewModel.fetchFavoriteBooks()
            }
            .alert("Ta bort från favoriter?", isPresented: $showAlert, presenting: bookToRemove) { book in
                Button("Ta bort", role: .destructive) {
                    viewModel.removeFromFavorites(book: book)
                    toastMessage = "Borttagen från favoriter ✅"
                    withAnimation {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
                Button("Avbryt", role: .cancel) { }
            } message: { book in
                Text("Vill du ta bort \"\(book.title)\" från dina favoriter?")
            }
            .overlay(
                Group {
                    if showToast {
                        Text(toastMessage)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                            .padding(.top, 80)
                    }
                }, alignment: .top
            )
        }
    }
}

#Preview {
  FavoritesView(viewModel: FavoritesViewModel())
}
