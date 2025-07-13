import 'package:reefquest/utils/result.dart';

abstract class DailyTaskService {

  Future<Result<int?>> getImportantTaskOfDayId();

  Future<Result<void>> saveImportantTaskOfDayId(int id);

  Future<Result<int?>> getSelfCareTaskOfDayId();

  Future<Result<void>> saveSelfCareTaskOfDayId(int id);

  Future<Result<void>> saveImportantRollCount(int count);

  Future<Result<int?>> getImportantRollCount();

  Future<Result<void>> saveSelfCareRollCount(int count);

  Future<Result<int?>> getSelfCareRollCount();

  Future<Result<DateTime?>> getLastTaskResetDate();

  Future<Result<DateTime?>> getLastRollResetDate();

  Future<Result<void>> saveLastTaskResetDate(DateTime date);

  Future<Result<void>> saveLastRollResetDate(DateTime date);
}
