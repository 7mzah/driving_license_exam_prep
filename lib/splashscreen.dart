import 'package:driving_license_exam_prep/presentation/pages/navigation.dart';
import 'package:driving_license_exam_prep/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

import 'data/repositories/login_data.dart';

class SplashScreen extends StatefulWidget {
  final LoginData? loginData;

  const SplashScreen({super.key, this.loginData});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (widget.loginData?.isLoggedIn == true) {
        Navigator.pushReplacementNamed(context, Dashboard.id);
      } else {
        Navigator.pushReplacementNamed(context, SignInPage.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}