import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/blocs/progressBar/progress_bloc.dart';
import '../../../business_logic/blocs/progressBar/progress_event.dart';
import '../../../business_logic/blocs/progressBar/progress_state.dart';
import '../../widgets/RoadMap/ProgressBar/progress_Bar.dart';
import '../../widgets/RoadMap/ProgressBar/progress_bar_holder.dart';
import '../../widgets/RoadMap/chapter.dart';
import '../../widgets/RoadMap/lesson.dart';
import '../../widgets/RoadMap/user_status.dart';

class RoadMap extends StatelessWidget {
  const RoadMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final progressBloc = BlocProvider.of<ProgressBloc>(context);
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: 120,
          collapsedHeight: 112,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: BlocBuilder<ProgressBloc, ProgressState>(
              builder: (context, state) {
                if (state is ProgressUpdated) {
                  return ProgressBar(progressValue: state.progress / 100);
                } else {
                  return const ProgressBarHolder(); // Placeholder
                }
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: Text(
              'Road Map',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          centerTitle: false,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Column(children: [
                Center(
                  child: Text(
                    'Earn 50 points to level up',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                //create a row the has level, points and lessons separated by a straight line

                const UserStatus(),

                ElevatedButton(
                  onPressed: () {
                    progressBloc.add(TaskCompleted());
                  },
                  child: const Text('Simulate Lesson Completion'),
                ),
                const Chapter(
                    chapterName: "Road Rules 1",
                    totalLessons: 7,
                    completedLessons: 1),

                const LessonWidget(
                    lessonNumber: 1,
                    lessonTitle: "introduction",
                    isAccessible: true,
                    isCompleted: false),
              ])
            ],
          ),
        ),
      ],
    );
  }
}
