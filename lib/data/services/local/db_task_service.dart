import 'package:logging/logging.dart';
import 'package:reefquest/data/models/task.dart';
import 'package:reefquest/data/services/task_service.dart';
import 'package:reefquest/utils/result.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/app_database.dart';

class DbTaskService extends TaskService {
  final Logger _log = Logger('$DbTaskService');

  Future<Database> get _db async => await AppDatabase.db;

  DbTaskService();

  @override
  Future<Result<List<Task>>> getImportantTasks() async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      final result =
          await db.query(AppDatabase.tableImportantTask, where: 'done = 0');
      return Result.ok(result.map((e) => Task.fromMap(e)).toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<Task>>> getSelfCareTasks() async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      final result =
          await db.query(AppDatabase.tableSelfCareTask, where: 'done = 0');
      return Result.ok(result.map((e) => Task.fromMap(e)).toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Task?>> getTask(int id) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveImportantTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.insert(AppDatabase.tableImportantTask, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      _log.fine('Saved task in table ${AppDatabase.tableImportantTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to save task to table ${AppDatabase.tableImportantTask}', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveSelfCareTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.insert(AppDatabase.tableSelfCareTask, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      _log.fine('Saved task in table ${AppDatabase.tableSelfCareTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to save task to table ${AppDatabase.tableSelfCareTask}', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> updateImportantTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.update(
        AppDatabase.tableImportantTask,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      _log.fine(
          'Updated task with id : ${task.id} in table ${AppDatabase.tableImportantTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to update task with id : ${task.id} in table ${AppDatabase.tableImportantTask}',
          e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> updateSelfCareTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.update(
        AppDatabase.tableSelfCareTask,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      _log.fine(
          'Updated task with id : ${task.id} in table ${AppDatabase.tableSelfCareTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to update task with id : ${task.id} in table ${AppDatabase.tableSelfCareTask}',
          e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteImportantTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.delete(AppDatabase.tableImportantTask,
          where: 'id = ?', whereArgs: [task.id]);
      _log.fine(
          'Deleted task with id : ${task.id} in table ${AppDatabase.tableImportantTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to delete task with id : ${task.id} in table ${AppDatabase.tableImportantTask}',
          e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteSelfCareTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.delete(AppDatabase.tableSelfCareTask,
          where: 'id = ?', whereArgs: [task.id]);
      _log.fine(
          'Deleted task with id : ${task.id} in table ${AppDatabase.tableSelfCareTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to delete task with id : ${task.id} in table ${AppDatabase.tableSelfCareTask}',
          e);
      return Result.error(e);
    }
  }
}
