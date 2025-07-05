import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  //Instance privée unique partagée dans l'application
  static Database? _db;

  //Noms des tables de l'application
  static final String tableImportantTask = 'important_task';
  static final String tableSelfCareTask = 'self_care_task';

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
          CREATE TABLE $tableImportantTask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT, 
            done INTEGER NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE $tableSelfCareTask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT, 
            done INTEGER NOT NULL
          );
        ''');
      },
    );
  }
}
