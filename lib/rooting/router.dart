import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reefquest/rooting/routes.dart';
import 'package:reefquest/ui/daily_tasks/daily_tasks.dart';
import 'package:reefquest/ui/shared/shared_menu.dart';

import '../ui/task_list/task_list.dart';
import '../ui/task_list/view_models/task_list_view_models.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.dailyTasks,
    routes: [
      ShellRoute(
        builder: (context, state, child) => SharedMenu(child: child),
        routes: [
          GoRoute(
            path: Routes.dailyTasks,
            name: Routes.dailyTasksName,
            builder: (context, state) => DailyTasks(),
          ),
          GoRoute(
            path: Routes.importantTasks,
            name: Routes.importantTasksName,
            builder: (context, state) => TaskList(
                viewModel:
                    ImportantTaskListViewModel(taskRepository: context.read())),
          ),
          GoRoute(
            path: Routes.selfCareTasks,
            name: Routes.selfCareTasksName,
            builder: (context, state) => TaskList(
                viewModel:
                    SelfCareTaskListViewModel(taskRepository: context.read())),
          ),
        ],
      ),
    ],
  );
}
