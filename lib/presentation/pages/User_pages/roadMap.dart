import 'package:driving_license_exam_prep/presentation/widgets/RoadMap/progress_bar_holder.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/blocs/progressBar/progress_bloc.dart';
import '../../../business_logic/blocs/progressBar/progress_event.dart';
import '../../../business_logic/blocs/progressBar/progress_state.dart';
import '../../widgets/RoadMap/progress_Bar.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";

  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 16),
          child: Text(
            'Road Map',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        // Using a Column for layout
        children: [
          BlocBuilder<ProgressBloc, ProgressState>(
            builder: (context, state) {
              if (state is ProgressUpdated) {
                return ProgressBar(progressValue: state.progress / 100);
              } else {
                return const ProgressBarHolder(); // Placeholder
              }
            },
          ),
          // Add your content here (likely with an Expanded or Flexible)
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<ProgressBloc>(context).add(TaskCompleted());
            },
            child: const Text('Simulate Lesson Completion'),
          ),
        ],
      ),
    );
  }
}

