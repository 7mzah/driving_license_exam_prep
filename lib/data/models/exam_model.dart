class Exam {
  final int id;
  final String examTitle;
  final String difficultyLevel;

  Exam({required this.id, required this.examTitle, required this.difficultyLevel});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      examTitle: json['exam_title'],
      difficultyLevel: json['difficulty_level'],
    );
  }
}