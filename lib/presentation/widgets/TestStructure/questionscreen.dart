import 'dart:async';

import 'package:driving_license_exam_prep/data/models/question_model.dart';
import 'package:driving_license_exam_prep/presentation/widgets/TestStructure/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubits/exam_cubit.dart';
import '../../../data/data_providers/fetch_theo_questions.dart';
import 'answer_list.dart';
import 'navigation_buttons.dart';

class QuestionScreen extends StatefulWidget {
  final String difficultyLevel;
  final int examId;

  const QuestionScreen(
      {super.key, required this.difficultyLevel, required this.examId});

  @override
  QuestionScreenState createState() => QuestionScreenState();


}

class QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;
  Map<int, bool> showCorrectAnswer = {};
  int? selectedChoiceId;
  Map<int, int> selectedAnswers = {};
  StreamController<int> questionIndexController = StreamController<int>();
  Future<List<Question>>? questionsFuture;



  @override
void initState() {
  super.initState();
  print('QuestionScreen difficultyLevel: ${widget.difficultyLevel}');
  print('QuestionScreen examId: ${widget.examId}');
  questionsFuture = fetchTheoQuestions(widget.difficultyLevel);
}

  @override
  Widget build(BuildContext context) {
    if (questionsFuture == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return StreamBuilder<int>(
      stream: questionIndexController.stream,
      initialData: currentQuestionIndex,
      builder: (context, snapshot) {
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
                body:
                    Center(child: Text('Error: ${snapshot.error.toString()}')),
              );
            } else if (snapshot.hasData) {
              final questions = snapshot.data!;
              if (currentQuestionIndex < questions.length) {
                final question = questions[currentQuestionIndex];
                final selectedChoiceId = selectedAnswers[question.questionId];
                final hasAnswered =
                    selectedAnswers.containsKey(question.questionId);

                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                        'Questions - ${widget.difficultyLevel} (${currentQuestionIndex + 1}/${questions.length})'),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              setState(() {
                                selectedAnswers[question.questionId] = value!;
                                showCorrectAnswer[question.questionId] =
                                    !question.answers
                                        .firstWhere((answer) =>
                                            answer.answerId == value)
                                        .isCorrect;
                              });
                            },
                          ),
                        ],
                      ),
                      NavigationButtons(
                        currentQuestionIndex: currentQuestionIndex,
                        totalQuestions: questions.length,
                        onPrevious: () {
                          setState(() {
                            currentQuestionIndex--;
                            questionIndexController.add(currentQuestionIndex);
                          });
                        },
                        // When navigating to the StatsPage
                        onNext: () {
                          if (currentQuestionIndex == questions.length - 1 &&
                              selectedAnswers.length != questions.length) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please answer all questions before proceeding.'),
                              ),
                            );
                          } else if (currentQuestionIndex ==
                              questions.length - 1) {
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
                                    examId: widget.examId, isFromQuestionScreen: true,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              currentQuestionIndex++;
                              questionIndexController.add(currentQuestionIndex);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Scaffold(

                  appBar: AppBar(
                    title: const Text('Done'),
                  ),
                  body: const Center(child: Text('No more questions')),
                );
              }
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
      },
    );
  }

  @override
  void dispose() {
    questionIndexController.close();
    super.dispose();
  }
}
