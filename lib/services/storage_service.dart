import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/default_flashcards.dart';
import '../models/flashcard_model.dart';

class StorageService {
  static const String _storageKey = 'codealpha_flashcards';

  Future<List<Flashcard>> loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      await saveFlashcards(initialFlashcards);
      return List<Flashcard>.from(initialFlashcards);
    }

    try {
      final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
      return decodedList
          .map((item) => Flashcard.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return List<Flashcard>.from(initialFlashcards);
    }
  }

  Future<void> saveFlashcards(List<Flashcard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final maps = cards.map((card) => card.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(maps));
  }
}