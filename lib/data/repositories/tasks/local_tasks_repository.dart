import 'package:reefquest/data/models/task.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/data/services/task_service.dart';
import 'package:reefquest/utils/result.dart';

class LocalTasksRepository extends TaskRepository {
  final TaskService _taskService;

  LocalTasksRepository({required TaskService taskService})
      : _taskService = taskService;

  @override
  Future<Result<List<Task>>> getImportantTasks() {
    return _taskService.getImportantTasks();
  }

  @override
  Future<Result<List<Task>>> getSelfCareTasks() {
    return _taskService.getSelfCareTasks();
  }

  @override
  Future<Result<void>> saveImportantTask(Task task) {
    return _taskService.saveImportantTask(task);
  }

  @override
  Future<Result<void>> saveSelfCareTask(Task task) {
    return _taskService.saveSelfCareTask(task);
  }

  @override
  Future<Result<void>> updateImportantTask(Task task) {
    return _taskService.updateImportantTask(task);
  }

  @override
  Future<Result<void>> updateSelfCareTask(Task task) {
    return _taskService.updateSelfCareTask(task);
  }

  @override
  Future<Result<void>> deleteImportantTask(Task task) {
    return _taskService.deleteImportantTask(task);
  }

  @override
  Future<Result<void>> deleteSelfCareTask(Task task) {
    return _taskService.deleteSelfCareTask(task);
  }
}
