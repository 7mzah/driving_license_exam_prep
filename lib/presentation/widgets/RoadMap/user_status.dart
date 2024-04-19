import 'package:flutter/material.dart';

class UserStatus extends StatelessWidget {
  const UserStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              'Level',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '1',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        SizedBox(
          height: 32,
          child: VerticalDivider(
            color: Theme.of(context).colorScheme.onBackground,
            thickness: 1,
          ),
        ),
        Column(
          children: [
            Text(
              'Points',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '20',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        SizedBox(
          height: 32,
          child: VerticalDivider(
            color: Theme.of(context).colorScheme.onBackground,
            thickness: 1,
          ),
        ),
        Column(
          children: [
            Text(
              'Lessons',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '5',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }
}
