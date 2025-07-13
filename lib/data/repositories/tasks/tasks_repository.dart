import '../../../utils/result.dart';
import '../../models/task.dart';

abstract class TaskRepository {
  //NEW IMPLEMENTATIONS
  Future<Result<List<Task>>> getTasks(TaskType type, {bool? done = false});

  Future<Result<void>> saveTask(Task task);

  Future<Result<void>> updateTask(Task task);

  Future<Result<void>> deleteTask(Task task);

  //OLD IMPLEMENTATIONS

  Future<Result<Task?>> getDailyImportantTask();

  Future<Result<Task?>> getDailySelfCareTask();

  Future<Result<void>> saveDailyImportantTask(Task? task);

  Future<Result<void>> saveDailySelfCareTask(Task? task);

  Future<Result<int?>> getImportantRoll();

  Future<Result<int?>> getSelfCareRoll();

  Future<Result<void>> saveImportantRoll(int count);

  Future<Result<void>> saveSelfCareRoll(int count);

  Future<Result<DateTime?>> getLastTaskResetDate();

  Future<Result<DateTime?>> getLastRollResetDate();

  Future<Result<void>> saveLastRollResetDate(DateTime date);

  Future<Result<void>> saveLastTaskResetDate(DateTime date);
}
