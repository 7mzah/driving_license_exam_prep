import 'package:flutter/material.dart';
import '../../../data/data_providers/auth_service.dart';
import '../../../data/repositories/login_data.dart';
import '../sign_in_page.dart';

class SettingsPage extends StatefulWidget {
  static const String id = 'settings_page';

  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await AuthService.signOut();
              logout();
              // Call your AuthService signOut method
              Navigator.pushReplacementNamed(context, SignInPage.id); // Navigate to sign in page after sign out
            },
          ),
        ],
      ),
    );
  }
}