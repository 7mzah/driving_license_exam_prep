import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/blocs/RoadSignsTest/road_sign_state.dart';
import '../../../business_logic/blocs/RoadSignsTest/road_sign_bloc.dart';

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
                            onTap: () {
                              // Navigate to the practice mode page
                              if (kDebugMode) {
                                print('${exam.examTitle} pressed');
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
