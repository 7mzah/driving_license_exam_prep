import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/examAnswer.dart';

class DatabaseHelper {
  static const _databaseName = "ExamDatabase.db";
  static const _databaseVersion = 3;

  static const examTable = 'exams';
  static const questionTable = 'questions';
  static const answerTable = 'answers';
  static const questionTableSim = 'simQuestions';
  static const answerTableSim = 'simAnswers';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    await _createExamTable(db);
    await _createQuestionTable(db);
    await _createAnswerTable(db);
    await _createSimAnswerTable(db);
    await _createSimQuestionTable(db);
  }

  Future<void> _createAnswerTable(Database db) async {
    await db.execute('''
          CREATE TABLE $answerTable (
            answerId INTEGER PRIMARY KEY,
            questionId INTEGER,
            userAnswer TEXT NOT NULL,
            correctAnswer TEXT NOT NULL,    
            FOREIGN KEY (questionId) REFERENCES $questionTable (questionId)
          )
          ''');
  }

  Future<void> _createSimAnswerTable(Database db) async {
    await db.execute('''
          CREATE TABLE $answerTableSim (
            answerId INTEGER PRIMARY KEY,
            questionId INTEGER,
            userAnswer TEXT NOT NULL,
            correctAnswer TEXT NOT NULL,    
            FOREIGN KEY (questionId) REFERENCES $questionTable (questionId)
          )
          ''');
  }

  Future<int> insertAnswer(
      int questionId, String userAnswer, String correctAnswer) async {
    Database db = await instance.database;
    try {
      return await db.insert(answerTable, {
        'questionId': questionId,
        'userAnswer': userAnswer,
        'correctAnswer': correctAnswer,
      });
    } catch (e) {
      print('Error inserting answer: $e');
      return -1;
    }
  }

  Future<int> insertSimAnswer(
      int questionId, String userAnswer, String correctAnswer) async {
    Database db = await instance.database;
    try {
      return await db.insert(answerTableSim, {
        'questionId': questionId,
        'userAnswer': userAnswer,
        'correctAnswer': correctAnswer,
      });
    } catch (e) {
      print('Error inserting answer: $e');
      return -1;
    }
  }

  Future<void> _createExamTable(Database db) async {
    await db.execute('''
          CREATE TABLE $examTable (
            examId INTEGER PRIMARY KEY,
            totalQuestions INTEGER NOT NULL,
            correctAnswers INTEGER NOT NULL
          )
          ''');
  }

  Future<void> _createQuestionTable(Database db) async {
    await db.execute('''
          CREATE TABLE $questionTable (
            questionId INTEGER PRIMARY KEY,
            examId INTEGER,
            questionText TEXT NOT NULL,
            questionImage BLOB,
            FOREIGN KEY (examId) REFERENCES $examTable (examId)
          )
          ''');
  }

  Future<void> _createSimQuestionTable(Database db) async {
    await db.execute('''
          CREATE TABLE $questionTableSim (
            questionId INTEGER PRIMARY KEY,
            examId INTEGER,
            questionText TEXT NOT NULL,
            questionImage BLOB,
            FOREIGN KEY (examId) REFERENCES $examTable (examId)
          )
          ''');
  }

  Future<int> insertExam(
      int totalQuestions, int correctAnswers, int examId) async {
    Database db = await instance.database;
    return await db.insert(examTable, {
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'examId': examId,
    });
  }

  Future<int> insertQuestion(int questionId, int examId, String questionText,
      String? questionImage) async {
    Database db = await instance.database;
    Uint8List? imageBytes;
    if (questionImage != null) {
      imageBytes = base64Decode(questionImage);
    }
    int result = await db.insert(questionTable, {
      'questionId': questionId,
      'examId': examId,
      'questionText': questionText,
      'questionImage': imageBytes,
    });

    return result;
  }

  Future<int> insertSimQuestion(int questionId, int examId, String questionText,
      String? questionImage) async {
    Database db = await instance.database;
    Uint8List? imageBytes;
    if (questionImage != null) {
      imageBytes = base64Decode(questionImage);
    }
    int result = await db.insert(questionTableSim, {
      'questionId': questionId,
      'examId': examId,
      'questionText': questionText,
      'questionImage': imageBytes,
    });

    return result;
  }

  Future<Map<String, dynamic>> getExamStats(int examId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query(examTable, where: 'examId = ?', whereArgs: [examId]);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> getExamQuestions(int examId) async {
    Database db = await instance.database;
    String query = '''
SELECT
  questions.questionId,
  questions.questionText,
  questions.questionImage,
  questions.examId
FROM questions
WHERE questions.examId = ?
''';

    List<Map<String, dynamic>> result = await db.rawQuery(query, [examId]);

    if (kDebugMode) {
      print('Fetched ${result.length} questions for examId: $examId');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getSimExamQuestions(int examId) async {
    Database db = await instance.database;
    String query = '''
SELECT
  simQuestions.questionId,
  simQuestions.questionText,
  simQuestions.questionImage,
  simQuestions.examId
FROM simQuestions
WHERE simQuestions.examId = ?
''';

    List<Map<String, dynamic>> result = await db.rawQuery(query, [examId]);

    if (kDebugMode) {
      print('Fetched ${result.length} questions for examId: $examId');
    }

    return result;
  }

  Future<List<ExamAnswer>> getExamAnswers(int questionId) async {
    Database db = await instance.database;
    String query = '''
SELECT answerId, userAnswer, correctAnswer
FROM $answerTable
WHERE questionId = ?
''';

    try {
      final List<Map<String, dynamic>> results =
          await db.rawQuery(query, [questionId]);
      if (results.isEmpty) {
        return []; // Handle case where no answers found
      }
      return results.map((result) => ExamAnswer.fromMap(result)).toList();
    } catch (e) {
      // Handle database errors here (e.g., print error message)
      return []; // Or throw a specific exception
    }
  }

  Future<List<ExamAnswer>> getSimExamAnswers(int questionId) async {
    Database db = await instance.database;
    String query = '''
SELECT answerId, userAnswer, correctAnswer
FROM $answerTableSim
WHERE questionId = ?
''';

    try {
      final List<Map<String, dynamic>> results =
          await db.rawQuery(query, [questionId]);
      if (results.isEmpty) {
        return []; // Handle case where no answers found
      }
      return results.map((result) => ExamAnswer.fromMap(result)).toList();
    } catch (e) {
      // Handle database errors here (e.g., print error message)
      return []; // Or throw a specific exception
    }
  }

  Future<void> deleteExamStats(int examId) async {
    final db = await database;
    await db.delete(
      examTable,
      where: 'examId = ?',
      whereArgs: [examId],
    );
  }

  //delete all the questions and answers for a given exam
  Future<void> deleteExamQuestionsAndAnswers(int examId) async {
    final db = await database;
    await db.delete(
      questionTable,
      where: 'examId = ?',
      whereArgs: [examId],
    );
    await db.delete(
      answerTable,
      where:
          'questionId IN (SELECT questionId FROM questions WHERE examId = ?)',
      whereArgs: [examId],
    );
  }

  Future<void> deleteSimExamQuestionsAndAnswers(int examId) async {
    final db = await database;
    await db.delete(
      questionTableSim,
      where: 'examId = ?',
      whereArgs: [examId],
    );
    await db.delete(
      answerTableSim,
      where:
          'questionId IN (SELECT questionId FROM $questionTableSim WHERE examId = ?)',
      whereArgs: [examId],
    );
  }
}
