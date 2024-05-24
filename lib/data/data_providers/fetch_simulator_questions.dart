import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/question_model.dart';

Future<List<Question>> fetchSimQuestions() async {
  try {
    final response = await http
        .get(Uri.parse('http://localhost:8888/fetch_sim_questions.php'));
    if (kDebugMode) {
      print('Server response: ${response.body}');
    }
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse is List) {
        return jsonResponse.map((json) => Question.fromJson(json)).toList();
      } else {
        print('Error: Server response is not a list. Actual response: $jsonResponse');
        throw Exception('Failed to load questions');
      }
    } else {
      print('Error: Server response status code is not 200');
      throw Exception('Failed to load questions');
    }
  } catch (e) {
    print('Error fetching questions: $e');
    throw Exception('Failed to load questions');
  }
}