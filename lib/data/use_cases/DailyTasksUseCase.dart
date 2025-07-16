import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/utils/date_time_extension.dart';

import '../../utils/result.dart';
import '../models/task.dart';

class DailyTasksUseCase {
  final Logger _log = Logger('$DailyTasksUseCase');
  final TaskRepository _taskRepository;
  final int _maxRollCount = 3;

  DailyTasksUseCase({required TaskRepository taskRepository})
      : _taskRepository = taskRepository;

  Future<Result<void>> _updateIfNecessary() async {
    _log.fine('Now : ${DateTime.now()}');
    final rollUpdateResult = await _updateRollsIfNecessary();
    switch (rollUpdateResult) {
      case Error<void>():
        _log.warning('Failed to reset rolls', rollUpdateResult.error);
        return rollUpdateResult;
      case Ok<void>():
    }

    final taskUpdateResult = await _updateDailyTasksIfNecessary();
    switch (taskUpdateResult) {
      case Error<void>():
        _log.warning('Failed to reset daily tasks', taskUpdateResult.error);
        return taskUpdateResult;
      case Ok<void>():
    }
    return Result.ok(null);
  }

  Future<Result<void>> _updateRollsIfNecessary() async {
    // Retrieve last roll reset date.
    final lastRollResetDateResult =
        await _taskRepository.getLastRollResetDate();
    switch (lastRollResetDateResult) {
      case Error<DateTime?>():
        _log.warning('Failed to load last roll reset date',
            lastRollResetDateResult.error);
        return lastRollResetDateResult;
      case Ok<DateTime?>():
    }

    // Check on last reset date to see if update is necessary.
    bool needToReset = false;
    if (lastRollResetDateResult.value == null) {
      // Last reset date not existing so we need to do a first reset to set it.
      _log.fine('Last roll reset date not set');
      needToReset = true;
    } else {
      // Last reset date is set, we need to check it to see if an update is necessary.
      final lastRollResetDate = lastRollResetDateResult.value;
      _log.fine('Last roll reset date $lastRollResetDate');
      // Rolls are reset on monday at midnight
      final nextMondayMidnight =
          DateUtils.dateOnly(lastRollResetDate!.next(DateTime.monday));
      // Need to compare to the current call date.
      final currentDate = DateTime.now();
      // When the check date is after the needed reset date we need to update the rolls.
      if (currentDate.isAfter(nextMondayMidnight)) {
        needToReset = true;
      }
    }

    if (needToReset) {
      _log.fine('Need to reset rolls');
      final rollResetResult = await _resetRolls();
      switch (rollResetResult) {
        case Error<void>():
          _log.warning('Failed to reset rolls', rollResetResult.error);
          return rollResetResult;
        case Ok<void>():
          _log.fine('Roll reset done');
      }
    }

    return Result.ok(null);
  }

  Future<Result<void>> _updateDailyTasksIfNecessary() async {
    final lastTaskResetDateResult =
        await _taskRepository.getLastTaskResetDate();
    switch (lastTaskResetDateResult) {
      case Error<DateTime?>():
        _log.warning('Failed to load last task reset date',
            lastTaskResetDateResult.error);
        return lastTaskResetDateResult;
      case Ok<DateTime?>():
    }
    bool needToResetTasks = false;
    if (lastTaskResetDateResult.value == null) {
      _log.fine('Last task reset date not set');
      needToResetTasks = true;
    } else {
      final lastTasksResetDate = lastTaskResetDateResult.value;
      _log.fine('Last task reset date $lastTasksResetDate');
      if (!DateUtils.isSameDay(lastTasksResetDate, DateTime.now())) {
        needToResetTasks = true;
      }
    }

    if (needToResetTasks) {
      _log.info('Need to reset tasks');
      final resetTasksResult = await _resetTasks();
      switch (resetTasksResult) {
        case Error<void>():
          _log.warning('Failed to reset daily tasks', resetTasksResult.error);
          return Result.error(resetTasksResult.error);
        case Ok<void>():
          _log.fine('Daily task reset done');
      }
    }

    return Result.ok(null);
  }

  Future<Result<void>> _resetRolls() async {
    for (TaskType taskType in TaskType.values) {
      final rollSaveResult =
          await _taskRepository.saveRoll(taskType, _maxRollCount);
      switch (rollSaveResult) {
        case Error<void>():
          _log.warning('Failed to save ${taskType.name} roll count',
              rollSaveResult.error);
          return rollSaveResult;
        case Ok<void>():
      }
    }

    final rollResetDateSaveResult =
        await _taskRepository.saveLastRollResetDate(DateTime.now());
    switch (rollResetDateSaveResult) {
      case Error<void>():
        _log.warning(
            'Failed to save roll reset date', rollResetDateSaveResult.error);
        return rollResetDateSaveResult;
      case Ok<void>():
    }
    _log.fine('Rolls reset done');
    return Result.ok(null);
  }

  Future<Result<void>> _resetTasks() async {
    for (TaskType taskType in TaskType.values) {
      // Get all available tasks by type to be set as the new daily task.
      final taskListResult = await _taskRepository.getTasks(taskType);
      switch (taskListResult) {
        case Error<List<Task>>():
          _log.warning(
              'Failed to get ${taskType.name} tasks', taskListResult.error);
          return taskListResult;
        case Ok<List<Task>>():
      }
      List<Task> tasks = taskListResult.value;
      Task? taskToSave;
      // No task available.
      if (tasks.isEmpty) {
        taskToSave = null;
      } else if (tasks.length == 1) {
        // Only one task available.
        taskToSave = tasks[0];
      } else {
        //Multiple tasks available, we need to remove the current task from the available list and pick a new random one.
        final currentTaskResult = await _taskRepository.getDailyTask(taskType);
        switch (currentTaskResult) {
          case Error<Task?>():
            _log.warning('Failed to get current daily ${taskType.name} task',
                currentTaskResult.error);
            return currentTaskResult;
          case Ok<Task?>():
        }
        if (currentTaskResult.value != null) {
          tasks.removeWhere((task) => task.id == currentTaskResult.value!.id);
        }
        taskToSave = tasks[Random().nextInt(tasks.length)];
      }
      final dailyTaskSaveResult =
          await _taskRepository.saveDailyTask(taskToSave, taskType);
      switch (dailyTaskSaveResult) {
        case Error<void>():
          _log.warning('Failed to save daily ${taskType.name} task',
              dailyTaskSaveResult.error);
        case Ok<void>():
      }
    }

    // Save task reset date to current date.
    final saveTaskResetDate =
        await _taskRepository.saveLastTaskResetDate(DateTime.now());
    switch (saveTaskResetDate) {
      case Error<void>():
        _log.warning(
            'Failed to save daily tasks reset date', saveTaskResetDate.error);
        return saveTaskResetDate;
      case Ok<void>():
    }

    _log.fine('Daily tasks reset done');
    return Result.ok(null);
  }

  Future<Result<Task?>> getDailyTask(TaskType type) async {
    await _updateIfNecessary();
    return _taskRepository.getDailyTask(type);
  }

  Future<Result<int>> getTaskRollCount(TaskType type) async {
    await _updateIfNecessary();
    return _taskRepository.getRoll(type);
  }

  Future<Result<Task?>> getNewDailyTask(TaskType taskType) async {
    //  Get roll count
    //  If roll count > 0
    //      roll count --
    //      Get current task
    //      Get tasks
    //      Remove current task from tasks
    //      Get new random important task from tasks list
    //  Else throw Exception not enough rolls
    // Get all available tasks by type to be set as the new daily task.
    final taskListResult = await _taskRepository.getTasks(taskType);
    switch (taskListResult) {
      case Error<List<Task>>():
        _log.warning(
            'Failed to get ${taskType.name} tasks', taskListResult.error);
        return Result.error(taskListResult.error);
      case Ok<List<Task>>():
    }
    List<Task> tasks = taskListResult.value;
    Task? taskToSave;
    // No task available.
    if (tasks.isEmpty) {
      taskToSave = null;
    } else if (tasks.length == 1) {
      // Only one task available.
      taskToSave = tasks[0];
    } else {
      //Multiple tasks available, we need to remove the current task from the available list and pick a new random one.
      final currentTaskResult = await _taskRepository.getDailyTask(taskType);
      switch (currentTaskResult) {
        case Error<Task?>():
          _log.warning('Failed to get current daily ${taskType.name} task',
              currentTaskResult.error);
          return currentTaskResult;
        case Ok<Task?>():
      }
      if (currentTaskResult.value != null) {
        tasks.removeWhere((task) => task.id == currentTaskResult.value!.id);
      }
      taskToSave = tasks[Random().nextInt(tasks.length)];
    }
    final dailyTaskSaveResult =
        await _taskRepository.saveDailyTask(taskToSave, taskType);
    switch (dailyTaskSaveResult) {
      case Error<void>():
        _log.warning('Failed to save daily ${taskType.name} task',
            dailyTaskSaveResult.error);
      case Ok<void>():
    }
    return _taskRepository.getDailyTask(taskType);
  }
}
