import 'dart:typed_data';

class ExamQuestion {
  final int questionId;
  final String questionText;
  final Uint8List? questionImage;
  final int examId;

  ExamQuestion({
    required this.questionId,
    required this.questionText,
    this.questionImage,
    required this.examId,
  });

  static ExamQuestion fromMap(Map<String, dynamic> map) {
    return ExamQuestion(
      questionId: map['questionId'] as int,
      questionText: map['questionText'] as String,
      questionImage: map['questionImage'] != null ? map['questionImage'] as Uint8List : null,
      examId: map['examId'] as int,
    );
  }
}
