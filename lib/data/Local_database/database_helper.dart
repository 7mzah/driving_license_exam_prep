import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "ExamDatabase.db";
  static const _databaseVersion = 1;

  static const examTable = 'exams';
  static const questionTable = 'questions';

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
            correctAnswer TEXT NOT NULL,
            userAnswer TEXT,
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

  Future<int> insertQuestion(int examId, String questionText,
      String correctAnswer, String userAnswer) async {
    Database db = await instance.database;
    return await db.insert(questionTable, {
      'examId': examId,
      'questionText': questionText,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
    });
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
    return await db
        .query(questionTable, where: 'examId = ?', whereArgs: [examId]);
  }

  Future<void> deleteExamStats(int examId) async {
    final db = await database;
    await db.delete(
      examTable,
      where: 'examId = ?',
      whereArgs: [examId],
    );
  }
}
