import 'package:shared_preferences/shared_preferences.dart';

const String _isLoggedInKey = 'isLoggedIn';

Future<void> storeLoginData(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(_isLoggedInKey, isLoggedIn);
}

class LoginData {
  final bool isLoggedIn;

  LoginData(this.isLoggedIn);
}

Future<LoginData?> retrieveLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool(_isLoggedInKey);
  if (isLoggedIn == null) {
    return null; // Handle no data case
  }
  return LoginData(isLoggedIn);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(_isLoggedInKey);
}
