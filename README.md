# CodeAlpha_FlashcardQuizApp

An interactive, responsive study flashcard application built with **Flutter** and **Material Design 3**. The app enables users to review study decks, flip cards between questions and answers, navigate through cards, and perform full CRUD (Create, Read, Update, Delete) customization with persistent local storage. Developed as part of the **CodeAlpha App Development Internship** (Task 1).

---

## 📱 Features

- **Interactive Question/Answer Flip:** Toggle between the question on the front and answer on the back with animated transitions.
- **Card Navigation:** Seamlessly move back and forth using "Previous" and "Next" controls with dynamic progress tracking (`Card X of Y`).
- **Full Card Management (CRUD):**
  - **Create:** Add custom flashcards with real-time field validation.
  - **Read:** View cards in study mode or list mode.
  - **Update:** Edit existing questions and answers via pre-filled dialogs.
  - **Delete:** Remove unwanted cards with one-tap undo feedback.
- **Persistent Local Storage:** Integrated with `shared_preferences` to persist added, updated, or removed flashcards across application launches.
- **Modern Material 3 Interface:** Adaptive Teal color palette, soft container elevations, progress indicator, and system-adaptive light/dark theme support.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev/) (Channel stable)
- **Language:** [Dart](https://dart.dev/)
- **UI Design System:** Material Design 3 (`useMaterial3: true`)
- **Persistence:** `shared_preferences` (JSON serialization)
- **State Management:** Native `StatefulWidget` (`setState`)

### Project Structure

```text
lib/
├── data/
│   └── default_flashcards.dart  # Starter deck data
├── models/
│   └── flashcard_model.dart     # Flashcard model & JSON methods
├── screens/
│   ├── flashcard_screen.dart    # Main quiz & navigation view
│   └── manage_cards_screen.dart # CRUD management interface
├── services/
│   └── storage_service.dart     # SharedPreferences storage handler
├── widgets/
│   └── flashcard_view.dart      # Interactive front/back card widget
└── main.dart                    # Application entry point & M3 theme