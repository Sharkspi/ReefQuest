import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reefquest/ui/task_list/task_edition_botton_sheet.dart';
import 'package:reefquest/ui/task_list/view_models/task_list_view_models.dart';

import '../../data/models/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.viewModel});

  final TaskListViewModel viewModel;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteTask.addListener(_onDeleteResult);
  }

  @override
  void didUpdateWidget(covariant TaskList oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteTask.removeListener(_onDeleteResult);
    widget.viewModel.deleteTask.addListener(_onDeleteResult);
  }

  @override
  void dispose() {
    widget.viewModel.deleteTask.removeListener(_onDeleteResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return child!;
        },
        child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                body: SafeArea(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: widget.viewModel.tasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.viewModel.tasks[index];
                        return _Task(
                            key: ValueKey(task.id),
                            task: task,
                            viewModel: widget.viewModel,
                            onTapUpdate: () => _openTaskModal(task: task),
                            onConfirmDismiss: (_) async {
                              await widget.viewModel.deleteTask.execute(task);
                              if (widget.viewModel.deleteTask.completed) {
                                return true;
                              } else {
                                return false;
                              }
                            });
                      }),
                ),
                floatingActionButton: FloatingActionButton.extended(
                    onPressed: (widget.viewModel.addTask.running ||
                            widget.viewModel.updateTask.running ||
                            widget.viewModel.deleteTask.running)
                        ? null
                        : _openTaskModal,
                    tooltip: 'Add a new task',
                    label: Text('New task'),
                    icon: const Icon(Icons.add)),
              );
            }));
  }

  Future<void> _openTaskModal({Task? task}) async {
    final Task? result = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => TaskFormBottomSheet(
          initialTask: task, taskType: widget.viewModel.taskType),
    );

    if (result == null) return;

    if (task == null) {
      widget.viewModel.addTask.execute(result);
    } else {
      widget.viewModel.updateTask.execute(result, () async {});
    }
  }

  void _onDeleteResult() {
    if (widget.viewModel.deleteTask.completed) {
      widget.viewModel.deleteTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task deleted'),
        duration: Duration(milliseconds: 500),
      ));
    }

    if (widget.viewModel.deleteTask.error) {
      widget.viewModel.deleteTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error while deleting task'),
          duration: Duration(milliseconds: 500)));
    }
  }
}

class _Task extends StatelessWidget {
  final Task task;
  final TaskListViewModel viewModel;
  final GestureTapCallback onTapUpdate;
  final ConfirmDismissCallback onConfirmDismiss;

  const _Task(
      {super.key,
      required this.task,
      required this.viewModel,
      required this.onTapUpdate,
      required this.onConfirmDismiss});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      confirmDismiss: onConfirmDismiss,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
                side: BorderSide()),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                title: Row(
                  children: [
                    _DoneIconButton(task: task, viewModel: viewModel),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: Text(task.title),
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(task.description ?? ''),
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                  onPressed: onTapUpdate,
                                  icon: Icon(Icons.edit_outlined)),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class _DoneIconButton extends StatefulWidget {
  const _DoneIconButton(
      {required this.task, required this.viewModel});

  final Task task;
  final TaskListViewModel viewModel;

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
