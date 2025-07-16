import '../../../utils/result.dart';
import '../../models/task.dart';

abstract class TaskRepository {
  Future<Result<List<Task>>> getTasks(TaskType type, {bool? done = false});

  Future<Result<void>> saveTask(Task task);

  Future<Result<void>> updateTask(Task task);

  Future<Result<void>> deleteTask(Task task);

  Future<Result<Task?>> getDailyTask(TaskType type);

  Future<Result<void>> saveDailyTask(Task? task, TaskType type);

  Future<Result<int>> getRoll(TaskType type);

  Future<Result<void>> saveRoll(TaskType type, int count);

  Future<Result<DateTime?>> getLastTaskResetDate();

  Future<Result<DateTime?>> getLastRollResetDate();

  Future<Result<void>> saveLastRollResetDate(DateTime date);

  Future<Result<void>> saveLastTaskResetDate(DateTime date);
}
