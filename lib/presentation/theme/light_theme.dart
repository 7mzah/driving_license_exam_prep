import 'package:flutter/material.dart';

//primary color #C1E1C1
//secondary #EBECE0
//accent #7E8254
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 18),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
// Add more text styles as needed
  ),
);
