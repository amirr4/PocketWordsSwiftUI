//
//  WordCard.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import Foundation
import SwiftData

@Model
class WordCard {
    var word: String
    var meaning: String
    var isCorrect: Bool = false
    var createdAt: Date

    init(word: String, meaning: String, createdAt: Date = .now) {
        self.word = word
        self.meaning = meaning
        self.createdAt = createdAt
    }
}

