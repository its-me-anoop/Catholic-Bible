//
//  BookmarksView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

struct BookmarksView: View {
    @Binding var bookmarks: [BookmarkedVerse]
    @Binding var searchText: String

    // Compute the filtered bookmarks without modifying state
    var filteredBookmarks: [BookmarkedVerse] {
        if searchText.isEmpty {
            return bookmarks
        } else {
            return bookmarks.filter {
                "\($0.bookName) \($0.chapterNumber) \($0.verseNumber) \($0.text)".localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        List {
            ForEach(filteredBookmarks) { bookmark in
                VStack(alignment: .leading) {
                    Text("\(bookmark.bookName) \(bookmark.chapterNumber):\(bookmark.verseNumber)")
                        .font(.headline)
                    Text(bookmark.text)
                        .font(.body)
                        .contextMenu {
                            ShareLink(item: "\(bookmark.bookName) \(bookmark.chapterNumber):\(bookmark.verseNumber) - \(bookmark.text)")
                        }
                }
            }
            .onDelete(perform: removeBookmarks)
        }
        .navigationTitle("Bookmarks")
        .onAppear {
            bookmarks = BookmarkService().loadBookmarks()
        }
    }

    private func removeBookmarks(at offsets: IndexSet) {
        let bookmarksToDelete = offsets.map { filteredBookmarks[$0] }
        bookmarksToDelete.forEach { bookmark in
            BookmarkService().removeBookmark(bookmark)
        }
        bookmarks = BookmarkService().loadBookmarks()
    }
}

