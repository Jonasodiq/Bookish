# 📚 Bookish

**Bookish** is a SwiftUI app built with the MVVM architecture where users can log in, save book recommendations, and view their personal reading library. The app acts as a private collection of books the user wants to recommend to themselves or others.

## 🚀 Features

- 🔐 Login with Firebase Authentication
- 📚 View a list of your own book recommendations
- ➕ Add new book entries (title, author, optional comment)
- ❌ Delete book entries
- 🔄 (Optional) Edit book entries
- 🔎 Search and filter the book list
- ⭐ Mark books as favorites
- 📆 Display books in chronological order

## 🧱 Technologies

- **SwiftUI** for the user interface
- **MVVM** for project architecture
- **Firebase Firestore** for data storage
- **Firebase Authentication** for login
- **URLSession** to fetch book data from public APIs (e.g., Open Library API)

## 🏗️ Architecture

**Model:**
\`\`\`swift
struct Book: Identifiable, Codable {
  @DocumentID var id: String?
  let title: String
  let author: String
  let comment: String
  var userId: String
  let coverURL: String
  let timestamp: Date
  var isFavorite: Bool = false
}
\`\`\`

**ViewModel:**  
Fetches book data from Open Library API and Firebase Firestore. Publishes the book list.

**View:**  
Displays books in a list with search functionality and error handling in the UI.

## 🛠 Getting Started

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/Jonasodiq/Bookish
   \`\`\`

2. Open the project in Xcode

3. Add your \`GoogleService-Info.plist\` from Firebase to the project

4. Build and run on a simulator or device

## 📝 Optional Enhancements

- [ ] Multiple login providers (Google, Apple)
- [ ] Star ratings (1–5 stars)
- [ ] Filter by favorites
- [ ] Share book tips with others

---

Built with ❤️ using Swift.
