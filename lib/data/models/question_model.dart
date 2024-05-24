import 'answer_model.dart';

class Question {
  final int questionId;
  final String questionText;
  final List<Answer> answers;
  final String? questionImage;
  final String? correctAnswer;
  late final String? userAnswer;

  Question({
    required this.questionId,
    required this.questionText,
    required this.answers,
    this.questionImage,
    this.correctAnswer,
    this.userAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'] ?? 0,
      questionText: json['question_text'] ?? '',
      answers: (json['answers'] as List)
          .map((answer) => Answer.fromJson(answer))
          .toList(),
      questionImage: json['question_image'],
      correctAnswer: json['correct_answer'],
      userAnswer: json['user_answer'],
    );
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['question_id'],
      questionText: map['question_text'],
      answers: (map['answers'] as List)
          .map((answer) => Answer.fromMap(answer))
          .toList(),
      questionImage: map['question_image'],
      correctAnswer: map['correct_answer'],
      userAnswer: map['user_answer'],
    );
  }
}