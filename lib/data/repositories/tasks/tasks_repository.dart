import 'package:flutter/cupertino.dart';

import '../../../utils/result.dart';
import '../../models/task.dart';

abstract class TaskRepository {
  Future<Result<List<Task>>> getImportantTasks();

  Future<Result<List<Task>>> getSelfCareTasks();

  Future<Result<void>> saveImportantTask(Task task);

  Future<Result<void>> updateImportantTask(Task task);

  Future<Result<void>> saveSelfCareTask(Task task);

  Future<Result<void>> updateSelfCareTask(Task task);

  Future<Result<void>> deleteImportantTask(Task task);

  Future<Result<void>> deleteSelfCareTask(Task task);
}
