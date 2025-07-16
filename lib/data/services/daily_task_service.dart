import 'package:reefquest/data/models/task.dart';
import 'package:reefquest/utils/result.dart';

abstract class DailyTaskService {
  Future<Result<int?>> getTaskOfDayId(TaskType type);

  Future<Result<void>> saveTaskOfDayId(TaskType type, int? id);

  Future<Result<int?>> getRollCount(TaskType type);

  Future<Result<void>> saveRollCount(TaskType type, int count);

  Future<Result<DateTime?>> getLastTaskResetDate();

  Future<Result<DateTime?>> getLastRollResetDate();

  Future<Result<void>> saveLastTaskResetDate(DateTime date);

  Future<Result<void>> saveLastRollResetDate(DateTime date);
}
