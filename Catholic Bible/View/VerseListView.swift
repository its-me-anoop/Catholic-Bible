//
//  VerseListView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

struct VerseListView: View {
    @ObservedObject var viewModel: ChapterViewModel
    var bookname: String
    
    var body: some View {
        List(viewModel.chapter.verses) { verse in
            VStack(alignment: .leading) {
                Text("Verse \(verse.number)")
                    .font(.headline)
                Text(verse.text)
                    .font(.body)
                    .contextMenu {
                        ShareLink(item: "\(bookname) \(viewModel.chapter.number):\(verse.number) - \(verse.text)")
                        
                    }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Chapter \(viewModel.chapter.number)")
        
    }
}

