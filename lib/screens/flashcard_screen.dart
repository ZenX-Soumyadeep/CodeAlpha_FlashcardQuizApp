import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/storage_service.dart';
import '../widgets/flashcard_view.dart';
import 'manage_cards_screen.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final StorageService _storageService = StorageService();
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final loaded = await _storageService.loadFlashcards();
    setState(() {
      _cards = loaded;
      _isLoading = false;
    });
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  Future<void> _openManageCards() async {
    final updatedCards = await Navigator.push<List<Flashcard>>(
      context,
      MaterialPageRoute(
        builder: (context) => ManageCardsScreen(initialCards: _cards),
      ),
    );

    if (updatedCards != null) {
      setState(() {
        _cards = updatedCards;
        if (_currentIndex >= _cards.length) {
          _currentIndex = _cards.isEmpty ? 0 : _cards.length - 1;
        }
        _showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.style_outlined),
            tooltip: 'Manage Cards',
            onPressed: _openManageCards,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cards.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No flashcards left!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: _openManageCards,
                          child: const Text('Add Flashcards'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        // Progress Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Card ${_currentIndex + 1} of ${_cards.length}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${((_currentIndex + 1) / _cards.length * 100).toInt()}%',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: (_currentIndex + 1) / _cards.length,
                          borderRadius: BorderRadius.circular(8),
                          minHeight: 6,
                        ),
                        const SizedBox(height: 24),
                        // Main Flashcard View
                        Expanded(
                          child: FlashcardView(
                            card: _cards[_currentIndex],
                            showAnswer: _showAnswer,
                            onToggle: _toggleAnswer,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Navigation Controls
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _currentIndex > 0 ? _prevCard : null,
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: const Text('Previous'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _currentIndex < _cards.length - 1
                                    ? _nextCard
                                    : null,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text('Next'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
      ),
    );
  }
}