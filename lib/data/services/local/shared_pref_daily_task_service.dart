import 'package:reefquest/data/services/daily_task_service.dart';
import 'package:reefquest/utils/result.dart';

class SharedPrefDailyTaskService extends DailyTaskService {
  final _keyImportantId = 'daily_important_task_id';
  final _keySelfCareId = 'daily_selfcare_task_id';
  final _keyLastUpdate = 'daily_task_date';

  final _keyRerollImportant = 'reroll_important';
  final _keyRerollSelfcare = 'reroll_selfcare';
  final _keyLastRerollReset = 'last_reroll_reset';

  SharedPrefDailyTaskService();

  @override
  Future<Result<void>> decrementImportantRerollCount() {
    // TODO: implement decrementImportantRerollCount
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> decrementSelfCareRerollCount() {
    // TODO: implement decrementSelfCareRerollCount
    throw UnimplementedError();
  }

  @override
  Future<Result<int>> getImportantRerollCount() {
    // TODO: implement getImportantRerollCount
    throw UnimplementedError();
  }

  @override
  Future<Result<int?>> getImportantTaskOfDayId() {
    // TODO: implement getImportantTaskOfDayId
    throw UnimplementedError();
  }

  @override
  Future<Result<DateTime>> getLastTaskResetDate() {
    // TODO: implement getLastResetDate
    throw UnimplementedError();
  }

  @override
  Future<Result<int>> getSelfCareRerollCount() {
    // TODO: implement getSelfCareRerollCount
    throw UnimplementedError();
  }

  @override
  Future<Result<int?>> getSelfCareTaskOfDayId() {
    // TODO: implement getSelfCareTaskOfDayId
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveImportantRerollCount(int count) {
    // TODO: implement saveImportantRerollCount
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveImportantTaskOfDayId() {
    // TODO: implement saveImportantTaskOfDayId
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveSelfCareRerollCount(int count) {
    // TODO: implement saveSelfCareRerollCount
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveSelfCareTaskOfDayId() {
    // TODO: implement saveSelfCareTaskOfDayId
    throw UnimplementedError();
  }

  @override
  Future<Result<DateTime>> getLastRerollResetDate() {
    // TODO: implement getLastRerollResetDate
    throw UnimplementedError();
  }
}
