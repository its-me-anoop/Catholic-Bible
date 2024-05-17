//
//  Chapter.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

struct Chapter: Codable, Identifiable {
    var id: UUID
    var number: Int
    var verses: [Verse]
    
    init(number: Int, verses: [Verse]) {
        self.id = UUID()
        self.number = number
        self.verses = verses
    }
}
