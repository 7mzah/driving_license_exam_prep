abstract class LessonState {}

class LessonInitial extends LessonState {}

class CurrentState extends LessonState {
  final bool isAccessible;
  final bool isCompleted;

  CurrentState({
    required this.isAccessible,
    required this.isCompleted,
  });
}