import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exam_model.dart';

class RoadSignDataProvider{

  Future<List<Exam>> fetchExams() async {
    final response = await http.get(Uri.parse('http://localhost:8888/fetch_road_signs.php'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((data) => Exam.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load exams');
    }
  }
}