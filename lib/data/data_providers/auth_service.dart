import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String,dynamic>> signIn(String username, String password) async {
    final url = Uri.parse('http://localhost:8888/sign-in.php');
    final encodedData = jsonEncode({
      'username': username,
      'password': password,
    });
    try {
      final response = await http.post(
        url,
        body: encodedData,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Validate response data if needed
        if (responseData.containsKey('success') && responseData['success'] == true) {
          return responseData;
        } else {
          return {'error': 'Sign-in failed. Please check your credentials and try again.'};
        }
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      // Don't log password
      throw Exception('Sign-in error: $e');
    }
  }

  static Future<Map<String, dynamic>> signUp(
    String username,
    String email,
    String password,
  ) async {
    // Error handling for input validation

    // Use HTTPS for secure communication
    final url = Uri.parse('http://localhost:8888/sign-up.php');

    // Encode data securely (consider using a crypto package if necessary)
    final encodedData = jsonEncode({
      'username': username,
      'email': email,
      'password': password, // Avoid sending plain text passwords
    });

    // Use a try-catch block for robust error handling
    try {
      final response = await http.post(
        url,
        body: encodedData,
        headers: {
          'Content-Type': 'application/json'
        }, // Set content type header
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during sign-up: $error');
    }
  }
}
