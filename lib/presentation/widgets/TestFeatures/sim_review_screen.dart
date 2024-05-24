/**import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/examQuestion.dart';
import '../../../data/models/examAnswer.dart';
import '../../../business_logic/cubits/exam_cubit.dart';
import '../../widgets/TestFeatures/question_card.dart';

class SimReviewScreen extends StatefulWidget {
  final List<ExamQuestion> questionMaps;

  const SimReviewScreen({super.key, required this.questionMaps});

  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<SimReviewScreen> {
  late Future<List<List<ExamAnswer>>> futureAnswers;

  @override
  void initState() {
    super.initState();
    futureAnswers = Future.wait(widget.questionMaps.map((question) =>
        BlocProvider.of<ExamCubit>(context)
            .getSimExamAnswers(question.questionId)));
  }

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
            return ListView.builder(
              itemCount: widget.questionMaps.length,
              itemBuilder: (context, index) {
                final question = widget.questionMaps[index];
                List<ExamAnswer> answers = allAnswers[index];
                String userAnswer = 'No answer selected';
                String correctAnswer = 'No correct answer';

                if (answers.isNotEmpty) {
                  var selectedAnswer = answers.firstWhere(
                      (answer) => answer.userAnswer != null,
                      orElse: () => ExamAnswer(
                          answerId: 0,
                          userAnswer: 'No user answer',
                          correctAnswer: ''));
                  userAnswer = selectedAnswer.userAnswer;

                  var correctAnswerObj = answers.firstWhere(
                      (answer) => answer.correctAnswer != null,
                      orElse: () => ExamAnswer(
                          answerId: 0,
                          userAnswer: '',
                          correctAnswer: 'No correct answer'));
                  correctAnswer = correctAnswerObj.correctAnswer;
                }

                return QuestionCard(
                  question: question.questionText,
                  userAnswer: userAnswer,
                  correctAnswer: correctAnswer,
                  questionImage: question.questionImage,
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
**/