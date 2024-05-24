import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/cubits/exam_cubit.dart';
import '../../../data/data_providers/fetch_simulator_questions.dart';
import '../../../data/models/question_model.dart';
import '../TestFeatures/exam_simulator_stats_page.dart';
import 'exam_sim_question_card.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class ExamSimulatorScreen extends StatefulWidget {
  final int examTime;

  const ExamSimulatorScreen({super.key, required this.examTime});

  @override
  ExamSimulatorScreenState createState() => ExamSimulatorScreenState();
}

class ExamSimulatorScreenState extends State<ExamSimulatorScreen> {
  late Future<List<Question>> questionsFuture;
  Map<int, int?> selectedAnswers = {}; // Changed to nullable int
  late Timer _timer;
  int _remainingTime = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  int examId = 0;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.examTime * 60;
    questionsFuture = fetchSimQuestions();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _submitExam();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _submitExam() async {
    try {
      final List<Question> questions = await questionsFuture;
      _correctAnswers = 0;
      var examCubit = Provider.of<ExamCubit>(context, listen: false);

      for (var question in questions) {
        int? selectedAnswerId = selectedAnswers[question.questionId];
        if (selectedAnswerId != null &&
            question.answers.any((element) =>
                element.answerId == selectedAnswerId && element.isCorrect)) {
          _correctAnswers++;
        }

        String userAnswer;
        if (selectedAnswerId != null &&
            question.answers
                .any((answer) => answer.answerId == selectedAnswerId)) {
          userAnswer = question.answers
              .firstWhere((answer) => answer.answerId == selectedAnswerId)
              .answerText;
        } else {
          userAnswer = "No answer selected";
        }

        String correctAnswer = question.answers
            .firstWhere((answer) => answer.isCorrect)
            .answerText;

        await examCubit.storeSimQuestionAndAnswers(
          examId,
          question.questionId,
          question.questionText,
          userAnswer,
          correctAnswer,
          question.questionImage,
        );
      }

      print('selectedAnswers: $selectedAnswers');
      print('_correctAnswers: $_correctAnswers');

      //navigate to stats page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ExamCubit(),
            child: ExamSimulatorStatsPage(
              correctAnswers: _correctAnswers,
              totalQuestions: _totalQuestions,
              isFromQuestionScreen: true,
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error occurred while submitting exam: $e');
      // You can also show a dialog or a snackbar to inform the user about the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            //navigate to the dashboard
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
            'Time Remaining: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}'),
      ),
      body: FutureBuilder<List<Question>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Question> questions = snapshot.data!;
            _totalQuestions = questions.length;
            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ExamSimQuestionCard(
                  key: ValueKey(questions[index].questionId),
                  question: questions[index],
                  selectedAnswer: selectedAnswers[questions[index].questionId],
                  onAnswerSelected: (selectedAnswerId) {
                    setState(() {
                      selectedAnswers[questions[index].questionId] =
                          selectedAnswerId;
                    });
                  },
                  questionNumber: index + 1,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitExam,
        child: const Icon(Icons.check),
      ),
    );
  }
}
