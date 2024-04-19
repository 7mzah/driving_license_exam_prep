import '../../../data/models/exam_model.dart';

abstract class RoadSignState {}

class RoadSignInitial extends RoadSignState {}

class RoadSignLoading extends RoadSignState {}

class RoadSignLoaded extends RoadSignState {
  final List<Exam> exams;

  RoadSignLoaded(this.exams);
}

class RoadSignError extends RoadSignState {
  final String message;

  RoadSignError(this.message);
}