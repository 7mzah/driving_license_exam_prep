import 'package:driving_license_exam_prep/presentation/pages/User_pages/practiceTests.dart';
import 'package:flutter/material.dart';

import 'User_pages/roadMap.dart';
import 'User_pages/settings.dart';

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";

  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;

  final List<Widget> _pages = const <Widget>[
    RoadMap(),
    PracticeTestPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) =>
            setState(() => currentPageIndex = index),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.fact_check),
            icon: Icon(Icons.fact_check_outlined),
            label: 'Practice Test',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
    );
  }
}