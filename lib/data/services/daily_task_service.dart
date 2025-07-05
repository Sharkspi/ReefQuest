import 'package:reefquest/utils/result.dart';

abstract class DailyTaskService {
  Future<Result<int?>> getImportantTaskOfDayId();
  Future<Result<void>> saveImportantTaskOfDayId();

  Future<Result<int?>> getSelfCareTaskOfDayId();
  Future<Result<void>> saveSelfCareTaskOfDayId();

  Future<Result<void>> saveImportantRerollCount(int count);
  Future<Result<int>> getImportantRerollCount();
  Future<Result<void>> decrementSelfCareRerollCount();

  Future<Result<void>> saveSelfCareRerollCount(int count);
  Future<Result<int>> getSelfCareRerollCount();
  Future<Result<void>> decrementImportantRerollCount();

  Future<Result<DateTime>> getLastTaskResetDate();
  Future<Result<DateTime>> getLastRerollResetDate();
}
