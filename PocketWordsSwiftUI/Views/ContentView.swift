//
//  ContentView.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = PocketWordsViewModel()
    @State private var flipped = false
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Display message if no cards are available
                if viewModel.cards.isEmpty {
                    Text("No cards yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Card view with flip functionality
                    CardView(card: viewModel.cards[viewModel.currentIndex], flipped: $flipped)
                        .onTapGesture {
                            withAnimation {
                                flipped.toggle() // Toggle card flip on tap
                            }
                        }
                        .padding()
                    
                    // Input for meaning and check answer button
                    VStack(spacing: 8) {
                        TextField("Type the meaning", text: $viewModel.currentAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Button("Check Answer") {
                                withAnimation {
                                    viewModel.checkAnswer(for: viewModel.cards[viewModel.currentIndex]) // Check answer
                                    flipped = false // Reset card flip
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            Spacer()
                            // Next Button to go to the next card
                            Button("Next") {
                                viewModel.moveToNextCard() // Move to the next card
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    
                    // Feedback on correctness of the answer
                    if viewModel.showFeedback {
                        Text(viewModel.answerWasCorrect ? "✓ Correct!" : "✗ Incorrect")
                            .foregroundColor(viewModel.answerWasCorrect ? .green : .red)
                            .font(.headline)
                    }
                    
                    // XP progress display
                    let safeProgress = viewModel.progress.isNaN ? 0.0 : viewModel.progress
                    ProgressView(value: safeProgress)
                        .padding(.horizontal)
                    Text("XP: \(viewModel.xpTracker?.xp ?? 0)")
                        .font(.caption)
                }
            }
            .navigationTitle("PocketWords")
            .toolbar {
                // Add card button
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add", systemImage: "plus") // Show the "Add" button
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddCardView(viewModel: viewModel) // Show AddCardView when sheet is presented
            }
            .onAppear {
                viewModel.setContext(context) // Set the model context when the view appears
            }
        }
    }
}

// MARK: - Preview

#Preview {
    // Configure in-memory storage for preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    do {
        // Create model container for WordCard and XPTracker
        let container = try ModelContainer(for: WordCard.self, XPTracker.self, configurations: config)
        let context = container.mainContext
        
        // Insert sample cards into the context for preview
        let sampleCards = [
            WordCard(word: "Sky", meaning: "آسمان"),
            WordCard(word: "Tree", meaning: "درخت"),
            WordCard(word: "River", meaning: "رودخانه")
        ]
        sampleCards.forEach { context.insert($0) } // Insert cards
        
        // Insert XPTracker into the context
        let xp = XPTracker()
        context.insert(xp)
        
        // Return ContentView with model container attached for preview
        return ContentView()
            .modelContainer(container)
    } catch {
        // Handle errors during preview setup
        return Text("Failed to load preview: \(error.localizedDescription)")
    }
}


