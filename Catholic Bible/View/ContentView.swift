//
//  ContentView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = BibleViewModel()
    
    var body: some View {
        TabView {
            TestamentView(books: viewModel.oldTestament, title: "Old Testament")
                .tabItem {
                    Label("Old Testament", systemImage: "book")
                }
            
            TestamentView(books: viewModel.newTestament, title: "New Testament")
                .tabItem {
                    Label("New Testament", systemImage: "book.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
