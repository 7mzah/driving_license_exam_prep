// lib/presentation/pages/User_pages/practiceTests.dart
import 'package:driving_license_exam_prep/data/data_providers/theo_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/blocs/RoadSignsTest/road_sign_event.dart';
import '../../../business_logic/blocs/RoadSignsTest/road_sign_bloc.dart';
import '../../../business_logic/blocs/practiceTests/theo_test_bloc.dart';
import '../../../business_logic/blocs/practiceTests/theo_test_event.dart';
import '../../../business_logic/providers/difficulty_level_provider.dart';
import '../../widgets/Practice_Tests/exam_mode.dart';
import '../../widgets/Practice_Tests/practicemode.dart';
import '../../widgets/Practice_Tests/roadsignsexam.dart';
import '../../widgets/Practice_Tests/theoreticalExam.dart';

class PracticeTestPage extends StatefulWidget {
  static const String id = 'practice_test_page';

  const PracticeTestPage({super.key});

  @override
  PracticeTestPageState createState() => PracticeTestPageState();
}

class PracticeTestPageState extends State<PracticeTestPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExamBloc>(
          create: (context) => ExamBloc(ExamsDataProvider())..add(FetchExams()),
        ),
        BlocProvider<RoadSignBloc>(
          create: (context) => RoadSignBloc(ExamsDataProvider())..add(FetchRoadSignsExams()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: Text(
              'Practice Test',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        body:  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ChangeNotifierProvider(
                create: (context) => DifficultyLevelNotifier(),
                  child: const TheoreticalExam()),
              const SizedBox(height: 16),
              const RoadSignsExam(),
              const SizedBox(height: 16),
              const PracticeMode(),
              const ExamMode(),
            ],
          ),
        ),
      ),
    );
  }
}