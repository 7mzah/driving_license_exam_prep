import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PracticeMode extends StatelessWidget {
  const PracticeMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 16.0,right: 24),
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Practice Mode',style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: const Text('Incorrect Answers'),
                      onTap: () {
                        // Navigate to the practice mode page
                        if (kDebugMode) {
                          print('Practice Mode 1 pressed');
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: ListTile(
                      title: const Text('Saved Questions'),
                      onTap: () {
                        // Navigate to the practice mode page
                        if (kDebugMode) {
                          print('Practice Mode 2 pressed');
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
