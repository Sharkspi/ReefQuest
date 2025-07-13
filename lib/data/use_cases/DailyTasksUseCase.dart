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

  //TODO la tâche se met à jour si elle est null même si la date indique qu'il ne faut pas la mettre à jour
  Future<Result<void>> _updateIfNecessary() async {
    //Reset rolls if necessary
    final lastRollResetDateResult =
        await _taskRepository.getLastRollResetDate();
    switch (lastRollResetDateResult) {
      case Error<DateTime?>():
        _log.warning('Failed to load last roll reset date',
            lastRollResetDateResult.error);
        return Result.error(lastRollResetDateResult.error);
      case Ok<DateTime?>():
    }
    bool needToResetRoll = false;
    if (lastRollResetDateResult.value == null) {
      //No value for the roll reset date so we save rolls with max count and save the date
      _log.fine('Last roll date not set');
      needToResetRoll = true;
    } else {
      //We check for last update date, if later than next sunday from last date then we reset the rolls
      final lastRollResetDate = lastRollResetDateResult.value;
      final nextSundayFromLastUpdate = lastRollResetDate!.next(DateTime.sunday);
      final todayDate = DateTime.now();
      if (todayDate.isAfter(DateUtils.dateOnly(nextSundayFromLastUpdate))) {
        needToResetRoll = true;
      }
    }
    if (needToResetRoll) {
      _log.info('Need to reset rolls');
      final resetRollResult = await _resetRolls();
      switch (resetRollResult) {
        case Error<void>():
          _log.warning('Failed to reset rolls', resetRollResult.error);
          return Result.error(resetRollResult.error);
        case Ok<void>():
          _log.fine('Roll counts reset');
      }
    }

    //Reset daily tasks if necessary
    final lastTaskResetDateResult =
        await _taskRepository.getLastTaskResetDate();
    switch (lastTaskResetDateResult) {
      case Error<DateTime?>():
        _log.warning('Failed to load last task reset date',
            lastTaskResetDateResult.error);
        return Result.error(lastTaskResetDateResult.error);
      case Ok<DateTime?>():
    }
    bool needToResetTasks = false;
    if (lastTaskResetDateResult.value == null) {
      _log.fine('Last task reset date not set');
      needToResetTasks = true;
    } else {
      final lastTasksResetDate = lastTaskResetDateResult.value;
      _log.info('Last task reset date : ${lastTasksResetDate}');
      _log.info(
          'Next monday midnight : ${!DateUtils.isSameDay(lastTasksResetDate, DateTime.now())}');
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
          _log.fine('Daily tasks reset');
      }
    }

    return Result.ok(null);
  }

  Future<Result<void>> _resetRolls() async {
    try {
      final importantRollSaveResult =
          await _taskRepository.saveImportantRoll(_maxRollCount);
      switch (importantRollSaveResult) {
        case Error<void>():
          _log.warning('Failed to save important roll count');
          return Result.error(importantRollSaveResult.error);
        case Ok<void>():
      }
      final selfCareSaveResult =
          await _taskRepository.saveSelfCareRoll(_maxRollCount);
      switch (selfCareSaveResult) {
        case Error<void>():
          _log.warning('Failed to save self care roll count');
          return Result.error(selfCareSaveResult.error);
        case Ok<void>():
      }
      final rollResetDateSaveResult =
          await _taskRepository.saveLastRollResetDate(DateTime.now());
      switch (rollResetDateSaveResult) {
        case Error<void>():
          _log.warning('Failed to save last roll date');
          return Result.error(rollResetDateSaveResult.error);
        case Ok<void>():
      }
    } on Exception catch (e) {
      _log.warning('Failed to reset rolls');
      return Result.error(e);
    }

    return Result.ok(null);
  }

  Future<Result<void>> _resetTasks() async {
    // Update daily important task.
    final importantTasksResult = await _taskRepository.getTasks(TaskType.important);
    switch (importantTasksResult) {
      case Error<List<Task>>():
        _log.warning(
            'Failed to load important tasks', importantTasksResult.error);
        return Result.error(importantTasksResult.error);
      case Ok<List<Task>>():
    }
    List<Task> importantTasks = importantTasksResult.value;
    if (importantTasks.isEmpty) {
      final importantSaveResult =
          await _taskRepository.saveDailyImportantTask(null);
      switch (importantSaveResult) {
        case Error<void>():
          _log.warning(
              'Failed to save important daily task', importantSaveResult.error);
          return Result.error(importantSaveResult.error);
        case Ok<void>():
      }
    } else {
      Task importantTask;
      if (importantTasks.length == 1) {
        importantTask = importantTasks[0];
      } else {
        final currentImportantTaskResult =
            await _taskRepository.getDailyImportantTask();
        switch (currentImportantTaskResult) {
          case Error<Task?>():
            _log.warning('Failed to load current daily task',
                currentImportantTaskResult.error);
            return Result.error(currentImportantTaskResult.error);
          case Ok<Task?>():
        }
        if (currentImportantTaskResult.value != null) {
          var filteredImportantTasks = importantTasks
              .where((task) => task.id != currentImportantTaskResult.value!.id);
          importantTasks = filteredImportantTasks.toList();
        }
        importantTask = importantTasks[Random().nextInt(importantTasks.length)];
      }
      final importantSaveResult =
          await _taskRepository.saveDailyImportantTask(importantTask);
      switch (importantSaveResult) {
        case Error<void>():
          _log.warning('Failed to save important daily important task',
              importantSaveResult.error);
          return Result.error(importantSaveResult.error);
        case Ok<void>():
      }
    }

    // Update daily self care task.
    final selfCareTasksResult = await _taskRepository.getTasks(TaskType.selfCare);
    switch (selfCareTasksResult) {
      case Error<List<Task>>():
        _log.warning(
            'Failed to load important tasks', selfCareTasksResult.error);
        return Result.error(selfCareTasksResult.error);
      case Ok<List<Task>>():
    }
    List<Task> selfCareTasks = selfCareTasksResult.value;
    if (selfCareTasks.isEmpty) {
      final selfCareSaveResult =
          await _taskRepository.saveDailySelfCareTask(null);
      switch (selfCareSaveResult) {
        case Error<void>():
          _log.warning(
              'Failed to save self care daily task', selfCareSaveResult.error);
          return Result.error(selfCareSaveResult.error);
        case Ok<void>():
      }
    } else {
      Task selfCareTask;
      if (selfCareTasks.length == 1) {
        selfCareTask = selfCareTasks[0];
      } else {
        final currentSelfCareTaskResult =
            await _taskRepository.getDailySelfCareTask();
        switch (currentSelfCareTaskResult) {
          case Error<Task?>():
            _log.warning('Failed to load current daily self care task',
                currentSelfCareTaskResult.error);
            return Result.error(currentSelfCareTaskResult.error);
          case Ok<Task?>():
        }
        if (currentSelfCareTaskResult.value != null) {
          var filteredSelfCareTasks = selfCareTasks
              .where((task) => task.id != currentSelfCareTaskResult.value!.id);
          selfCareTasks = filteredSelfCareTasks.toList();
        }
        selfCareTask = selfCareTasks[Random().nextInt(selfCareTasks.length)];
      }
      final selfCareSaveResult =
          await _taskRepository.saveDailySelfCareTask(selfCareTask);
      switch (selfCareSaveResult) {
        case Error<void>():
          _log.warning(
              'Failed to save important daily task', selfCareSaveResult.error);
          return Result.error(selfCareSaveResult.error);
        case Ok<void>():
      }
    }

    final saveTaskResetDate =
        await _taskRepository.saveLastTaskResetDate(DateTime.now());
    switch (saveTaskResetDate) {
      case Error<void>():
        _log.warning(
            'Failed to save daily tasks reset date', saveTaskResetDate.error);
        return Result.error(saveTaskResetDate.error);
      case Ok<void>():
    }
    return Result.ok(null);
  }

  Future<Result<Task?>> getDailyImportantTask() async {
    await _updateIfNecessary();
    return _taskRepository.getDailyImportantTask();
  }

  Future<Result<Task?>> getDailySelfCareTask() async {
    await _updateIfNecessary();
    return _taskRepository.getDailySelfCareTask();
  }

  Future<Result<int?>> getImportantRollCount() async {
    await _updateIfNecessary();
    final importantRollResult = await _taskRepository.getImportantRoll();
    switch (importantRollResult) {
      case Error<int?>():
        _log.warning('Failed to load important roll count');
        return Result.error(importantRollResult.error);
      case Ok<int?>():
    }
    return importantRollResult;
  }

  Future<Result<int?>> getSelfCareRollCount() async {
    await _updateIfNecessary();
    final selfCareRollResult = await _taskRepository.getSelfCareRoll();
    switch (selfCareRollResult) {
      case Error<int?>():
        _log.warning('Failed to load self care roll count');
        return Result.error(selfCareRollResult.error);
      case Ok<int?>():
    }
    return selfCareRollResult;
  }

  Future<Result<Task?>> getNewImportantTask(){
    //Get important roll count
    //If important roll count > 0
    // important roll count --
    // Get current important task
    // Get tasks
    // Remove current task from important tasks
    // Get new random important task from tasks list
    //Else throw Exception not enough rolls
    throw UnimplementedError();
  }
}
