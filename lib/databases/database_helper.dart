import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      Database db = await database;
      return await db.insert('users', user);
    } catch (e) {
      // Handle error
      return Future.error('Error inserting user: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      // Handle error
      return Future.error('Error fetching user by email: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      // Handle error
      return Future.error('Error fetching user by username: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      Database db = await database;
      return await db.query('users');
    } catch (e) {
      // Handle error
      return Future.error('Error fetching all users: $e');
    }
  }

  Future<void> close() async {
    try {
      Database db = await database;
      await db.close();
    } catch (e) {
      // Handle error
      return Future.error('Error closing database: $e');
    }
  }
}
