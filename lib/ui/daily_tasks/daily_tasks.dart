import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reefquest/ui/daily_tasks/view_models/daily_tasks_view_model.dart';

import '../../data/models/task.dart';

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
        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: TaskType.values.length,
              itemBuilder: (context, index) {
                var taskType = TaskType.values[index];
                final Task? task = widget.viewModel.taskMap[taskType];
                final int rollCount = widget.viewModel.rollMap[taskType] ?? 0;
                return DailyTaskCard(
                    key: ValueKey(task?.id ?? index),
                    task: task,
                    taskType: taskType,
                    viewModel: widget.viewModel,
                    onReroll: () => widget.viewModel.getNewTask(taskType),
                    remainingRerolls: rollCount,
                    onNewTask: () => widget.viewModel.getNewTask(taskType));
              },
            );
          }
        });
  }
}

class DailyTaskCard extends StatelessWidget {
  const DailyTaskCard(
      {super.key,
      required this.task,
      required this.viewModel,
      required this.onReroll,
      required this.remainingRerolls,
      required this.onNewTask,
      required this.taskType});

  final Task? task;
  final DailyTasksViewModel viewModel;
  final VoidCallback onReroll;
  final int remainingRerolls;
  final VoidCallback onNewTask;
  final TaskType taskType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Text(
            taskType.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 160),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: task == null
                    ? _buildTaskCompleted(context)
                    : _buildTaskContent(context, theme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCompleted(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '🎉 Task already done, congrats ! 🎉',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onNewTask,
          icon: const Icon(Icons.add_task),
          label: const Text('New task'),
        ),
      ],
    );
  }

  Widget _buildTaskContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: Title + Reroll
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                task!.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: onReroll,
                  icon: const Icon(Icons.refresh, size: 28),
                  tooltip: 'Reroll task',
                ),
                if (remainingRerolls > 0)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$remainingRerolls',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          task!.description ?? '',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: _DoneIconButton(task: task!, viewModel: viewModel),
        ),
      ],
    );
  }
}

class _DoneIconButton extends StatefulWidget {
  const _DoneIconButton({required this.task, required this.viewModel});

  final Task task;
  final DailyTasksViewModel viewModel;

  @override
  State<_DoneIconButton> createState() => _DoneIconButtonState();
}

class _DoneIconButtonState extends State<_DoneIconButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateTask.addListener(_onUpdateResult);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant _DoneIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.updateTask.removeListener(_onUpdateResult);
    widget.viewModel.updateTask.addListener(_onUpdateResult);
  }

  @override
  void dispose() {
    widget.viewModel.updateTask.removeListener(_onUpdateResult);
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await widget.viewModel.updateTask.execute(
        widget.task.copyWith(done: !widget.task.done),
        () async => _animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.updateTask,
      builder: (context, _) {
        return InkWell(
          customBorder: CircleBorder(),
          onTap: widget.viewModel.updateTask.running ? null : _onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12,
                8) /*const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8)*/,
            child: Lottie.asset('assets/chest_opening.json',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                controller: _animationController, onLoaded: (composition) {
              _animationController.duration = composition.duration;
              // ..forward();
            }),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateResult() async {
    if (widget.viewModel.updateTask.error) {
      widget.viewModel.updateTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to modify the task'),
            duration: Duration(milliseconds: 500)),
      );
    }
  }
}
