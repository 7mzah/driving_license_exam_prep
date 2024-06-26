import 'package:driving_license_exam_prep/business_logic/providers/difficulty_level_provider.dart';
import 'package:driving_license_exam_prep/presentation/pages/User_pages/practiceTests.dart';
import 'package:driving_license_exam_prep/presentation/theme/dark_theme.dart';
import 'package:driving_license_exam_prep/presentation/theme/light_theme.dart';
import 'package:driving_license_exam_prep/data/repositories/login_data.dart';
import 'package:driving_license_exam_prep/presentation/pages/sign_in_page.dart';
import 'package:driving_license_exam_prep/presentation/pages/sign_up_page.dart';
import 'package:driving_license_exam_prep/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/blocs/progressBar/progress_bloc.dart';
import 'business_logic/cubits/exam_cubit.dart';
import 'presentation/pages/navigation.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProgressBloc>(
          create: (_) => ProgressBloc(),
        ),
        BlocProvider<ExamCubit>(
          create: (_) => ExamCubit(),
        ),
        ChangeNotifierProvider(create: (context) => DifficultyLevelNotifier()),
      ],
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        home: SplashScreen(loginData: loginData), // Set SplashScreen as the home
        routes: {
          SignInPage.id: (context) => const SignInPage(),
          SignUpPage.id: (context) => const SignUpPage(),
          Dashboard.id: (context) => const Dashboard(),
          PracticeTestPage.id: (context) => const PracticeTestPage(),
        },
      ),
    );
  }
}