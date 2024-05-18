//
//  Verse.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

struct Verse: Codable, Identifiable {
    var id: UUID
    var number: Int
    var text: String
    var bookName: String
    var chapterNumber: Int
    var isHighlighted: Bool = false
    
    init(number: Int, text: String, bookName: String, chapterNumber: Int) {
        self.id = UUID()
        self.number = number
        self.text = text
        self.bookName = bookName
        self.chapterNumber = chapterNumber
    }
}
