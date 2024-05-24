class ExamAnswer {
  final int answerId;
  final String userAnswer;
  final String correctAnswer;

  ExamAnswer({
    required this.answerId,
    required this.userAnswer,
    required this.correctAnswer,
  });

  static ExamAnswer fromMap(Map<String, dynamic> map) {
    return ExamAnswer(
      answerId: map['answerId'] as int,
      userAnswer: map['userAnswer'] as String,
      correctAnswer: map['correctAnswer'] as String,
    );
  }
}