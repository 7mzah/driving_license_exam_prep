import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/Local_database/database_helper.dart';

class ExamCubit extends Cubit<int> {
  int correctAnswers = 0;
  int totalQuestions = 0;

  ExamCubit() : super(0);

  void completeExam(int totalQuestions, int correctAnswers, int examId) async {
    await DatabaseHelper.instance
        .insertExam(totalQuestions, correctAnswers, examId);
    this.correctAnswers = correctAnswers;
    this.totalQuestions = totalQuestions;
  }

  void insertQuestion(int examId, String questionText, String correctAnswer,
      String userAnswer) async {
    await DatabaseHelper.instance
        .insertQuestion(examId, questionText, correctAnswer, userAnswer);
  }

  Future<Map<String, dynamic>> getExamStats(int examId) async {
    return await DatabaseHelper.instance.getExamStats(examId);
  }

  Future<List<Map<String, dynamic>>> getExamQuestions(int examId) async {
    return await DatabaseHelper.instance.getExamQuestions(examId);
  }

  void setCorrectAnswers(int correct) {
    correctAnswers = correct;
  }

  void setTotalQuestions(int total) {
    totalQuestions = total;
  }

  void deleteExamStats(int examId) async {
    await DatabaseHelper.instance.deleteExamStats(examId);
  }
}
