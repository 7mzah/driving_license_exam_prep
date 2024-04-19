import 'package:flutter_bloc/flutter_bloc.dart';

import 'lesson_state.dart';
import 'lesson_event.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc() : super(LessonInitial() ) {
    on<LessonStatusUpdated>((event, emit) {
      // Assuming event.lesson contains updated lesson data
      emit(
        CurrentState(
            isAccessible: event.lesson.isAccessible,
            isCompleted: event.lesson.isCompleted),
      );
    });

    // Add more events as needed (e.g., LessonUnlocked, LessonCompleted)
  }
}
