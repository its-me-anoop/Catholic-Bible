//
//  ChapterListView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

struct ChapterListView: View {
    @ObservedObject var viewModel: BookViewModel
    
    var body: some View {
        List(viewModel.book.chapters) { chapter in
            NavigationLink(destination: VerseListView(viewModel: ChapterViewModel(chapter: chapter), bookname: viewModel.book.name)) {
                Text("Chapter \(chapter.number)")
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(viewModel.book.name)
    }
}

//#Preview {
//    ChapterListView(viewModel: B)
//}
