import 'package:logging/logging.dart';
import 'package:reefquest/data/services/daily_task_service.dart';
import 'package:reefquest/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefDailyTaskService extends DailyTaskService {
  final Logger _log = Logger('$SharedPrefDailyTaskService');

  final _keyImportantId = 'daily_important_task_id';
  final _keySelfCareId = 'daily_self_care_task_id';
  final _keyLastTaskResetDate = 'daily_task_date';

  final _keyImportantRoll = 'roll_important';
  final _keySelfCareRoll = 'roll_self_care';
  final _keyLastRollResetDate = 'last_roll_reset';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  SharedPrefDailyTaskService();

  @override
  Future<Result<int?>> getImportantRollCount() async {
    try {
      final result = await _prefs.getInt(_keyImportantRoll);
      _log.fine('Important roll count loaded');
      return Result.ok(result);
    } on Exception catch (e) {
      _log.warning('Failed to retrieve important roll count', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<int?>> getImportantTaskOfDayId() async {
    try {
      final result = await _prefs.getInt(_keyImportantId);
      _log.fine('Daily important task id loaded');
      return Result.ok(result);
    } on Exception catch (e) {
      _log.warning('Failed to retrieve daily important task id', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<int?>> getSelfCareRollCount() async {
    try {
      final result = await _prefs.getInt(_keySelfCareRoll);
      _log.fine('Self care roll count loaded');
      return Result.ok(result);
    } on Exception catch (e) {
      _log.warning('Failed to retrieve self care roll count', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<int?>> getSelfCareTaskOfDayId() async {
    try {
      final result = await _prefs.getInt(_keySelfCareId);
      _log.fine('Daily self care task loaded');
      return Result.ok(result);
    } on Exception catch (e) {
      _log.warning('Failed to retrieve daily self care task id', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveImportantRollCount(int count) async {
    try {
      await _prefs.setInt(_keyImportantRoll, count);
      _log.fine('Saved important roll count');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save important roll count', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveImportantTaskOfDayId(int id) async {
    try {
      await _prefs.setInt(_keyImportantId, id);
      _log.fine('Saved important daily task');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save important task id', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveSelfCareRollCount(int count) async {
    try {
      await _prefs.setInt(_keySelfCareRoll, count);
      _log.fine('Saved self care roll count');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save self care roll count', e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveSelfCareTaskOfDayId(int id) async {
    try {
      await _prefs.setInt(_keySelfCareId, id);
      _log.fine('Saved self care daily task');
      return Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to save self care task id', e);
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
}
