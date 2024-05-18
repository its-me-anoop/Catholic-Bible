//
//  BibleView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

/// A view that displays the main Bible content, including Old Testament, New Testament, and Bookmarks sections.
struct BibleView: View {
    @ObservedObject var viewModel = BibleViewModel()
    @State private var selection: Int = 0
    @State private var searchText: String = ""
    @State private var bookmarks: [BookmarkedVerse] = BookmarkService().loadBookmarks()
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return selection == 0 ? viewModel.oldTestament : viewModel.newTestament
        } else {
            let books = selection == 0 ? viewModel.oldTestament : viewModel.newTestament
            return books.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.brown.withAlphaComponent(0.4))
                    .ignoresSafeArea()
                TabView(selection: $selection) {
                    TestamentView(books: filteredBooks, title: "Old Testament")
                        .tabItem {
                            Label("Old Testament", systemImage: "book")
                        }
                        .tag(0)
                    
                    TestamentView(books: filteredBooks, title: "New Testament")
                        .tabItem {
                            Label("New Testament", systemImage: "book.fill")
                        }
                        .tag(1)
                    
                    BookmarksView(bookmarks: $bookmarks, searchText: $searchText)
                        .tabItem {
                            Label("Bookmarks", systemImage: "bookmark.fill")
                        }
                        .tag(2)
                }
                .navigationTitle(selection == 0 ? "Old Testament" : selection == 1 ? "New Testament" : "Bookmarks")
                .searchable(text: $searchText, placement: .automatic)
            }
        }
    }
}

// Preview provider for BibleView
struct BibleView_Previews: PreviewProvider {
    static var previews: some View {
        BibleView()
    }
}
