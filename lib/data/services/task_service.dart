import 'package:reefquest/utils/result.dart';

import '../models/task.dart';

abstract class TaskService {
  Future<Result<List<Task>>> getTasks(TaskType type, {bool? done});

  Future<Result<void>> saveTask(Task task);

  Future<Result<Task?>> getTaskFromId(int id);

  Future<Result<void>> updateTask(Task task);

  Future<Result<void>> deleteTask(Task task);
}
