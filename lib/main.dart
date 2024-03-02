import 'package:driving_license_exam_prep/presentation/theme/dark_theme.dart';
import 'package:driving_license_exam_prep/presentation/theme/light_theme.dart';
import 'package:driving_license_exam_prep/data/repositories/login_data.dart';
import 'package:driving_license_exam_prep/presentation/pages/sign_in_page.dart';
import 'package:driving_license_exam_prep/presentation/pages/sign_up_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/blocs/progressBar/progress_bloc.dart';
import 'presentation/pages/User_pages/roadMap.dart';

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
          ? BlocProvider<ProgressBloc>(
              create: (_) => ProgressBloc(), child: const Dashboard())
          // Navigate to dashboard if logged in
          : const SignInPage(), // Navigate to sign-in page if not logged in
      routes: {
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        Dashboard.id: (context) => const Dashboard(),
      },
    );
  }
}
