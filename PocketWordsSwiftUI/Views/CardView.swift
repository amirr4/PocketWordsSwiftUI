//
//  CardView.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import SwiftUI

struct CardView: View {
    let card: WordCard
    @Binding var flipped: Bool 
    
    var body: some View {
        ZStack {
            if !flipped { frontView } else { backView } // Toggle between front and back views
        }
        .frame(height: 150)
        .cornerRadius(16)
        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0)) // Flip animation
        .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: flipped)
        .shadow(radius: 5)
    }
    
    // Front side of the card
    var frontView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.blue)
            .overlay(
                Text(card.word)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            )
    }
    
    // Back side of the card
    var backView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.orange)
            .overlay(
                Text(card.meaning)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // Correct flipped text rotation
            )
    }
}

// MARK: - Preview

#Preview {
    // Preview with a sample word and meaning, initially unflipped
    CardView(
        card: WordCard(word: "Sun", meaning: "خورشید"),
        flipped: Binding.constant(false)
    )
    .padding()
}


