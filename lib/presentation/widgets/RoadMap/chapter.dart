import 'package:flutter/material.dart';

class Chapter extends StatelessWidget {
  final String chapterName;
  final int totalLessons;
  final int completedLessons;

  const Chapter({super.key,
    required this.chapterName,
    required this.totalLessons,
    required this.completedLessons,
  });

  @override
  Widget build(BuildContext context) {
    double progressValue = completedLessons / totalLessons;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        // Use Stack for layering
        alignment: Alignment.center, // Center overlays
        children: [
          LinearProgressIndicator(
            value: progressValue,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
            minHeight: 30, // Ensure a minimum height
            borderRadius: BorderRadius.circular(20.0),
          ),
          Positioned(
            // Position the chapter name
            child: Text(
              chapterName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Positioned(
            // Position the percentage
            right: 16, // Adjust the offset from the right
            child: Text(
              '${(progressValue * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
