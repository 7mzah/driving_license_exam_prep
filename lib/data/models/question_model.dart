import 'answer_model.dart';

class Question {
  final int questionId;
  final String questionText;
  final List<Answer> answers;

  Question({required this.questionId, required this.questionText,  required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'],
      questionText: json['question_text'],
      answers: (json['answers'] as List).map((answer) => Answer.fromJson(answer)).toList(),
    );
  }
}