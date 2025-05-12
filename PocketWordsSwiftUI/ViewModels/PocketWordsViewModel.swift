//
//  PocketWordsViewModel.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class PocketWordsViewModel: ObservableObject {
    // Published properties to bind to the UI
    @Published var cards: [WordCard] = []
    @Published var currentAnswer: String = ""
    @Published var answerWasCorrect = false
    @Published var showFeedback = false
    @Published var xpTracker: XPTracker?
    @Published var currentIndex = 0 
    
    private var context: ModelContext? // Context for database operations
    
    // Computed property to calculate the user's progress based on correct answers
    var progress: Double {
        let total = Double(cards.count)
        guard total > 0 else { return 0 }
        let correct = Double(cards.filter { $0.isCorrect }.count)
        return correct / total
    }
    
    // Set the ModelContext and load data when the view model is initialized
    func setContext(_ context: ModelContext) {
        self.context = context
        loadData()
    }
    
    // Load cards and XP Tracker from the database
    func loadData() {
        guard let context = context else { return }

        // Sort by createdAt descending
        let descriptor = FetchDescriptor<WordCard>(sortBy: [.init(\.createdAt, order: .reverse)])
        self.cards = (try? context.fetch(descriptor)) ?? []

        // XP Tracker loading...
        if let existingXP = try? context.fetch(FetchDescriptor<XPTracker>()).first {
            self.xpTracker = existingXP
        } else {
            let newXP = XPTracker()
            context.insert(newXP)
            self.xpTracker = newXP
        }
    }

    
    // Add a new card with word and meaning
    func addCard(word: String, meaning: String) {
        guard let context = context else { return }
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMeaning = meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        let card = WordCard(word: trimmedWord, meaning: trimmedMeaning)
        context.insert(card)

        do {
            try context.save()
            cards.insert(card, at: 0) // Add to beginning of list
            currentIndex = 0         // Show it immediately
        } catch {
            print("Failed to save card: \(error.localizedDescription)")
        }
    }

    
    // Check if the user's answer is correct for the given card
    func checkAnswer(for card: WordCard) {
        let trimmedInput = currentAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correctAnswer = card.meaning.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if trimmedInput == correctAnswer {
            if !card.isCorrect {
                card.isCorrect = true // Mark the card as correct
                xpTracker?.xp += 10 // Add XP to the tracker
                
                // Save XP tracker changes
                saveXP()
            }
            answerWasCorrect = true
        } else {
            answerWasCorrect = false
        }
        
        currentAnswer = "" // Clear the current answer
        showFeedback = true // Show feedback message
        
        // Hide feedback after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                self.showFeedback = false
            }
        }
    }
    
    // Save the XP Tracker to the context (database)
    func saveXP() {
        guard let context = context, let _ = xpTracker else { return }
        do {
            try context.save() // Save the XP tracker to the database
        } catch {
            print("Failed to save XP: \(error.localizedDescription)")
        }
    }
    
    // Move to the next card in the list
    func moveToNextCard() {
        if cards.isEmpty { return }
        if currentIndex + 1 < cards.count {
            currentIndex += 1
        } else {
            currentIndex = 0 // Loop back to the first card or stop at the end
        }
    }
}



