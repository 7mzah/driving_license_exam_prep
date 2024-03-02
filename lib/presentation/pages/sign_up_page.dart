import 'package:flutter/material.dart';
import '../../data/data_providers/auth_service.dart';
import 'User_pages/roadMap.dart';
import 'sign_in_page.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "sign_up";

  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool signUpSuccess = false;
  String _errorMessage = "";

  bool isLoading = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                      children: [
                        Text('Sign Up',
                            style: Theme.of(context).textTheme.displayMedium),
                        Text(
                          'Get started with an account.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 48,
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Username';
                            }
                            return null; // Return null if the confirm password is valid
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Enter a valid email';
                            }

                            return null; // Return null if the confirm password is valid
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            final passwordRegExp = RegExp(
                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
                            if (!passwordRegExp.hasMatch(value)) {
                              return 'Your password needs:\n1 uppercase letter,\n1 lowercase letter,\n1 number,\n1 special character.';
                            }
                            return null;
                            // Return null if the confirm password is valid
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null; // Return null if the confirm password is valid
                          },
                        ),

                        const SizedBox(
                          height: 32,
                        ),
                        // Sign-up button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              final username = _usernameController.text;
                              final email = _emailController.text;
                              final password = _passwordController.text;

                              setState(() {
                                // Disable button during sign-up process
                                isLoading = true;
                              });

                              try {
                                // Proceed with AuthService call if email validation passed
                                final signUpResponse = await AuthService.signUp(
                                    username, email, password);
                                signUpSuccess = signUpResponse['success'];
                                _errorMessage = signUpResponse['error'] ?? '';
                              } catch (error) {
                                _errorMessage = _errorMessage.isEmpty
                                    ? 'Failed to sign up: $error'
                                    : _errorMessage;
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }

                              if (signUpSuccess) {
                                await Future.delayed(const Duration(
                                    seconds: 1)); // Delay for visual effect
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Account created successfully!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                    context, Dashboard.id);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_errorMessage),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Create Account'),
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  SignInPage.id,
                                );
                              },
                              child: const Text('Log In'),
                            ),
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
