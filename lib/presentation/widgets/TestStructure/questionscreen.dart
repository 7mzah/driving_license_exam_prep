import 'dart:async';
import 'dart:convert';

import 'package:driving_license_exam_prep/data/models/question_model.dart';
import 'package:driving_license_exam_prep/presentation/widgets/TestFeatures/stats_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubits/exam_cubit.dart';
import 'answer_list.dart';
import 'navigation_buttons.dart';

class QuestionScreen extends StatefulWidget {
  final Future<List<Question>> Function(String) fetchQuestions;
  final bool hasImages;
  final String difficultyLevel;
  final int examId;
  final bool isRoadSignExam;

  const QuestionScreen({
    required this.fetchQuestions,
    this.hasImages = false,
    required this.difficultyLevel,
    required this.examId,
    this.isRoadSignExam = false,
    super.key,
  });

  @override
  QuestionScreenState createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;
  Map<int, bool> showCorrectAnswer = {};
  int? selectedChoiceId;
  Map<int, int> selectedAnswers = {};
  ValueNotifier<int> questionIndexController = ValueNotifier<int>(0);
  Future<List<Question>>? questionsFuture;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('QuestionScreen difficultyLevel: ${widget.difficultyLevel}');
    }
    if (kDebugMode) {
      print('QuestionScreen examId: ${widget.examId}');
    }
    questionsFuture = widget.fetchQuestions(widget.difficultyLevel);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(child: Text('Error: ${snapshot.error.toString()}')),
          );
        } else if (snapshot.hasData) {
          final questions = snapshot.data!;
          return ValueListenableBuilder<int>(
            valueListenable: questionIndexController,
            builder: (context, index, child) {
              final question = questions[index];
              final selectedChoiceId = selectedAnswers[question.questionId];
              final hasAnswered =
                  selectedAnswers.containsKey(question.questionId);

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                      'Questions - ${widget.difficultyLevel} (${index + 1}/${questions.length})'),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.hasImages && question.questionImage != null)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            // Adjust the aspect ratio as needed
                            child: Image.memory(
                              base64Decode(question.questionImage!),
                              fit: BoxFit
                                  .contain, // Use BoxFit.cover to maintain the aspect ratio
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(question.questionText,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        AnswersList(
                          key: ValueKey(question.questionId),
                          answers: question.answers,
                          hasAnswered: hasAnswered,
                          selectedChoiceId: selectedChoiceId,
                          showCorrectAnswer:
                              showCorrectAnswer[question.questionId] ?? false,
                          onAnswerSelected: (value) {
                            final isCorrect = !question.answers
                                .firstWhere(
                                    (answer) => answer.answerId == value)
                                .isCorrect;
                            setState(() {
                              selectedAnswers[question.questionId] = value!;
                              showCorrectAnswer[question.questionId] =
                                  isCorrect;
                            });
                            final examCubit =
                                BlocProvider.of<ExamCubit>(context);

                            //store user choice in a variable for future use
                            String userAnswer = question.answers
                                .firstWhere(
                                    (answer) => answer.answerId == value)
                                .answerText;

                            //store the correct answer in a variable for future use
                            String correctAnswer = question.answers
                                .firstWhere((answer) => answer.isCorrect)
                                .answerText;
                            //store question image in a var for future use
                            String? questionImage = question.questionImage;

                            //store question id in a var for future use
                            int questionId = question.questionId;

                            //kdebug to see the user answer
                            if (kDebugMode) {
                              print('User Answer: $userAnswer');
                            }
                            if (kDebugMode) {
                              print('Correct Answer: $correctAnswer');
                            }
                            //kdebug to see the questionId
                            if (kDebugMode) {
                              print('Question ID: $questionId');
                            }
                            //kdebug to see question image
                            if (kDebugMode) {
                              print('Question Image: $questionImage');
                            }
                            examCubit.storeQuestionAndAnswers(
                              widget.examId,
                              question.questionId,
                              question.questionText,
                              userAnswer,
                              correctAnswer,
                              question.questionImage,
                            );
                          },
                        ),
                      ],
                    ),
                    NavigationButtons(
                      currentQuestionIndex: index,
                      totalQuestions: questions.length,
                      onPrevious: () {
                        if (index > 0) {
                          currentQuestionIndex--;
                          questionIndexController.value = currentQuestionIndex;
                        }
                      },
                      onNext: () {
                        if (index < questions.length - 1) {
                          currentQuestionIndex++;
                          questionIndexController.value = currentQuestionIndex;
                        } else if (selectedAnswers.length == questions.length) {
                          int correctAnswers = selectedAnswers.values
                              .where((answerId) => questions.any((question) =>
                                  question.answers.any((answer) =>
                                      answer.answerId == answerId &&
                                      answer.isCorrect)))
                              .length;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ExamCubit(),
                                child: StatsPage(
                                  correctAnswers: correctAnswers,
                                  totalQuestions: questions.length,
                                  examId: widget.examId,
                                  isFromQuestionScreen: true,
                                  isRoadSignExam: widget.isRoadSignExam,
                                ),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please answer all questions before proceeding.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Unexpected Error'),
            ),
            body: const Center(child: Text('Unexpected Error')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    questionIndexController.dispose();
    super.dispose();
  }
}
