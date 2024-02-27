import 'package:flutter/material.dart';
import 'package:driving_license_exam_prep/sign_in_page.dart';
import 'package:driving_license_exam_prep/shared_preferences/login_data.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final bool _stretch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Add your content here
                Container(
                  height: 500,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                // Handle navigation to Dashboard
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Take Tests'),
              onTap: () {
                // Handle navigation to Take Tests
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Take Main Test'),
              onTap: () {
                // Handle navigation to Take Main Test
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Submit Feedback'),
              onTap: () {
                // Handle navigation to Submit Feedback
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle navigation to Settings
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                logout();
                // Navigate to the sign-in screen and remove all previous routes from the stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                      (route) => false, // Remove all previous routes from the stack
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
