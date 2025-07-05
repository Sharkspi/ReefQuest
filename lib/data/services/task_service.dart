import 'package:reefquest/utils/result.dart';

import '../models/task.dart';

abstract class TaskService {
  Future<Result<List<Task>>> getImportantTasks();

  Future<Result<List<Task>>> getSelfCareTasks();

  Future<Result<Task?>> getTask(int id);

  Future<Result<void>> saveImportantTask(Task task);

  Future<Result<void>> saveSelfCareTask(Task task);


  Future<Result<void>> updateImportantTask(Task task);

  Future<Result<void>> updateSelfCareTask(Task task);

  Future<Result<void>> deleteImportantTask(Task task);

  Future<Result<void>> deleteSelfCareTask(Task task);
}
