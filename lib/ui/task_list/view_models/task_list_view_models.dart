import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/utils/result.dart';

import '../../../data/models/task.dart';
import '../../../utils/command.dart';

class TaskListViewModel extends ChangeNotifier {
  final _log = Logger('$TaskListViewModel');

  final TaskRepository _taskRepository;
  final TaskType _taskType;

  late final Command0 load;
  late final Command1<void, Task> addTask;
  late final Command1<void, Task> deleteTask;
  late final Command2<void, Task, Future<void> Function()> updateTask;

  /// This private tasks list.
  List<Task> _tasks = [];

  /// A public getter for this view model tasks list.
  /// It makes the tasks list immutable.
  List<Task> get tasks => _tasks;

  TaskType get taskType => _taskType;

  TaskListViewModel(
      {required TaskRepository taskRepository, required TaskType taskType})
      : _taskRepository = taskRepository,
        _taskType = taskType {
    load = Command0(_load)..execute();
    addTask = Command1(_addTask);
    updateTask = Command2(_updateTask);
    deleteTask = Command1(_deleteTask);
  }

  Future<Result> _load() async {
    try {
      final result = await _taskRepository.getTasks(_taskType);
      switch (result) {
        case Ok<List<Task>>():
          _tasks = result.value;
          _log.fine('Loaded ${_taskType.name} tasks');
        case Error<List<Task>>():
          _log.warning('Failed to load ${_taskType.name} tasks', result.error);
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addTask(Task task) async {
    // Save the task.
    try {
      final saveResult = await _taskRepository.saveTask(task);
      switch (saveResult) {
        case Ok<void>():
          _log.fine('Task saved successfully');
        case Error<void>():
          _log.warning(
              'Failed to add task : ${task.toString()}', saveResult.error);
          return saveResult;
      }

      // After saving the task we need to reload the tasks list.
      // [TaskRepository] is the source of truth for existing tasks.
      final resultLoadTasks = await _taskRepository.getTasks(_taskType);
      switch (resultLoadTasks) {
        case Ok<List<Task>>():
          _log.fine('Loaded tasks');
          _tasks = resultLoadTasks.value;
        case Error<List<Task>>():
          _log.warning('Failed to load tasks', resultLoadTasks.error);
          return resultLoadTasks;
      }

      return resultLoadTasks;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _updateTask(
      Task task, Future<void> Function() onAfterSuccess) async {
    // Update the task.
    try {
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

      // After updating the task we need to reload the tasks list.
      // [TaskRepository] is the source of truth for existing tasks.
      final resultLoadTasks = await _taskRepository.getTasks(_taskType);
      switch (resultLoadTasks) {
        case Ok<List<Task>>():
          _log.fine('Loaded tasks');
          _tasks = resultLoadTasks.value;
        case Error<List<Task>>():
          _log.warning('Failed de load tasks', resultLoadTasks.error);
          return resultLoadTasks;
      }

      return resultLoadTasks;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteTask(Task task) async {
    try {
      //Delete the task.
      final resultDelete = await _taskRepository.deleteTask(task);
      switch (resultDelete) {
        case Ok<void>():
          _log.fine('Deleted task with id : ${task.id}');
        case Error<void>():
          _log.warning(
              'Failed to delete task with id : ${task.id}', resultDelete.error);
          return resultDelete;
      }

      //After deleting the task we need to reload the tasks list.
      //[TaskRepository] is the source of truth for existing tasks.
      final resultLoadTasks = await _taskRepository.getTasks(_taskType);
      switch (resultLoadTasks) {
        case Ok<List<Task>>():
          _log.fine('Loaded tasks');
          _tasks = resultLoadTasks.value;
        case Error<List<Task>>():
          _log.warning('Failed de load tasks', resultLoadTasks.error);
          return resultLoadTasks;
      }

      return resultLoadTasks;
    } finally {
      notifyListeners();
    }
  }
}
