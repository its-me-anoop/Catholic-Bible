//
//  ChapterViewModel.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation

class ChapterViewModel: ObservableObject {
    var chapter: Chapter
    
    init(chapter: Chapter) {
        self.chapter = chapter
    }
}
