//
//  BibleViewModel.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import Foundation
import Combine

class BibleViewModel: ObservableObject {
    @Published var oldTestament: [Book] = []
    @Published var newTestament: [Book] = []

    let oldTestamentBooks: [String] = [
        "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
        "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel",
        "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra",
        "Nehemiah", "Tobit", "Judith", "Esther", "1 Maccabees", "2 Maccabees",
        "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs",
        "Wisdom", "Sirach", "Isaiah", "Jeremiah", "Lamentations",
        "Baruch", "Ezekiel", "Daniel", "Hosea", "Joel",
        "Amos", "Obadiah", "Jonah", "Micah", "Nahum",
        "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"
    ]
    
    let newTestamentBooks: [String] = [
        "Matthew", "Mark", "Luke", "John", "Acts",
        "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians",
        "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy",
        "2 Timothy", "Titus", "Philemon", "Hebrews", "James",
        "1 Peter", "2 Peter", "1 John", "2 John", "3 John",
        "Jude", "Revelation"
    ]
    
    private var bookOrderDict: [String: Int] = [:]
    
    init() {
        for (index, book) in (oldTestamentBooks + newTestamentBooks).enumerated() {
            bookOrderDict[book] = index
        }
        loadBible()
    }
    
    func loadBible() {
        if let url = Bundle.main.url(forResource: "EntireBible-CPDV", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                parseBibleJSON(from: data)
            } catch {
                print("Error loading Bible: \(error)")
            }
        }
    }
    
    private func parseBibleJSON(from jsonData: Data) {
        var books = [Book]()
        
        if let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            for (bookName, chaptersDict) in jsonDict where bookName != "charset" {
                if let chaptersDict = chaptersDict as? [String: Any] {
                    var chapters = [Chapter]()
                    for (chapterNumber, versesDict) in chaptersDict {
                        if let versesDict = versesDict as? [String: String] {
                            var verses = [Verse]()
                            for (verseNumber, verseText) in versesDict {
                                if let verseNumber = Int(verseNumber), let chapterNumber = Int(chapterNumber) {
                                    verses.append(Verse(number: verseNumber, text: verseText, bookName: bookName, chapterNumber: chapterNumber))
                                }
                            }
                            if let chapterNumber = Int(chapterNumber) {
                                chapters.append(Chapter(number: chapterNumber, verses: verses.sorted(by: { $0.number < $1.number })))
                            }
                        }
                    }
                    books.append(Book(name: bookName, chapters: chapters.sorted(by: { $0.number < $1.number })))
                }
            }
        }
        
        books.sort { (book1, book2) -> Bool in
            let index1 = bookOrderDict[book1.name] ?? Int.max
            let index2 = bookOrderDict[book2.name] ?? Int.max
            return index1 < index2
        }
        
        oldTestament = books.filter { oldTestamentBooks.contains($0.name) }
        newTestament = books.filter { newTestamentBooks.contains($0.name) }
    }
}
