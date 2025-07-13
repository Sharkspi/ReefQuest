import 'package:reefquest/data/models/task.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/data/services/daily_task_service.dart';
import 'package:reefquest/data/services/task_service.dart';
import 'package:reefquest/utils/result.dart';

class LocalTasksRepository extends TaskRepository {
  final TaskService _taskService;
  final DailyTaskService _dailyTaskService;

  LocalTasksRepository(
      {required TaskService taskService,
      required DailyTaskService dailyTaskService})
      : _taskService = taskService,
        _dailyTaskService = dailyTaskService;

  //TODO Modify this and the daily task service to refactor and use TaskType instead of code duplication.

  @override
  Future<Result<Task?>> getDailyImportantTask() async {
    try {
      final taskIdResult = await _dailyTaskService.getImportantTaskOfDayId();
      switch (taskIdResult) {
        case Ok<int?>():
          if (taskIdResult.value != null) {
            return _taskService.getTaskFromId(taskIdResult.value!);
          } else {
            return Result.ok(null);
          }
        case Error<int?>():
          return Result.error(
              Exception('Error when getting daily important task'));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Task?>> getDailySelfCareTask() async {
    try {
      final taskIdResult = await _dailyTaskService.getSelfCareTaskOfDayId();
      switch (taskIdResult) {
        case Ok<int?>():
          if (taskIdResult.value != null) {
            return _taskService.getTaskFromId(taskIdResult.value!);
          } else {
            return Result.ok(null);
          }
        case Error<int?>():
          return Result.error(
              Exception('Error when getting daily self care task'));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<int?>> getImportantRoll() {
    return _dailyTaskService.getImportantRollCount();
  }

  @override
  Future<Result<int?>> getSelfCareRoll() {
    return _dailyTaskService.getSelfCareRollCount();
  }

  @override
  Future<Result<void>> saveDailyImportantTask(Task? task) {
    if (task != null) {
      return _dailyTaskService.saveImportantTaskOfDayId(task.id!);
    } else {
      return _dailyTaskService.saveImportantTaskOfDayId(-1);
    }
  }

  @override
  Future<Result<void>> saveDailySelfCareTask(Task? task) {
    if (task != null) {
      return _dailyTaskService.saveSelfCareTaskOfDayId(task.id!);
    } else {
      return _dailyTaskService.saveSelfCareTaskOfDayId(-1);
    }
  }

  @override
  Future<Result<void>> saveImportantRoll(int count) {
    return _dailyTaskService.saveImportantRollCount(count);
  }

  @override
  Future<Result<void>> saveSelfCareRoll(int count) {
    return _dailyTaskService.saveSelfCareRollCount(count);
  }

  @override
  Future<Result<DateTime?>> getLastRollResetDate() {
    return _dailyTaskService.getLastRollResetDate();
  }

  @override
  Future<Result<DateTime?>> getLastTaskResetDate() {
    return _dailyTaskService.getLastTaskResetDate();
  }

  @override
  Future<Result<void>> saveLastRollResetDate(DateTime date) {
    return _dailyTaskService.saveLastRollResetDate(date);
  }

  @override
  Future<Result<void>> saveLastTaskResetDate(DateTime date) {
    return _dailyTaskService.saveLastTaskResetDate(date);
  }

  // ************************************
  // NEW IMPLEMENTATIONS
  // ************************************

  @override
  Future<Result<List<Task>>> getTasks(TaskType type, {bool? done = false}) {
    return _taskService.getTasks(type, done: done);
  }

  @override
  Future<Result<void>> saveTask(Task task) {
    return _taskService.saveTask(task);
  }

  @override
  Future<Result<void>> updateTask(Task task) {
    return _taskService.updateTask(task);
  }

  @override
  Future<Result<void>> deleteTask(Task task) {
    return _taskService.deleteTask(task);
  }
}
