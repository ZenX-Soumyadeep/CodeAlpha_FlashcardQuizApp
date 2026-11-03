import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/storage_service.dart';

class ManageCardsScreen extends StatefulWidget {
  final List<Flashcard> initialCards;

  const ManageCardsScreen({super.key, required this.initialCards});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  final StorageService _storageService = StorageService();
  late List<Flashcard> _cards;

  @override
  void initState() {
    super.initState();
    _cards = List<Flashcard>.from(widget.initialCards);
  }

  Future<void> _saveChanges() async {
    await _storageService.saveFlashcards(_cards);
  }

  void _showCardDialog({Flashcard? cardToEdit, int? index}) {
    final formKey = GlobalKey<FormState>();
    final questionController =
        TextEditingController(text: cardToEdit?.question ?? '');
    final answerController =
        TextEditingController(text: cardToEdit?.answer ?? '');

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(cardToEdit == null ? 'Add Flashcard' : 'Edit Flashcard'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final question = questionController.text.trim();
                final answer = answerController.text.trim();

                setState(() {
                  if (cardToEdit != null && index != null) {
                    _cards[index] = cardToEdit.copyWith(
                      question: question,
                      answer: answer,
                    );
                  } else {
                    _cards.add(
                      Flashcard(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        question: question,
                        answer: answer,
                      ),
                    );
                  }
                });

                _saveChanges();
                Navigator.pop(dialogCtx);
              }
            },
            child: Text(cardToEdit == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCard(int index) {
    final deleted = _cards[index];
    setState(() {
      _cards.removeAt(index);
    });
    _saveChanges();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Flashcard deleted'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _cards.insert(index, deleted);
            });
            _saveChanges();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _cards);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Cards'),
        ),
        body: _cards.isEmpty
            ? const Center(
                child: Text('No flashcards yet. Tap + to add one!'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: _cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: ListTile(
                      title: Text(
                        card.question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        card.answer,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Edit',
                            onPressed: () => _showCardDialog(
                              cardToEdit: card,
                              index: index,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Theme.of(context).colorScheme.error,
                            tooltip: 'Delete',
                            onPressed: () => _deleteCard(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCardDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Add Card'),
        ),
      ),
    );
  }
}