import '../models/flashcard_model.dart';

final List<Flashcard> initialFlashcards = [
  const Flashcard(
    id: '1',
    question: 'What is the difference between Hot Reload and Hot Restart in Flutter?',
    answer: 'Hot Reload injects updated code into the running Dart VM preserving state; Hot Restart resets the state and completely reinitializes the app.',
  ),
  const Flashcard(
    id: '2',
    question: 'What is the primary purpose of an abstract class in OOP?',
    answer: 'It defines a common template or contract for derived classes and cannot be instantiated directly.',
  ),
  const Flashcard(
    id: '3',
    question: 'What does ACID stand for in Database Management Systems?',
    answer: 'Atomicity, Consistency, Isolation, and Durability.',
  ),
  const Flashcard(
    id: '4',
    question: 'What is the average time complexity of searching in a Balanced Binary Search Tree?',
    answer: 'O(log n).',
  ),
  const Flashcard(
    id: '5',
    question: 'What role does BuildContext play in Flutter?',
    answer: 'It handles the location of a widget in the widget tree and provides access to InheritedWidgets like Theme, MediaQuery, and Navigator.',
  ),
];