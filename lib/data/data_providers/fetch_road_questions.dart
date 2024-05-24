import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question_model.dart';

Future<List<Question>> fetchRoadQuestions(String difficulty) async {
  final response = await http
      .get(Uri.parse('http://localhost:8888/fetch_road_questions.php?difficulty=$difficulty'));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse is List) {
      return jsonResponse.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  } else {
    throw Exception('Failed to load questions');
  }
}
