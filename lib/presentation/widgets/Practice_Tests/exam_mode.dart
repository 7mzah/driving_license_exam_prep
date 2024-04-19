import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExamMode extends StatelessWidget {
  const ExamMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Exam Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: const Text('Exam Simulator'),
                      onTap: () {
                        // Navigate to the practice mode page
                        if (kDebugMode) {
                          print('Practice Mode 1 pressed');
                        }
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
