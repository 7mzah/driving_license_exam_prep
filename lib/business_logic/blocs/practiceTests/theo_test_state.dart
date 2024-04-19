import '../../../data/models/exam_model.dart';

abstract class TheoTestState {}

class ExamInitial extends TheoTestState {}

class ExamLoading extends TheoTestState {}

class ExamLoaded extends TheoTestState {
  final List<Exam> exams;

  ExamLoaded(this.exams);
}

class ExamError extends TheoTestState {
  final String message;

  ExamError(this.message);
}