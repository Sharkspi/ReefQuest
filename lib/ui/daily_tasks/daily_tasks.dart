import 'package:flutter/material.dart';
import 'package:reefquest/ui/daily_tasks/view_models/daily_tasks_view_model.dart';

class DailyTasks extends StatefulWidget {
  const DailyTasks({super.key, required this.viewModel});

  final DailyTasksViewModel viewModel;

  @override
  State<DailyTasks> createState() => _DailyTasksState();
}

class _DailyTasksState extends State<DailyTasks> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.load.running) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            Text(
                'Important roll count : ${widget.viewModel.importantRollCount}'),
            Text(
                'Important task : ${widget.viewModel.importantTask.toString()}'),
            Text(
                'Important roll count : ${widget.viewModel.selfCareRollCount}'),
            Text(
                'Important roll count : ${widget.viewModel.selfCareTask.toString()}'),
          ],
        );
      },
    );
  }
}
