import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:reefquest/utils/result.dart';

import '../../../data/models/task.dart';
import '../../../data/repositories/tasks/tasks_repository.dart';
import '../../../data/use_cases/DailyTasksUseCase.dart';
import '../../../utils/command.dart';

class DailyTasksViewModel extends ChangeNotifier {
  final _log = Logger('$DailyTasksViewModel');

  final DailyTasksUseCase _dailyTasksUseCase;
  final TaskRepository _taskRepository;

  Map<TaskType, Task?> _taskMap = {};
  Map<TaskType, int> _rollMap = {};
  late int? _importantRollCount;

  late int? _selfCareRollCount;

  Map<TaskType, Task?> get taskMap => _taskMap;

  Map<TaskType, int> get rollMap => _rollMap;

  int? get importantRollCount => _importantRollCount;

  int? get selfCareRollCount => _selfCareRollCount;

  late final Command0 load;
  late final Command2<void, Task, Future<void> Function()> updateTask;

  DailyTasksViewModel(
      {required DailyTasksUseCase dailyTasksUseCase,
      required TaskRepository taskRepository})
      : _dailyTasksUseCase = dailyTasksUseCase,
        _taskRepository = taskRepository {
    load = Command0(_load)..execute();
    updateTask = Command2(_updateTask);
  }

  Future<Result> _load() async {
    try {
      for (TaskType taskType in TaskType.values) {
        final taskResult = await _dailyTasksUseCase.getDailyTask(taskType);
        switch (taskResult) {
          case Error<Task?>():
            _log.warning(
                'Failed to load ${taskType.name} daily task', taskResult.error);
            return taskResult;
          case Ok<Task?>():
        }

        _taskMap[taskType] = taskResult.value;

        final rollResult = await _dailyTasksUseCase.getTaskRollCount(taskType);
        switch (rollResult) {
          case Error<int>():
            _log.warning(
                'Failed to load ${taskType.name} roll count', rollResult.error);
            return taskResult;
          case Ok<int>():
        }

        _rollMap[taskType] = rollResult.value;
      }
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _updateTask(
      Task task, Future<void> Function() onAfterSuccess) async {
    // Update the task.
    try {
      final taskType = task.taskType;
      final updateResult = await _taskRepository.updateTask(task);
      switch (updateResult) {
        case Ok<void>():
          _log.fine('Task updated successfully');
        case Error<void>():
          _log.warning(
              'Failed to update task : ${task.toString()}', updateResult.error);
          return updateResult;
      }

      //Executes the method to call after success.
      await onAfterSuccess();

      final taskResult = await _dailyTasksUseCase.getDailyTask(taskType);
      switch (taskResult) {
        case Error<Task?>():
          _log.warning(
              'Failed to load ${taskType.name} daily task', taskResult.error);
          return taskResult;
        case Ok<Task?>():
      }

      _taskMap[taskType] = taskResult.value;

      final rollResult = await _dailyTasksUseCase.getTaskRollCount(taskType);
      switch (rollResult) {
        case Error<int>():
          _log.warning(
              'Failed to load ${taskType.name} roll count', rollResult.error);
          return taskResult;
        case Ok<int>():
      }

      _rollMap[taskType] = rollResult.value;
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> getNewTask(TaskType taskType) async {
    try {
      final taskResult = await _dailyTasksUseCase.getNewDailyTask(taskType);
      switch (taskResult) {
        case Error<Task?>():
          return taskResult;
        case Ok<Task?>():
      }
      _taskMap[taskType] = taskResult.value;
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }
}
