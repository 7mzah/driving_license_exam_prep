import 'package:driving_license_exam_prep/presentation/widgets/TestFeatures/review_screen.dart';
import 'package:driving_license_exam_prep/presentation/widgets/TestStructure/questionscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../business_logic/cubits/exam_cubit.dart';
import '../../../data/data_providers/fetch_road_questions.dart';
import '../../../data/data_providers/fetch_theo_questions.dart';

class StatsPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final int examId;
  final bool isFromQuestionScreen;
  final bool isRoadSignExam;

  const StatsPage(
      {super.key,
      required this.correctAnswers,
      required this.totalQuestions,
       this.examId =0,
       this.isFromQuestionScreen = false,
       this.isRoadSignExam = false});

  @override
  Widget build(BuildContext context) {
    print('correctAnswers: $correctAnswers');
    print('totalQuestions: $totalQuestions');
    final incorrectAnswers = totalQuestions - correctAnswers;
    final examCubit = BlocProvider.of<ExamCubit>(context);
    if (isFromQuestionScreen) {
      examCubit.completeExam(totalQuestions, correctAnswers, examId);
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Stats'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: CircularPercentIndicator(
                  radius: 88.0,
                  lineWidth: 24.0,
                  animation: true,
                  percent: correctAnswers / totalQuestions,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${(correctAnswers / totalQuestions * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Correct   ",
                          ),
                          Text("$correctAnswers",
                              style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Incorrect ",
                          ),
                          Text("$incorrectAnswers",
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.background),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      //style the elevated button to have rectangular rounder corners

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        var questionMaps = await examCubit.getExamQuestions(examId);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(questionMaps: questionMaps, examId: examId,),
                          ),
                        );
                      },
                      child: const Text('Review'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      //style the elevated button to have rectangular rounder corners
                      style: ElevatedButton.styleFrom(
                        //add color to the elevated button
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),

                      onPressed: () async {
                        examCubit.deleteExamStats(examId);
                        examCubit.deleteExamQuestionsAndAnswers(examId);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String difficultyLevel =
                            prefs.getString('difficultyLevel') ?? '';
                        print(
                            'difficultyLevel before navigation: $difficultyLevel');
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            print('difficultyLevel: $difficultyLevel');
                            print('examId: $examId');
                            return QuestionScreen(
                              difficultyLevel: difficultyLevel,
                              examId: examId,
                              fetchQuestions: isRoadSignExam
                                  ? fetchRoadQuestions
                                  : fetchTheoQuestions,
                              hasImages: isRoadSignExam,
                            );
                          },
                        ));
                      },
                      // ...

                      child: Text(
                        'Restart Test',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
