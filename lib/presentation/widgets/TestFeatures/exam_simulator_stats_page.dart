import 'package:driving_license_exam_prep/data/data_providers/fetch_simulator_questions.dart';
import 'package:driving_license_exam_prep/presentation/pages/navigation.dart';
import 'package:driving_license_exam_prep/presentation/widgets/TestFeatures/review_screen.dart';
import 'package:driving_license_exam_prep/presentation/widgets/TestFeatures/sim_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubits/exam_cubit.dart';
import '../../../data/models/examQuestion.dart';
import '../../../data/models/question_model.dart';
import '../TestStructure/exam_simulator_screen.dart';

class ExamSimulatorStatsPage extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final bool isFromQuestionScreen;

   ExamSimulatorStatsPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.isFromQuestionScreen,
  });


  @override
  State<ExamSimulatorStatsPage> createState() => _ExamSimulatorStatsPageState();

}

class _ExamSimulatorStatsPageState extends State<ExamSimulatorStatsPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final incorrectAnswers = widget.totalQuestions - widget.correctAnswers;
    var currentValue = 1;
    var examCubit =
        context.read<ExamCubit>(); // Replace with your actual Bloc or Cubit
    if (widget.isFromQuestionScreen) {
      examCubit.completeExam(widget.totalQuestions, widget.correctAnswers, 0);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Simulator Stats'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Dashboard()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: CircularPercentIndicator(
              radius: 88.0,
              lineWidth: 24.0,
              animation: true,
              percent: widget.correctAnswers / widget.totalQuestions,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(widget.correctAnswers / widget.totalQuestions * 100).toStringAsFixed(0)}%",
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
                      Text("${widget.correctAnswers}",
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
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      var questionMaps =
                          await examCubit.getSimExamQuestions(0);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewScreen(questionMaps: questionMaps, examId: 0,),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      await examCubit.deleteSimExamQuestionsAndAnswers(0);
                      await examCubit.deleteExamStats(0);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _TimePickerDialog(
                            currentValue: currentValue,
                            onValueChanged: (newValue) {
                              setState(() {
                                currentValue = newValue;
                              });
                            },
                          );
                        },
                      );
                    },
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
          )
          // Add any additional widgets you need for the ExamSimulatorStatsPage here
        ],
      ),
    );
  }
}

class _TimePickerDialog extends StatefulWidget {
  final int currentValue;
  final ValueChanged<int> onValueChanged;

  const _TimePickerDialog({
    required this.currentValue,
    required this.onValueChanged,
  });

  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('Choose your time for the 30 random generated questions'),
      content: DropdownButton<int>(
        value: _currentValue,
        items: <int>[1, 5, 10, 15, 20, 25, 30]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
              value: value,
              child: Text(value == 1 ? '$value minute' : '$value minutes'));
        }).toList(),
        onChanged: (int? newValue) {
          setState(() {
            _currentValue = newValue!;
          });
          widget.onValueChanged(newValue!);
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Continue'),
          onPressed: () {
            // Navigate to ExamSimulatorScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ExamSimulatorScreen(examTime: _currentValue)),
            );
          },
        ),
      ],
    );
  }
}
