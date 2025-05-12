////
////  PocketWordsViewModelTests.swift
////  PocketWordsSwiftUITests
////
////  Created by Amir on 5/12/25.
////

import XCTest
@testable import PocketWordsSwiftUI

@MainActor
final class PocketWordsViewModelTests: XCTestCase {
    
    func testCheckAnswer_CorrectAndIncorrect() {
        // Arrange
        let viewModel = PocketWordsViewModel()
        let xp = XPTracker()
        viewModel.xpTracker = xp
        
        let card = WordCard(word: "test", meaning: "پیشرفت")
        viewModel.cards = [card]
        
        // Act - Correct answer
        viewModel.currentAnswer = "  پیشرفت  "
        viewModel.checkAnswer(for: card)
        
        // Assert
        XCTAssertTrue(card.isCorrect, "Card should be marked correct.")
        XCTAssertTrue(viewModel.answerWasCorrect, "Answer feedback flag should be true.")
        XCTAssertEqual(viewModel.xpTracker?.xp, 10, "XP should increase by 10.")
        
        // Act - Incorrect answer
        let newCard = WordCard(word: "next", meaning: "سیب")
        viewModel.cards.append(newCard)
        viewModel.currentAnswer = "گلابی"
        viewModel.checkAnswer(for: newCard)
        
        // Assert
        XCTAssertFalse(viewModel.answerWasCorrect, "Answer feedback flag should be false for wrong answer.")
        XCTAssertFalse(newCard.isCorrect, "Wrong answer should not mark card as correct.")
        XCTAssertEqual(viewModel.xpTracker?.xp, 10, "XP should not increase on wrong answer.")
    }
}
