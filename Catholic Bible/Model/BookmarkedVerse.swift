//
//  BookmarkedVerse.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

struct BookmarkedVerse: Codable, Identifiable {
    var id = UUID()
    var bookName: String
    var chapterNumber: Int
    var verseNumber: Int
    var text: String
}
