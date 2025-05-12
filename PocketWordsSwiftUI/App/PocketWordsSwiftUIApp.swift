//
//  PocketWordsSwiftUIApp.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import SwiftUI
import SwiftData

@main
struct PocketWordsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [WordCard.self, XPTracker.self])
    }
}

