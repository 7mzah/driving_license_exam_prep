import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DifficultyLevelNotifier with ChangeNotifier {
  String _difficultyLevel = '';
  String _lastDifficultyLevel = '';

  String get difficultyLevel => _difficultyLevel;
  String get lastDifficultyLevel => _lastDifficultyLevel;

  void updateDifficultyLevel(String newDifficultyLevel) async {
    _lastDifficultyLevel = _difficultyLevel;
    _difficultyLevel = newDifficultyLevel;
    print('Updated difficultyLevel: $_difficultyLevel');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficultyLevel', _difficultyLevel);
    notifyListeners();
  }
}