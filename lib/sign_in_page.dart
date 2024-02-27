import 'package:driving_license_exam_prep/shared_preferences/login_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart'; // Import your AuthService
import 'package:driving_license_exam_prep/User_pages/dashboard.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = "sign_in";

  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool isChecked = false;
  bool _showPassword = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Driving Academy",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Log In',
                            style: Theme.of(context).textTheme.displayMedium),
                        Text(
                          'Enter your log in details please',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        // Email field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Username is required' : null,
                          onSaved: (value) => _username = value!,
                        ),
                        const SizedBox(height: 16.0),
                        // Password field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: !_showPassword,
                          validator: (value) =>
                              value!.isEmpty ? 'Password is required' : null,
                          onSaved: (value) => _password = value!,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                        // Sign-in button
                        Align(
                          alignment: Alignment.center,
                          child: Visibility(
                            visible: !isLoading,
                            replacement: const CircularProgressIndicator(),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        // Show the circular progress indicator while signing in
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final signInResponse =
                                            await AuthService.signIn(
                                                _username, _password);

                                        if (signInResponse
                                                .containsKey('success') &&
                                            signInResponse['success'] == true) {
                                          // Successful sign-in
                                          storeLoginData(true);
                                          if (kDebugMode) {
                                            print('Sign-in successful');
                                          }
                                          // Navigate to the dashboard or handle accordingly
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Dashboard(),
                                            ),
                                          );
                                        } else {
                                          // Failed sign-in
                                          if (kDebugMode) {
                                            print(
                                                'Sign-in failed: ${signInResponse['error']}');
                                          }
                                          // Display the error message from the response
                                          // or handle accordingly
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(signInResponse[
                                                      'error'] ??
                                                  'An unknown error occurred.'),
                                            ),
                                          );
                                        }
                                        // Hide the circular progress indicator
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                              child: const Text('Log In'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  SignUpPage
                                      .id, // The route name for the sign-up page
                                );
                              },
                              child: const Text('Sign Up'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
