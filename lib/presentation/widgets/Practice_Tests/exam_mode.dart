import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubits/exam_cubit.dart';
import '../TestFeatures/exam_simulator_stats_page.dart';
import '../TestStructure/exam_simulator_screen.dart';

class ExamMode extends StatefulWidget {
  const ExamMode({Key? key}) : super(key: key);

  @override
  _ExamModeState createState() => _ExamModeState();
}

class _ExamModeState extends State<ExamMode> {
  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Exam Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: const Text('Exam Simulator'),
                      onTap: () async {
                        final examCubit = BlocProvider.of<ExamCubit>(context);
                        final examStats = await examCubit.getExamStats(0);
                        if (examStats.isNotEmpty) {
                          print('Navigating to StatsPage');
                          // Set correctAnswers and totalQuestions in ExamCubit here
                          examCubit
                              .setCorrectAnswers(examStats['correctAnswers']);
                          examCubit
                              .setTotalQuestions(examStats['totalQuestions']);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ExamSimulatorStatsPage(
                              correctAnswers: examCubit.correctAnswers,
                              totalQuestions: examCubit.totalQuestions,
                              isFromQuestionScreen: false,
                            ),
                          ));
                          // Navigate to question screen
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _TimePickerDialog(
                                currentValue: _currentValue,
                                onValueChanged: (newValue) {
                                  setState(() {
                                    _currentValue = newValue;
                                  });
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
