import 'package:flutter/material.dart';
import 'dart:typed_data';

class QuestionCard extends StatelessWidget {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final Uint8List? questionImage;
  final bool isCorrect;

  const QuestionCard({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    this.questionImage,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCorrect ? Colors.green[100] : Colors.red[100],
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (questionImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.memory(questionImage!),
              ),Text(
              question,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.background),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your Answer: $userAnswer',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Correct Answer: $correctAnswer',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
