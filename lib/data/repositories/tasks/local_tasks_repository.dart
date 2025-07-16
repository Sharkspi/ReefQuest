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

  @override
  Future<Result<List<Task>>> getTasks(TaskType type, {bool? done = false}) {
    return _taskService.getTasks(type, done: done);
  }

  @override
  Future<Result<void>> saveTask(Task task) {
    return _taskService.saveTask(task);
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    final dailyTaskIdResult =
        await _dailyTaskService.getTaskOfDayId(task.taskType);
    switch (dailyTaskIdResult) {
      case Error<int?>():
        return dailyTaskIdResult;
      case Ok<int?>():
    }
    if (dailyTaskIdResult.value != null && dailyTaskIdResult.value == task.id && task.done == true) {
      _dailyTaskService.saveTaskOfDayId(task.taskType, null);
    }
    return _taskService.updateTask(task);
  }

  @override
  Future<Result<void>> deleteTask(Task task) {
    return _taskService.deleteTask(task);
  }

  @override
  Future<Result<Task?>> getDailyTask(TaskType type) async {
    try {
      final taskIdResult = await _dailyTaskService.getTaskOfDayId(type);
      switch (taskIdResult) {
        case Ok<int?>():
          print('Daily ${type.name} task id : ${taskIdResult.value}');
          if (taskIdResult.value != null) {
            return _taskService.getTaskFromId(taskIdResult.value!);
          } else {
            return Result.ok(null);
          }
        case Error<int?>():
          return Result.error(
              Exception('Error when getting daily ${type.name} task'));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveDailyTask(Task? task, TaskType type) {
    if (task != null) {
      return _dailyTaskService.saveTaskOfDayId(task.taskType, task.id!);
    } else {
      return _dailyTaskService.saveTaskOfDayId(type, null);
    }
  }

  @override
  Future<Result<int>> getRoll(TaskType type) async {
    final rollCountResult = await _dailyTaskService.getRollCount(type);
    switch (rollCountResult) {
      case Error<int?>():
        return Result.error(rollCountResult.error);
      case Ok<int?>():
        if (rollCountResult.value != null) {
          return Result.ok(rollCountResult.value!);
        } else {
          throw Exception('Roll count not set');
        }
    }
  }

  @override
  Future<Result<void>> saveRoll(TaskType type, int count) {
    return _dailyTaskService.saveRollCount(type, count);
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
}
