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
    
    init(number: Int, text: String) {
        self.id = UUID()
        self.number = number
        self.text = text
    }
}
