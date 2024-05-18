//
//  VerseListView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

/// A view that displays a list of verses for a given chapter, allowing the user to select verses, bookmark them, or share selected verses.
struct VerseListView: View {
    @ObservedObject var viewModel: ChapterViewModel
    @State private var selectedVerse: Verse?
    @State private var showPopup = false
    @State private var bookmarks: [BookmarkedVerse] = BookmarkService().loadBookmarks()
    @State private var selectionMode: Bool = false  // New state for selection mode
    @State private var selectedVerses : [Verse] = []
    
    var bookname: String
    
    var body: some View {
        VStack {
            if selectionMode {
                selectionToolbar
            }
            
            List(viewModel.chapter.verses) { verse in
                verseRow(for: verse)
                    .contextMenu {
                        contextMenu(for: verse)
                    }
                    .onTapGesture {
                        handleVerseTap(verse)
                    }
                    .padding()
                    .background(bookmarks.contains(where: { $0.text == verse.text}) ? Color.yellow.opacity(0.5) : Color.clear)
            }
            .navigationTitle("Chapter \(viewModel.chapter.number)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if(selectionMode){
                            selectedVerses.removeAll()
                            selectionMode.toggle()
                        }
                        else {
                            selectionMode.toggle()
                        }
                        
                        
                    }) {
                        Text(selectionMode ? "Clear" : "Select")
                    }
                }
            }
        }
        .onAppear {
                    bookmarks = BookmarkService().loadBookmarks()
                }
    }
    
    /// A toolbar displayed when selection mode is active, allowing the user to share selected verses.
    private var selectionToolbar: some View {
        HStack {
            Spacer()
            Button(action: shareSelectedVerses) {
                Image(systemName: "square.and.arrow.up")
                Text("Share")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    /// Returns a view for displaying a single verse row, including selection and context menu options.
    /// - Parameter verse: The verse to display.
    private func verseRow(for verse: Verse) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if selectionMode {
                    Image(systemName: selectedVerses.contains(where: { $0.id == verse.id }) ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            toggleSelection(for: verse)
                        }
                }
                Text("Verse \(verse.number)")
                    .font(.headline)
                    
                Spacer()
            }
            Text(verse.text)
                .font(.body)
        }
        
    }
    
    /// Returns a context menu view for a given verse, providing options to bookmark or share the verse.
    /// - Parameter verse: The verse for which to display the context menu.
    private func contextMenu(for verse: Verse) -> some View {
        VStack {
            Button(action: {
                let bookmark = BookmarkedVerse(bookName: bookname, chapterNumber: viewModel.chapter.number, verseNumber: verse.number, text: verse.text)
                BookmarkService().saveBookmark(bookmark)
                bookmarks = BookmarkService().loadBookmarks()
            }) {
                Text("Bookmark")
                Image(systemName: "bookmark")
            }
            ShareLink(item: "\(bookname) \(viewModel.chapter.number):\(verse.number) - \(verse.text)")
        }
    }
    
    /// Handles the tap gesture on a verse. If selection mode is active, toggles the selection state of the verse.
    /// Otherwise, displays the verse in a popup view.
    /// - Parameter verse: The verse that was tapped.
    private func handleVerseTap(_ verse: Verse) {
        if selectionMode {
            toggleSelection(for: verse)
        } else {
            let bookmark = BookmarkedVerse(bookName: bookname, chapterNumber: viewModel.chapter.number, verseNumber: verse.number, text: verse.text)
            BookmarkService().saveBookmark(bookmark)
            bookmarks = BookmarkService().loadBookmarks()
        }
    }
    
    /// Toggles the selection state of a verse.
    /// - Parameter verse: The verse to toggle.
    private func toggleSelection(for verse: Verse) {
        if let index = selectedVerses.firstIndex(where: { $0.id == verse.id }) {
            selectedVerses.remove(at: index)
        } else {
            selectedVerses.append(verse)
        }
    }
    
    /// Shares the selected verses using a UIActivityViewController.
    private func shareSelectedVerses() {
        let sortedSelectedVerses = selectedVerses.sorted { $0.number < $1.number }
        let versesText = sortedSelectedVerses.map { "\($0.bookName) \($0.chapterNumber):\($0.number) - \($0.text)" }.joined(separator: "\n")
        let activityVC = UIActivityViewController(activityItems: [versesText], applicationActivities: nil)

        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}
