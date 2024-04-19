import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_providers/theo_data_provider.dart';
import 'theo_test_event.dart';
import 'theo_test_state.dart';

class ExamBloc extends Bloc<TheoTestEvent, TheoTestState> {
  final ExamsDataProvider examsDataProvider;

  ExamBloc(this.examsDataProvider) : super(ExamInitial()) {
    on<FetchExams>((event, emit) async {
      emit(ExamLoading());
      try {
        final exams = await examsDataProvider.fetchExams();
        emit(ExamLoaded(exams));
      } catch (e) {
        print(e);
        emit(ExamError('Failed to load exams'));
      }
    });
  }
}
