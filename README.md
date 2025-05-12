# PocketWords iOS App

PocketWords is a simple vocabulary learning app that allows users to add word cards, quiz themselves, and earn XP points when they answer correctly.

## Features
- Add word cards with a word and its meaning
- View cards in a flashcard-like UI with flip animation
- Check answers and show feedback (✓ or ✗)
- XP (Experience Points) system to track user progress

## Architecture
This project uses the MVVM architecture:
- Model: Data models (such as WordCard and XPTracker)
- View: UI using SwiftUI
- ViewModel: Business logic and data processing

## Build Instructions
1. This project was built with Xcode 16 targeting iOS 18.
2. To build and run the app, open the project in Xcode.
3. You can run the app on a simulator or a real device.

## Testing
Unit tests for the ViewModel and other parts of the app are written. To run the tests:
1. In Xcode, choose Product > Test from the menu.
2. Or use the shortcut Cmd + U to run the tests.

### Unit Tests
Unit tests are written to ensure the functionality of the core features, including:
- Checking if the answers are correct
- Validating XP increase when the user answers correctly
- Ensuring the feedback is shown correctly

## Notes
- This project does not use any APIs or networking.
- All data is persisted locally using SwiftData.


