import 'package:driving_license_exam_prep/business_logic/blocs/RoadSignsTest/road_sign_event.dart';
import 'package:driving_license_exam_prep/business_logic/blocs/RoadSignsTest/road_sign_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data_providers/theo_data_provider.dart';


class RoadSignBloc extends Bloc<RoadSignEvent, RoadSignState> {
  final ExamsDataProvider examDataProvider;

  RoadSignBloc(this.examDataProvider) : super(RoadSignInitial()) {
    on<FetchRoadSignsExams>((event, emit) async {
      emit(RoadSignLoading());
      try {
        final exams = await examDataProvider.fetchExams();
        emit(RoadSignLoaded(exams));
      } catch (e) {
        emit(RoadSignError('Failed to load road sign exams'));
      }
    });
  }
}
