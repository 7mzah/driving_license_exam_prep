import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/Local_database/database_helper.dart';
import '../../data/models/examAnswer.dart';
import '../../data/models/examQuestion.dart';

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

  Future<void> insertQuestion(int questionId, int examId, String questionText,
      String? questionImage) async {
    await DatabaseHelper.instance
        .insertQuestion(questionId, examId, questionText, questionImage);
  }

  Future<void> insertAnswer(
      int questionId, String userAnswer, String correctAnswer) async {
    await DatabaseHelper.instance.insertAnswer(
      questionId,
      userAnswer,
      correctAnswer,
    );
  }

  Future<Map<String, dynamic>> getExamStats(int examId) async {
    return await DatabaseHelper.instance.getExamStats(examId);
  }

  Future<List<ExamQuestion>> getExamQuestions(int examId) async {
    final questionMaps = await DatabaseHelper.instance.getExamQuestions(examId);

    return questionMaps.map((questionMap) {
      print(
          'Question image data: ${questionMap['questionImage']}'); // Add this line
      return ExamQuestion(
        questionId: questionMap['questionId'],
        questionText: questionMap['questionText'],
        questionImage: questionMap['questionImage'],
        examId: questionMap['examId'],
      );
    }).toList();
  }

  Future<List<ExamAnswer>> getExamAnswers(int questionId) async {
    final answerMaps = await DatabaseHelper.instance.getExamAnswers(questionId);

    print('Answer maps: $answerMaps'); // Add this line

    return answerMaps.map((answerMap) {
      return ExamAnswer(
        answerId: answerMap.answerId,
        userAnswer: answerMap.userAnswer,
        correctAnswer: answerMap.correctAnswer,
      );
    }).toList();
  }

  void setCorrectAnswers(int correct) {
    correctAnswers = correct;
  }

  void setTotalQuestions(int total) {
    totalQuestions = total;
  }

  Future deleteExamStats(int examId) async {
    await DatabaseHelper.instance.deleteExamStats(examId);
  }

  Future<void> storeQuestionAndAnswers(
    int examId,
    int questionId,
    String questionText,
    String userAnswer,
    String correctAnswer,
    String? questionImage, // questionImage can be null
  ) async {
    // Check if questionImage is null before inserting
    switch (questionImage) {
      case _?:
        await insertQuestion(
          questionId,
          examId,
          questionText,
          questionImage,
        );
        await insertAnswer(
          questionId,
          userAnswer,
          correctAnswer,
        );
      default:
        await insertQuestion(
          questionId,
          examId,
          questionText,
          questionImage,
        );
        //store the user answer and correct answer in the database
        await insertAnswer(
          questionId,
          userAnswer,
          correctAnswer,
        );
    }
  }

//delete all the questions and answers for a given exam
  void deleteExamQuestionsAndAnswers(int examId) async {
    await DatabaseHelper.instance.deleteExamQuestionsAndAnswers(examId);
  }

  Future<void> insertSimQuestion(int questionId, int examId,
      String questionText, String? questionImage) async {
    await DatabaseHelper.instance
        .insertSimQuestion(questionId, examId, questionText, questionImage);
  }

  Future<void> insertSimAnswer(
      int questionId, String userAnswer, String correctAnswer) async {
    await DatabaseHelper.instance.insertSimAnswer(
      questionId,
      userAnswer,
      correctAnswer,
    );
  }

  Future<List<ExamQuestion>> getSimExamQuestions(int examId) async {
    final questionMaps =
        await DatabaseHelper.instance.getSimExamQuestions(examId);

    return questionMaps.map((questionMap) {
      return ExamQuestion(
        questionId: questionMap['questionId'],
        questionText: questionMap['questionText'],
        questionImage: questionMap['questionImage'],
        examId: questionMap['examId'],
      );
    }).toList();
  }

  Future<List<ExamAnswer>> getSimExamAnswers(int questionId) async {
    final answerMaps =
        await DatabaseHelper.instance.getSimExamAnswers(questionId);

    return answerMaps.map((answerMap) {
      return ExamAnswer(
        answerId: answerMap.answerId,
        userAnswer: answerMap.userAnswer,
        correctAnswer: answerMap.correctAnswer,
      );
    }).toList();
  }

  Future<void> storeSimQuestionAndAnswers(
    int examId,
    int questionId,
    String questionText,
    String userAnswer,
    String correctAnswer,
    String? questionImage, // questionImage can be null
  ) async {
    // Check if questionImage is null before inserting
    switch (questionImage) {
      case _?:
        await insertSimQuestion(
          questionId,
          examId,
          questionText,
          questionImage,
        );
        await insertSimAnswer(
          questionId,
          userAnswer,
          correctAnswer,
        );
      default:
        await insertSimQuestion(
          questionId,
          examId,
          questionText,
          questionImage,
        );
        //store the user answer and correct answer in the database
        await insertSimAnswer(
          questionId,
          userAnswer,
          correctAnswer,
        );
    }
  }

  //delete all the questions and answers for a given exam
  Future deleteSimExamQuestionsAndAnswers(int examId) async {
    await DatabaseHelper.instance.deleteSimExamQuestionsAndAnswers(examId);
  }
}
