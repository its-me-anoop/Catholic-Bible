//
//  Book.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

struct Book: Codable, Identifiable {
    var id: UUID
    var name: String
    var chapters: [Chapter]
    
    init(name: String, chapters: [Chapter]) {
        self.id = UUID()
        self.name = name
        self.chapters = chapters
    }
}
