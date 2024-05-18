//
//  BookmarkService.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

class BookmarkService {
    private let bookmarksKey = "bookmarks"
    
    func saveBookmark(_ bookmark: BookmarkedVerse) {
        var bookmarks = loadBookmarks()
        if !bookmarks.contains(where: { $0.text == bookmark.text }) {
            bookmarks.append(bookmark)
        }
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encoded, forKey: bookmarksKey)
        }
    }
    
    func loadBookmarks() -> [BookmarkedVerse] {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey),
           let bookmarks = try? JSONDecoder().decode([BookmarkedVerse].self, from: data) {
            return bookmarks
        }
        return []
    }
    
    func removeBookmark(_ bookmark: BookmarkedVerse) {
        var bookmarks = loadBookmarks()
        if let index = bookmarks.firstIndex(where: { $0.id == bookmark.id }) {
            bookmarks.remove(at: index)
        }
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encoded, forKey: bookmarksKey)
        }
    }
}
