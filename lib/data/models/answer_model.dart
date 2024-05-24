class Answer {
  final int answerId;
  final String answerText;
  final bool isCorrect;

  Answer(
      {required this.answerId,
      required this.answerText,
      required this.isCorrect});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answer_id'] ?? 0,
      answerText: json['answer_text'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      answerId: map['answer_id'] ?? 0,
      answerText: map['answer_text'] ?? '',
      isCorrect: map['is_correct'] == 1,
    );
  }
}