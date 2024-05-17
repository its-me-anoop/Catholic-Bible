//
//  BookViewModel.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

class BookViewModel: ObservableObject {
    var book: Book
    
    init(book: Book) {
        self.book = book
    }
}
