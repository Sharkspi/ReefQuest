import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/utils/result.dart';

import '../../../data/models/task.dart';
import '../../../utils/command.dart';

abstract class TaskListViewModel extends ChangeNotifier {
  final _log = Logger('$TaskListViewModel');

  final TaskRepository _taskRepository;

  late final Command0 load;
  late final Command1<void, Task> addTask;
  late final Command1<void, Task> deleteTask;
  late final Command2<void, Task, Future<void> Function()> updateTask;

  /// This private tasks list.
  List<Task> _tasks = [];

  /// A public getter for this view model tasks list.
  /// It makes the tasks list immutable.
  List<Task> get tasks => _tasks;

  //TODO revoir l'implémentation de ces méthodes avec des switch case

  TaskListViewModel({required TaskRepository taskRepository})
      : _taskRepository = taskRepository {
    load = Command0(_load)..execute();
    addTask = Command1(_addTask);
    updateTask = Command2(_updateTask);
    deleteTask = Command1(_deleteTask);
  }

  Future<Result> _load() async {
    try {
      final result = await _getTasksFromRepo();
      switch (result) {
        case Ok<List<Task>>():
          _tasks = result.value;
          _log.fine('Loaded tasks');
        case Error<List<Task>>():
          _log.warning('Failed to load tasks', result.error);
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
      final saveResult = await _saveTaskToRepo(task);
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
      final resultLoadTasks = await _getTasksFromRepo();
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

  Future<Result<void>> _updateTask(
      Task task, Future<void> Function() onAfterSuccess) async {
    // Update the task.
    try {
      final updateResult = await _updateTaskToRepo(task);
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
      final resultLoadTasks = await _getTasksFromRepo();
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
      final resultDelete = await _deleteTaskFromRepo(task);
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
      final resultLoadTasks = await _getTasksFromRepo();
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

  // Méthodes à implémenter par les sous-classes.
  Future<Result<List<Task>>> _getTasksFromRepo();

  Future<Result<void>> _saveTaskToRepo(Task task);

  Future<Result<void>> _updateTaskToRepo(Task task);

  Future<Result<void>> _deleteTaskFromRepo(Task task);
}

class ImportantTaskListViewModel extends TaskListViewModel {
  ImportantTaskListViewModel({required super.taskRepository});

  @override
  Future<Result<List<Task>>> _getTasksFromRepo() {
    return _taskRepository.getImportantTasks();
  }

  @override
  Future<Result<void>> _saveTaskToRepo(Task task) {
    return _taskRepository.saveImportantTask(task);
  }

  @override
  Future<Result<void>> _updateTaskToRepo(Task task) {
    return _taskRepository.updateImportantTask(task);
  }

  @override
  Future<Result<void>> _deleteTaskFromRepo(Task task) {
    return _taskRepository.deleteImportantTask(task);
  }
}

class SelfCareTaskListViewModel extends TaskListViewModel {
  SelfCareTaskListViewModel({required super.taskRepository});

  @override
  Future<Result<List<Task>>> _getTasksFromRepo() {
    return _taskRepository.getSelfCareTasks();
  }

  @override
  Future<Result<void>> _saveTaskToRepo(Task task) {
    return _taskRepository.saveSelfCareTask(task);
  }

  @override
  Future<Result<void>> _updateTaskToRepo(Task task) {
    return _taskRepository.updateSelfCareTask(task);
  }

  @override
  Future<Result<void>> _deleteTaskFromRepo(Task task) {
    return _taskRepository.deleteSelfCareTask(task);
  }
}
