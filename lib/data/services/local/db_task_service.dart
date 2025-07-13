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
  Future<Result<List<Task>>> getTasks(TaskType type, {bool? done}) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      final List<Map<String, Object?>> result;
      if (done != null) {
        result = await db.rawQuery(
            'SELECT * from ${AppDatabase.tableTask} WHERE taskType = ? AND done = ?',
            [type.name, done ? 1 : 0]);
      } else {
        result = await db.query(AppDatabase.tableTask,
            where: 'taskType = ?', whereArgs: [type.name]);
      }
      return Result.ok(result.map((e) => Task.fromMap(e)).toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Task?>> getTaskFromId(int id) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      final result = await db
          .query(AppDatabase.tableTask, where: 'id = ?', whereArgs: [id]);
      List<Task> taskList =
          result.isNotEmpty ? result.map((c) => Task.fromMap(c)).toList() : [];
      if (taskList.length > 1) {
        return Result.error(Exception(
            'Many tasks with the same id in ${AppDatabase.tableTask} table'));
      } else if (taskList.isEmpty) {
        return Result.ok(null);
      }
      return Result.ok(taskList[0]);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.insert(AppDatabase.tableTask, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      _log.fine('Saved task in table ${AppDatabase.tableTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save task to table ${AppDatabase.tableTask}', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db.update(
        AppDatabase.tableTask,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      _log.fine(
          'Updated task with id : ${task.id} in table ${AppDatabase.tableTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to update task with id : ${task.id} in table ${AppDatabase.tableTask}',
          e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteTask(Task task) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      final db = await _db;
      await db
          .delete(AppDatabase.tableTask, where: 'id = ?', whereArgs: [task.id]);
      _log.fine(
          'Deleted task with id : ${task.id} in table ${AppDatabase.tableTask}');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning(
          'Failed to delete task with id : ${task.id} in table ${AppDatabase.tableTask}',
          e);
      return Result.error(e);
    }
  }
}
