import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reefquest/data/repositories/tasks/local_tasks_repository.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/data/services/local/db_task_service.dart';
import 'package:reefquest/data/services/task_service.dart';

List<SingleChildWidget> get providersLocal {
  return [
    Provider(create: (context) => DbTaskService() as TaskService),
    Provider(
        create: (context) =>
            LocalTasksRepository(taskService: context.read()) as TaskRepository)
  ];
}
