//
//  BookListView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI
import FirebaseAuth

enum SearchType: String, CaseIterable, Identifiable {
    case title = "Titel"
    case author = "Författare"
    
    var id: String { self.rawValue }
}

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()
    @StateObject private var myBooksViewModel = MyBooksViewModel()
    @ObservedObject var favoritesViewModel: FavoritesViewModel

    @State private var query = "Book"
    @State private var selectedLanguage = languageOptions[0]
    @State private var selectedSearchType: SearchType = .title 

    var body: some View {
      
        NavigationStack {
          ZStack {
            Color.green.opacity(0.1).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 8) {
              
              VStack(alignment: .leading,spacing: 8) {
                // Sökfält
                TextField("Sök...", text: $query)
                  .textFieldStyle(.roundedBorder)
                  .padding()
                
                // Picker för sökkategori
                HStack {
                  Text("Sök enligt:")
                    .font(.subheadline.bold())
                    .padding(.leading)
                  
                  Picker("Sök efter", selection: $selectedSearchType) {
                    ForEach(SearchType.allCases) { type in
                      Text(type.rawValue).tag(type)
                    }
                  }
                  .pickerStyle(.segmented)
                }
                .padding(.horizontal)
              }
              
              // Språkval
              VStack(alignment: .leading) {
                HStack {
                  Text("Välj språk:")
                    .font(.subheadline.bold())
                    .padding(.horizontal)
                  Picker("Select Language", selection: $selectedLanguage) {
                    ForEach(languageOptions) { option in
                      Text("\(option.flag) \(option.name)").tag(option)
                    }
                  }
                  .pickerStyle(.wheel)
                  .frame(height: 100)
                  .clipped()
                  .onChange(of: selectedLanguage) {
                    viewModel.searchBooks(query: query, language: selectedLanguage.code, searchType: selectedSearchType)
                  }
                }
                
                // Sök-knapp
                Button(action: {
                  viewModel.searchBooks(query: query, language: selectedLanguage.code, searchType: selectedSearchType)
                }) {
                  if viewModel.isLoading {
                    ProgressView()
                      .progressViewStyle(CircularProgressViewStyle(tint: .white))
                      .frame(maxWidth: .infinity)
                  } else {
                    HStack {
                      Image(systemName: "magnifyingglass")
                      Text("Sök")
                        .fontWeight(.bold)
                    }
                  }
                }
                .primaryButton()
                .disabled(query.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(query.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                
              }
              .padding(.horizontal)
              
              // Resultat
              if viewModel.isLoading && viewModel.books.isEmpty {
                ProgressView()
                  .frame(maxWidth: .infinity)
              } else if viewModel.books.isEmpty {
                VStack {
                  Text("Inga böcker hittades på \(selectedLanguage.name).")
                    .foregroundColor(.gray)
                    .padding(.top, 40)
                  Spacer()
                }
                .frame(maxWidth: .infinity)
              } else {
                List(viewModel.books) { book in
                  NavigationLink(destination: BookDetailView(book: book)) {
                    HStack {
                      AsyncImage(url: book.coverURL) { phase in
                        if let image = phase.image {
                          image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 75)
                        } else {
                          Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 75)
                        }
                      }
                      
                      VStack(alignment: .leading) {
                        Text(book.title).bold()
                        Text(book.author)
                          .font(.subheadline)
                          .foregroundColor(.secondary)
                      }
                    }
                    .padding(.vertical, 4)
                  }
                }
                .listStyle(PlainListStyle())
              }
            }
            .navigationTitle("📖 Upptäck böcker")
            .onAppear {
              viewModel.searchBooks(query: query, language: selectedLanguage.code, searchType: selectedSearchType)
            }
          }
          }
    }
}

#Preview {
    BookListView(favoritesViewModel: FavoritesViewModel())
}



