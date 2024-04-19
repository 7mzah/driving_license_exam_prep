import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: currentQuestionIndex > 0 ? onPrevious : null,
            child: Text(
              'Back',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: currentQuestionIndex < totalQuestions ? onNext : null,
            child: Text(
              'Next',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
            ),
      ),
      );
  }
}
