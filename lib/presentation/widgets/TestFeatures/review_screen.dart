import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/examQuestion.dart';
import '../../../data/models/examAnswer.dart';
import '../../../business_logic/cubits/exam_cubit.dart';
import '../../widgets/TestFeatures/question_card.dart';

class ReviewScreen extends StatefulWidget {
  final List<ExamQuestion> questionMaps;
  final int examId;

  const ReviewScreen({super.key, required this.questionMaps, required this.examId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late Future<List<List<ExamAnswer>>> futureAnswers;

@override
void initState() {
  super.initState();

  futureAnswers = Future.wait(widget.questionMaps.map((question) =>
      widget.examId == 0
      ? BlocProvider.of<ExamCubit>(context).getSimExamAnswers(question.questionId)
      : BlocProvider.of<ExamCubit>(context).getExamAnswers(question.questionId)
  ));
}

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Review - ${widget.questionMaps.length} questions'),
    ),
    body: FutureBuilder<List<List<ExamAnswer>>>(
      future: futureAnswers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<List<ExamAnswer>> allAnswers = snapshot.data!;

          // Create a copy of questionMaps and sort it
          List<ExamQuestion> sortedQuestionMaps = List.from(widget.questionMaps);
          sortedQuestionMaps.sort((a, b) {
            int indexA = widget.questionMaps.indexOf(a);
            int indexB = widget.questionMaps.indexOf(b);
            String userAnswerA = allAnswers[indexA]
                .firstWhere((answer) => answer.userAnswer != null,
                    orElse: () => ExamAnswer(
                        answerId: 0,
                        userAnswer: 'No user answer',
                        correctAnswer: ''))
                .userAnswer;
            String correctAnswerA = allAnswers[indexA]
                .firstWhere((answer) => answer.correctAnswer != null,
                    orElse: () => ExamAnswer(
                        answerId: 0,
                        userAnswer: '',
                        correctAnswer: 'No correct answer'))
                .correctAnswer;
            String userAnswerB = allAnswers[indexB]
                .firstWhere((answer) => answer.userAnswer != null,
                    orElse: () => ExamAnswer(
                        answerId: 0,
                        userAnswer: 'No user answer',
                        correctAnswer: ''))
                .userAnswer;
            String correctAnswerB = allAnswers[indexB]
                .firstWhere((answer) => answer.correctAnswer != null,
                    orElse: () => ExamAnswer(
                        answerId: 0,
                        userAnswer: '',
                        correctAnswer: 'No correct answer'))
                .correctAnswer;

            if (userAnswerA == correctAnswerA && userAnswerB != correctAnswerB) {
              return 1;
            } else if (userAnswerA != correctAnswerA && userAnswerB == correctAnswerB) {
              return -1;
            } else {
              return 0;
            }
          });

          return ListView.builder(
            itemCount: sortedQuestionMaps.length,
            itemBuilder: (context, index) {
              final question = sortedQuestionMaps[index];
              List<ExamAnswer> answers = allAnswers[widget.questionMaps.indexOf(question)];
              String userAnswer = answers
                  .firstWhere((answer) => answer.userAnswer != null,
                      orElse: () => ExamAnswer(
                          answerId: 0,
                          userAnswer: 'No user answer',
                          correctAnswer: ''))
                  .userAnswer;
              String correctAnswer = answers
                  .firstWhere((answer) => answer.correctAnswer != null,
                      orElse: () => ExamAnswer(
                          answerId: 0,
                          userAnswer: '',
                          correctAnswer: 'No correct answer'))
                  .correctAnswer;

              return QuestionCard(
                question: question.questionText,
                userAnswer: userAnswer,
                correctAnswer: correctAnswer,
                questionImage: question.questionImage,
                isCorrect: userAnswer == correctAnswer,
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    ),
  );
}}
