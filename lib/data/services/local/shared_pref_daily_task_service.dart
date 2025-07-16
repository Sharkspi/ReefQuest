import 'package:logging/logging.dart';
import 'package:reefquest/data/services/daily_task_service.dart';
import 'package:reefquest/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/task.dart';

class SharedPrefDailyTaskService extends DailyTaskService {
  final Logger _log = Logger('$SharedPrefDailyTaskService');

  final _keyLastTaskResetDate = 'daily_task_date';
  final _keyLastRollResetDate = 'last_roll_reset';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  SharedPrefDailyTaskService();

  @override
  Future<Result<int?>> getTaskOfDayId(TaskType type) async {
    try {
      final result = await _prefs.getInt(_getTaskTypeDailyTaskKey(type));
      _log.fine('Daily ${type.name} task loaded, id : $result');
      return Result.ok(result);
    } on Exception catch (e) {
      _log.warning('Failed to retrieve daily ${type.name} task id', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveTaskOfDayId(TaskType type, int? id) async {
    try {
      if (id != null) {
        await _prefs.setInt(_getTaskTypeDailyTaskKey(type), id);
      } else {
        _prefs.remove(_getTaskTypeDailyTaskKey(type));
      }
      _log.fine('Saved ${type.name} daily task');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save ${type.name} task id', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<int?>> getRollCount(TaskType type) async {
    try {
      final result = await _prefs.getInt(_getTaskTypeRollCountKey(type));
      _log.fine('${type.name} roll count loaded');
      return Result.ok(result);
    } on Exception catch (e) {
      _log.warning('Failed to retrieve ${type.name} roll count', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveRollCount(TaskType type, int count) async {
    try {
      await _prefs.setInt(_getTaskTypeRollCountKey(type), count);
      _log.fine('Saved ${type.name} roll count');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save ${type.name} roll count', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<DateTime?>> getLastRollResetDate() async {
    try {
      final result = await _prefs.getInt(_keyLastRollResetDate);
      _log.fine('Last roll reset date loaded');
      if (result != null) {
        final resultDateTime = DateTime.fromMillisecondsSinceEpoch(result);
        // Return the corresponding [DateTime] if the key is set.
        return Result.ok(resultDateTime);
      } else {
        // Return null if the key is not already set.
        return Result.ok(null);
      }
    } on Exception catch (e) {
      _log.warning('Failed to retrieve last roll reset date', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<DateTime?>> getLastTaskResetDate() async {
    try {
      final result = await _prefs.getInt(_keyLastTaskResetDate);
      _log.fine('Last daily task reset date loaded');
      if (result != null) {
        final resultDateTime = DateTime.fromMillisecondsSinceEpoch(result);
        // Return the corresponding [DateTime] if the key is set.
        return Result.ok(resultDateTime);
      } else {
        // Return null if the key is not already set.
        return Result.ok(null);
      }
    } on Exception catch (e) {
      _log.warning('Failed to retrieve last daily task reset date', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveLastRollResetDate(DateTime date) async {
    try {
      final toEpochMillis = date.millisecondsSinceEpoch;
      await _prefs.setInt(_keyLastRollResetDate, toEpochMillis);
      _log.fine('Last roll reset date saved');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Faile to save roll reset date', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveLastTaskResetDate(DateTime date) async {
    try {
      final toEpochMillis = date.millisecondsSinceEpoch;
      await _prefs.setInt(_keyLastTaskResetDate, toEpochMillis);
      _log.fine('Saved last daily task reset date');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save last daily task reroll date');
      return Result.error(e);
    }
  }

  String _getTaskTypeDailyTaskKey(TaskType taskType) {
    return 'daily_${taskType.name}_task_id';
  }

  String _getTaskTypeRollCountKey(TaskType taskType) {
    return 'daily_${taskType.name}_roll_count';
  }
}
