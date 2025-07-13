import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reefquest/data/repositories/tasks/local_tasks_repository.dart';
import 'package:reefquest/data/repositories/tasks/tasks_repository.dart';
import 'package:reefquest/data/services/daily_task_service.dart';
import 'package:reefquest/data/services/local/db_task_service.dart';
import 'package:reefquest/data/services/local/shared_pref_daily_task_service.dart';
import 'package:reefquest/data/services/task_service.dart';
import 'package:reefquest/data/use_cases/DailyTasksUseCase.dart';


List<SingleChildWidget> get providersLocal {
  return [
    Provider(create: (context) => DbTaskService() as TaskService),
    Provider(
        create: (context) => SharedPrefDailyTaskService() as DailyTaskService),
    Provider(
        create: (context) => LocalTasksRepository(
            taskService: context.read(),
            dailyTaskService: context.read()) as TaskRepository),
    Provider(
        create: (context) => DailyTasksUseCase(taskRepository: context.read()))
  ];
}
