//
//  AddCardView.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PocketWordsViewModel
    
    @State private var word: String = ""
    @State private var meaning: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Word")) {
                    TextField("Word", text: $word)
                    TextField("Meaning", text: $meaning)
                }
                
                Button("Save") {
                    viewModel.addCard(word: word, meaning: meaning)
                    dismiss()
                }
                .disabled(word.trimmingCharacters(in: .whitespaces).isEmpty ||
                          meaning.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .navigationTitle("Add Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AddCardView(viewModel: PocketWordsViewModel())
}

