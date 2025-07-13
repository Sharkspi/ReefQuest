import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  //Private instance shared through the app
  static Database? _db;

  //Table names existing in the database
  static final String tableTask = 'task';

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    // WidgetsFlutterBinding.ensureInitialized();

    var databasePath = await getDatabasesPath();
    final path = join(databasePath, 'reefquest.db');

    // Make sure the directory exists
    try {
      await Directory(databasePath).create(recursive: true);
    } catch (_) {}

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableTask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT, 
            done INTEGER NOT NULL,
            taskType TEXT NOT NULL
          );
        ''');
      },
    );
  }
}
