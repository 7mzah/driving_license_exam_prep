import 'package:flutter/material.dart';

import '../../../data/models/answer_model.dart';

class AnswersList extends StatefulWidget {
  final List<Answer> answers;
  final int? selectedChoiceId;
  final ValueChanged<int?> onAnswerSelected;
  final bool hasAnswered;
  final bool showCorrectAnswer;

  const AnswersList({
    super.key,
    required this.answers,
    required this.selectedChoiceId,
    required this.onAnswerSelected,
    required this.hasAnswered,
    required this.showCorrectAnswer,
  });

  @override
  AnswersListState createState() => AnswersListState();
}

class AnswersListState extends State<AnswersList> {
  int? correctAnswerId;

  @override
  void initState() {
    super.initState();
    correctAnswerId =
        widget.answers.firstWhere((answer) => answer.isCorrect).answerId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.answers.length,
      itemBuilder: (context, index) {
        final answer = widget.answers[index];
        return Card(
          color:
              widget.hasAnswered && widget.selectedChoiceId == answer.answerId
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.surface,
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                widget.showCorrectAnswer && answer.isCorrect
                    ? Icons.check_circle
                    : widget.selectedChoiceId == answer.answerId
                        ? (answer.isCorrect ? Icons.check_circle : Icons.cancel)
                        : Icons.radio_button_unchecked,
                color: widget.showCorrectAnswer && answer.isCorrect
                    ? Colors.green
                    : widget.selectedChoiceId == answer.answerId
                        ? (answer.isCorrect ? Colors.green : Colors.red)
                        : Colors.grey,
              ),
              onPressed: widget.hasAnswered
                  ? null
                  : () {
                      setState(() {
                        widget.onAnswerSelected(answer.answerId);
                      });
                    },
            ),
            title: Text(
              answer.answerText,
              style: TextStyle(
                  color: widget.hasAnswered &&
                          widget.selectedChoiceId == answer.answerId
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSurface),
            ),
            onTap: widget.hasAnswered
                ? null
                : () {
                    setState(() {
                      widget.onAnswerSelected(answer.answerId);
                    });
                  },
          ),
        );
      },
    );
  }
}
