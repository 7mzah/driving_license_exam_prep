import 'package:flutter/material.dart';

class LessonWidget extends StatefulWidget {
  final int lessonNumber;
  final String lessonTitle;
  final bool isCompleted;
  final bool isAccessible;

  // Add a flag to indicate completion

  const LessonWidget({
    super.key,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.isAccessible,
    this.isCompleted = false, // Default to not completed
  });

  @override
  State<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isAccessible && !widget.isCompleted) {
      _glowController =
          AnimationController(vsync: this, duration: const Duration(seconds: 1));
      _glowAnimation = Tween(begin: 0.0, end: 1.0).animate(_glowController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _glowController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _glowController.forward();
          }
        });
      _glowController.repeat();
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle updates to isAccessible and isCompleted (add logic to start/stop glow)
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

          Container(
            width: 48, // Adjust size as needed
            height: 48,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isCompleted
                    ? Theme.of(context)
                        .colorScheme
                        .primaryContainer // Color based on completion
                    : Theme.of(context).colorScheme.secondaryContainer),
            child: Center(
              child: Text(
                widget.lessonNumber.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.isCompleted
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                    ),
              ),
            ),
          ),
        Text(
          widget.lessonTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.isCompleted
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ],
    );
  }
}
