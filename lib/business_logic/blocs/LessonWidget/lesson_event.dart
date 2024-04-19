import '../../../data/models/lesson_model.dart';

abstract class LessonEvent {}

class LessonStatusUpdated extends LessonEvent {
  final Lesson lesson;

  LessonStatusUpdated(this.lesson);
}

