import 'package:driving_license_exam_prep/shared_preferences/login_data.dart';
import 'package:driving_license_exam_prep/sign_in_page.dart';
import 'package:driving_license_exam_prep/sign_up_page.dart';
import 'package:driving_license_exam_prep/theme/dark_theme.dart';
import 'package:driving_license_exam_prep/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'User_pages/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization
  final loginData = await retrieveLoginData();
  runApp(MyApp(loginData: loginData)); // Pass loginData to MyApp
}

class MyApp extends StatelessWidget {
  final LoginData? loginData;

  const MyApp({super.key, this.loginData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: loginData?.isLoggedIn == true
          ? const Dashboard() // Navigate to dashboard if logged in
          : const SignInPage(), // Navigate to sign-in page if not logged in
      routes: {
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        Dashboard.id: (context) => const Dashboard(),
      },
    );
  }
}
