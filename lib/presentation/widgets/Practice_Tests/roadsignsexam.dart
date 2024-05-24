import 'package:driving_license_exam_prep/data/data_providers/fetch_road_questions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/blocs/RoadSignsTest/road_sign_state.dart';
import '../../../business_logic/blocs/RoadSignsTest/road_sign_bloc.dart';
import '../../../business_logic/cubits/exam_cubit.dart';
import '../../../business_logic/providers/difficulty_level_provider.dart';
import '../TestStructure/questionscreen.dart';
import '../TestFeatures/stats_page.dart';

class RoadSignsExam extends StatelessWidget {
  const RoadSignsExam({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadSignBloc, RoadSignState>(
      builder: (context, state) {
        if (state is RoadSignLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RoadSignLoaded) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Road Signs Exam',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.exams.length,
                    itemBuilder: (context, index) {
                      final exam = state.exams[index];
                      return SizedBox(
                        width: 160,
                        child: Card(
                          child: ListTile(
                            title: Text(exam.difficultyLevel),
                            onTap: () async {
                              final examCubit =
                                  BlocProvider.of<ExamCubit>(context);
                              final examStats =
                                  await examCubit.getExamStats(exam.id+3);
                              if (examStats.isNotEmpty) {
                                print('Navigating to StatsPage');
                                // Set correctAnswers and totalQuestions in ExamCubit here
                                examCubit.setCorrectAnswers(
                                    examStats['correctAnswers']);
                                examCubit.setTotalQuestions(
                                    examStats['totalQuestions']);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StatsPage(
                                    correctAnswers: examCubit.correctAnswers,
                                    totalQuestions: examCubit.totalQuestions,
                                    examId: exam.id+3,
                                    isFromQuestionScreen: false,
                                    isRoadSignExam: true,
                                  ),
                                ));
                                // Navigate to question screen
                              } else {
                                Provider.of<DifficultyLevelNotifier>(context,
                                        listen: false)
                                    .updateDifficultyLevel(
                                        exam.difficultyLevel);
                                if (kDebugMode) {
                                  print('Navigating to QuestionScreen');
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuestionScreen(
                                      difficultyLevel: exam.difficultyLevel,
                                      examId: exam.id+3,
                                      fetchQuestions: fetchRoadQuestions,
                                      hasImages: true,
                                      isRoadSignExam: true,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is RoadSignError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
