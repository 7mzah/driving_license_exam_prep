class Answer {
  final int answerId;
  final String answerText;
  final bool isCorrect;

  Answer({required this.answerId, required this.answerText, required this.isCorrect});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answer_id'],
      answerText: json['answer_text'],
      isCorrect: json['is_correct'],
    );
  }
}