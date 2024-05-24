import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../data/models/question_model.dart';

class ExamSimQuestionCard extends StatefulWidget {
  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int> onAnswerSelected;
  final int questionNumber;

  const ExamSimQuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswerSelected,
    required this.questionNumber,
  });

  @override
  ExamSimQuestionCardState createState() => ExamSimQuestionCardState();
}

class ExamSimQuestionCardState extends State<ExamSimQuestionCard> {
  int? selectedAnswer;
  late final Image questionImage;
  int examId = 0;

  @override
  void initState() {
    super.initState();
    if (widget.question.questionImage != null &&
        widget.question.questionImage!.isNotEmpty) {
      questionImage =
          Image.memory(base64Decode(widget.question.questionImage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${widget.questionNumber}',
              style:
              const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.question.questionText,
              style: const TextStyle(fontSize: 16.0),
            ),
            // Add this block to handle question images
            if (widget.question.questionImage != null &&
                widget.question.questionImage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: questionImage,
              ),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                widget.question.answers.length,
                    (answerIndex) {
                  return RadioListTile<int>(
                    title:
                    Text(widget.question.answers[answerIndex].answerText),
                    value: widget.question.answers[answerIndex].answerId,
                    groupValue: selectedAnswer,
                    onChanged: (value) async {
                      setState(() {
                        selectedAnswer = value;
                      });
                      widget.onAnswerSelected(value ?? -1);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
