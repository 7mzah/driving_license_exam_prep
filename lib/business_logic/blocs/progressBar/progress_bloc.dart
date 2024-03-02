import 'package:bloc/bloc.dart';
import 'progress_event.dart';
import 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc() : super(const ProgressInitial()) {
    on<TaskCompleted>((event, emit) {
      // Assuming previous tasks influence progress
      int newProgress = (state is ProgressUpdated ? (state as ProgressUpdated).progress : 0) + 10; // 10% increase per task completed (example).clamp(0, 100);
      emit(ProgressUpdated(newProgress));
    });

    on<ProgressReset>((event, emit) => emit(const ProgressInitial()));
  }
}
