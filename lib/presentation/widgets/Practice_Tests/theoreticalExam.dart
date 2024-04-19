// lib/presentation/widgets/Practice_Tests/theoreticalExam.dart
import 'package:driving_license_exam_prep/business_logic/providers/difficulty_level_provider.dart';
import 'package:driving_license_exam_prep/presentation/widgets/TestStructure/questionscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/blocs/practiceTests/theo_test_bloc.dart';
import '../../../business_logic/blocs/practiceTests/theo_test_state.dart';
import '../../../business_logic/cubits/exam_cubit.dart';
import '../TestStructure/stats_page.dart';
import 'package:provider/provider.dart';

class TheoreticalExam extends StatelessWidget {
  const TheoreticalExam({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, TheoTestState>(
      builder: (context, state) {
        if (state is ExamLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExamLoaded) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Theoretical Exam',
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
                                  await examCubit.getExamStats(exam.id);
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
                                    examId: exam.id,
                                    isFromQuestionScreen: false,
                                  ),
                                ));
                              } else {
                                Provider.of<DifficultyLevelNotifier>(context,
                                        listen: false)
                                    .updateDifficultyLevel(exam.difficultyLevel);
                                print('Navigating to QuestionScreen');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuestionScreen(
                                      difficultyLevel: exam.difficultyLevel,
                                      examId: exam.id,
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
        } else if (state is ExamError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
