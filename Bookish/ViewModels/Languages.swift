//
//  Languages.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-26.
//

import Foundation

struct LanguageOption: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let code: String
    let flag: String
}

let languageOptions: [LanguageOption] = [
    LanguageOption(name: "All",        code: "", flag: "🌎"),
    LanguageOption(name: "Arabic",     code: "ara", flag: "🇸🇦"),
    LanguageOption(name: "English",    code: "eng", flag: "🇬🇧"),
    LanguageOption(name: "Swedish",    code: "swe", flag: "🇸🇪"),
    LanguageOption(name: "Uzbek",      code: "uzb", flag: "🇺🇿"),
    LanguageOption(name: "Russian",    code: "rus", flag: "🇷🇺"),
    LanguageOption(name: "Turkish",    code: "tur", flag: "🇹🇷"),
    LanguageOption(name: "Spanish",    code: "spa", flag: "🇪🇸"),
    LanguageOption(name: "French",     code: "fre", flag: "🇫🇷"),
    LanguageOption(name: "German",     code: "ger", flag: "🇩🇪"),
    LanguageOption(name: "Italian",    code: "ita", flag: "🇮🇹"),
    LanguageOption(name: "Norwegian",  code: "nor", flag: "🇳🇴"),
    LanguageOption(name: "Danish",     code: "dan", flag: "🇩🇰"),
    LanguageOption(name: "Portuguese", code: "por", flag: "🇵🇹"),
]

