import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class FlashcardView extends StatelessWidget {
  final Flashcard card;
  final bool showAnswer;
  final VoidCallback onToggle;

  const FlashcardView({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Chip (Front / Back label)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: showAnswer
                    ? theme.colorScheme.tertiaryContainer
                    : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                showAnswer ? 'ANSWER' : 'QUESTION',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: showAnswer
                      ? theme.colorScheme.onTertiaryContainer
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const Spacer(),
            // Animated Question / Answer Text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: SingleChildScrollView(
                key: ValueKey<bool>(showAnswer),
                child: Text(
                  showAnswer ? card.answer : card.question,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // "Show Answer" Toggle Button
            FilledButton.tonalIcon(
              onPressed: onToggle,
              icon: Icon(
                showAnswer
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
              ),
              label: Text(showAnswer ? 'Show Question' : 'Show Answer'),
            ),
          ],
        ),
      ),
    );
  }
}