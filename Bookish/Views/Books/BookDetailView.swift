//
//  BookDetailView.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookDetailView: View {
    @StateObject private var myBooksViewModel = MyBooksViewModel()
    let book: BookItem

    @State private var comment = ""
    @State private var isFavorite = false
    @State private var isBookSaved = false
    @State private var showToast = false
    @State private var descriptionText = "Laddar beskrivning..."

    @State private var canReadOnline: Bool?
    @State private var isCheckingAvailability = true

    private let db = Firestore.firestore()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: book.coverURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                    }
                }
                .shadow(radius: 4)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Toggle("Favorit", isOn: $isFavorite)

                    if isCheckingAvailability {
                      ProgressView()
                      .padding()
                    } else {
                        if canReadOnline == true {
                            if let readURL = URL(string: "https://openlibrary.org\(book.key)/borrow") {
                                Link("📖 Läs gratis nu!", destination: readURL)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        } else {
                            if let openLibraryURL = URL(string: "https://openlibrary.org\(book.key)") {
                                Link("ℹ️ Läs mer om boken", destination: openLibraryURL)
                                    .font(.subheadline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }

                    Button(isBookSaved ? "Uppdatera Bok" : "Spara i Mina Böcker") {
                        if isBookSaved {
                            updateBook()
                        } else {
                            addBook()
                        }
                    }
                    .primaryButton()
                    .bold()
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)

            Divider()

            Text(book.title)
                .font(.title2)
                .bold()

            Text(book.author)
                .font(.title3)
                .foregroundColor(.secondary)

            ScrollView {
                Text(descriptionText)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.leading)
            }
            .frame(height: 250)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)

            TextField("Skriv en kommentar...", text: $comment)
                .textFieldStyle(.roundedBorder)

            Spacer()
        }
        .padding()
        .navigationTitle("Bokinfo")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchBookDescription()
            checkIfBookSaved()
            checkReadAvailability()
        }
        .overlay(
            Group {
                if showToast {
                    Text("✅ Sparat!")
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

    private func fetchBookDescription() {
        let workId = book.key.replacingOccurrences(of: "/works/", with: "")
        guard let url = URL(string: "https://openlibrary.org/works/\(workId).json") else {
            descriptionText = "Ingen beskrivning tillgänglig."
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                DispatchQueue.main.async {
                    if let desc = json["description"] as? String {
                        descriptionText = desc
                    } else if let descObj = json["description"] as? [String: Any],
                              let value = descObj["value"] as? String {
                        descriptionText = value
                    } else {
                        descriptionText = "Ingen beskrivning tillgänglig."
                    }
                }
            }
        }.resume()
    }

    private func checkReadAvailability() {
        let workId = book.key.replacingOccurrences(of: "/works/", with: "")
        guard let url = URL(string: "https://openlibrary.org/works/\(workId).json") else {
            self.isCheckingAvailability = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            defer { DispatchQueue.main.async { self.isCheckingAvailability = false } }

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                DispatchQueue.main.async {
                    if let availability = json["availability"] as? [String: Any],
                       let readable = availability["is_readable"] as? Bool {
                        self.canReadOnline = readable
                    } else {
                        self.canReadOnline = false
                    }
                }
            }
        }.resume()
    }

    private func checkIfBookSaved() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("books")
            .whereField("userId", isEqualTo: userId)
            .whereField("title", isEqualTo: book.title)
            .whereField("author", isEqualTo: book.author)
            .getDocuments { snapshot, error in
                if let doc = snapshot?.documents.first,
                   let savedBook = try? doc.data(as: Book.self) {
                    DispatchQueue.main.async {
                        comment = savedBook.comment
                        isFavorite = savedBook.isFavorite
                        isBookSaved = true
                    }
                }
            }
    }

    private func addBook() {
        myBooksViewModel.addBook(
            title: book.title,
            author: book.author,
            comment: comment,
            coverURL: book.coverURL?.absoluteString ?? "",
            isFavorite: isFavorite
        )
        showSuccess()
        isBookSaved = true
    }

    private func updateBook() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("books")
            .whereField("userId", isEqualTo: userId)
            .whereField("title", isEqualTo: book.title)
            .whereField("author", isEqualTo: book.author)
            .getDocuments { snapshot, _ in
                if let doc = snapshot?.documents.first {
                    doc.reference.setData([
                        "comment": comment,
                        "isFavorite": isFavorite
                    ], merge: true)
                    showSuccess()
                }
            }
    }

    private func showSuccess() {
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: BookItem(
            key: "/works/OL123M",
            title: "Swift Programming",
            author_name: ["Apple Inc."],
            cover_i: 10500009
        ))
    }
}

