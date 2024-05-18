//
//  TestamentView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

struct TestamentView: View {
    let books: [Book]
    let title: String
    
    @State private var searchText: String = ""
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.brown.withAlphaComponent(0.4))
                .ignoresSafeArea()
            VStack {
                //SearchBar(text: $searchText, placeholder: "Search \(title) Books")
                List(filteredBooks) { book in
                    NavigationLink(destination: ChapterListView(viewModel: BookViewModel(book: book))) {
                        Text(book.name)
                    }
                }
                .listStyle(PlainListStyle())
                
                
            }
        }
        
        
    }
}


