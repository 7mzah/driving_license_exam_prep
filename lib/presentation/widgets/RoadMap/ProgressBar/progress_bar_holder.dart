import 'package:flutter/material.dart';

class ProgressBarHolder extends StatelessWidget {
  const ProgressBarHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // Use LayoutBuilder for dynamic sizing
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Progress bar as the background layer
            Center(
              child: Container(
                // Mimics the background bar
                //set your desired width to fill 80% of the screen
                width: MediaQuery.of(context).size.width * 0.85,

                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer, // Same color
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            // Positioned Icon Dynamic following the progress
            Positioned(
              left: 40,
              top: -20,
              child: Icon(
                Icons.car_crash_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}
