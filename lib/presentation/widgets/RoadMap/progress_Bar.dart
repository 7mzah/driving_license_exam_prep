import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/blocs/progressBar/progress_bloc.dart';
import '../../../business_logic/blocs/progressBar/progress_state.dart';

class ProgressBar extends StatelessWidget {
  final double progressValue;

  const ProgressBar({super.key, required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: LayoutBuilder(// Use LayoutBuilder for dynamic sizing
              builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Progress bar as the background layer
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 20,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(20.0),
                      value: progressValue,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                // Positioned Icon to indicate progress above the progress bar
                Positioned(
                  left: (progressValue *
                          MediaQuery.of(context).size.width *
                          0.8),
                  top: -20,
                  child: Icon(
                    Icons.car_crash_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
