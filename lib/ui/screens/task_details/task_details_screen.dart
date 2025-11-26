import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/data/models/task.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/app_router.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/data/models/sub_task.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/custom_app_bar.dart';
import 'package:planme/providers/subtasks_provider.dart';
import 'package:planme/ui/screens/task_details/subtask_tile.dart';
import 'package:planme/ui/screens/task_details/create_subtask_form.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasksProvider>().loadTaskDetails(widget.taskId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<SubtasksProvider>().loadSubtasksByTaskId(widget.taskId);
  }

  Future<void> _onStarToggle(BuildContext context) async {
    try {
      final state = context.read<TasksProvider>().detailsState;
      final taskDetails = state.task;

      if (taskDetails == null) {
        return;
      }

      await context.read<TasksProvider>().setStarredStatus(
        taskId: taskDetails.id,
        isStarred: !taskDetails.isStarred,
      );

      await context.read<TasksProvider>().loadTaskDetails(widget.taskId);
    } catch (e) {
      print('Error toggle star: $e');
    }
  }

  Future<void> _createSubtask(String title) async {
    try {
      final subtaskProvider = Provider.of<SubtasksProvider>(
        context,
        listen: false,
      );

      await subtaskProvider.createSubtask(taskId: widget.taskId, title: title);
    } catch (e) {
      print('create subtask error: $e');
    }
  }

  Future<void> _editSubtask({required String subtaskId, String? title}) async {
    try {
      final subtaskProvider = Provider.of<SubtasksProvider>(
        context,
        listen: false,
      );

      await subtaskProvider.editSubtask(subtaskId: subtaskId, title: title);
    } catch (e) {
      print('edit subtask error: $e');
    }
  }

  Future<void> _deleteSubtask({required String subtaskId}) async {
    try {
      final subtaskProvider = Provider.of<SubtasksProvider>(
        context,
        listen: false,
      );

      await subtaskProvider.deleteSubtask(subtaskId);
    } catch (e) {
      print('edit subtask error: $e');
    }
  }

  Future<void> _deleteTask({
    required BuildContext context,
    required Task task,
  }) async {
    try {
      final subtasks = context.read<SubtasksProvider>().subtasks;
      final taskReference = TaskDetails(task: task, subtasks: subtasks);

      final taskProvider = context.read<TasksProvider>();

      await taskProvider.deleteTask(widget.taskId);

      if (!context.mounted) return;

      context.pop<(bool, TaskDetails?)>((true, taskReference));
    } catch (e) {
      print('Error delete task: $e');
    }
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TasksProvider>().detailsState;

    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading task details...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return const Center(child: Text('Error loading task'));
    }

    final taskDetails = state.task;

    if (taskDetails == null) {
      return const Center(child: Text('Task not found'));
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            onPressed: () => _onStarToggle(context),
            icon: Icon(
              taskDetails.isStarred
                  ? PhosphorIconsFill.star
                  : PhosphorIcons.star(),
              size: 20,
              color: taskDetails.isStarred ? Colors.amber : null,
            ),
            tooltip: 'Mark task as favorite',
          ),
          MenuAnchor(
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.lightBackground,
              ),
              elevation: const WidgetStatePropertyAll(8),
            ),
            childFocusNode: _buttonFocusNode,
            menuChildren: <Widget>[
              MenuItemButton(
                leadingIcon: Icon(PhosphorIcons.pencilSimpleLine()),
                onPressed: () {
                  context.pushNamed(
                    AppRouter.editTask,
                    pathParameters: {'taskId': widget.taskId},
                    extra: taskDetails,
                  );
                },
                child: const Text('Edit'),
              ),
              MenuItemButton(
                leadingIcon: Icon(PhosphorIcons.trash()),
                style: ButtonStyle(
                  foregroundColor: const WidgetStatePropertyAll(Colors.red),
                  iconColor: const WidgetStatePropertyAll(Colors.red),
                  overlayColor: WidgetStatePropertyAll(
                    Colors.red.withValues(alpha: 0.06),
                  ),
                ),
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Task'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Are you sure you want to delete this task? Deleting this task will also delete all subtasks associated with it.',
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: AppColors.dangerBase),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (result != null && result) {
                    if (!context.mounted) return;

                    await _deleteTask(context: context, task: taskDetails);
                  }
                },
                child: const Text('Delete'),
              ),
            ],
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      PhosphorIcons.note(),
                      color: AppColors.purpleBase,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        taskDetails.title,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (taskDetails.description != null)
                  Text(taskDetails.description!),
                const SizedBox(height: 20),

                if (taskDetails.date != null || taskDetails.time != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.purpleLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                            bottom: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                PhosphorIcons.calendarCheck(),
                                color: AppColors.purpleBase,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Date and Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: AppColors.purpleLight),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              if (taskDetails.date != null)
                                Text(
                                  '${DateFormat.yMMMEd().format(taskDetails.date!)} ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              if (taskDetails.time != null)
                                Text(
                                  '- ${taskDetails.date!.hour.toString().padLeft(2, '0')}:${taskDetails.date!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Subtasks section
                Consumer<SubtasksProvider>(
                  child: CreateSubtaskForm(
                    onSubmitForm: (String data) async {
                      await _createSubtask(data);
                    },
                  ),
                  builder: (context, subtasksProvider, child) {
                    final subtasks = subtasksProvider.subtasks;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.purpleLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                              bottom: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.library_add,
                                      color: AppColors.purpleBase,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Subtasks (${subtasks.length})',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                if (child != null) child,
                              ],
                            ),
                          ),

                          if (subtasks.isNotEmpty)
                            const Divider(
                              color: AppColors.purpleLight,
                              height: 0,
                            ),

                          // Subtasks list
                          ImplicitlyAnimatedList<SubTask>(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            items: subtasks,
                            areItemsTheSame: (a, b) => a.id == b.id,
                            itemBuilder: (context, animation, subtask, index) {
                              return SizeFadeTransition(
                                animation: animation,
                                curve: Curves.easeOut,
                                child: SubtaskTile(
                                  subtask: subtask,
                                  onEditSubtask: (String title) async {
                                    await _editSubtask(
                                      subtaskId: subtask.id,
                                      title: title,
                                    );
                                  },
                                  onDeleteSubtask: () async {
                                    await _deleteSubtask(subtaskId: subtask.id);
                                  },
                                ),
                              );
                            },
                            removeItemBuilder:
                                (context, animation, oldSubtask) {
                                  return SizeFadeTransition(
                                    animation: animation,
                                    curve: Curves.easeIn,
                                    child: SubtaskTile(
                                      subtask: oldSubtask,
                                      onEditSubtask: (String title) async {
                                        await _editSubtask(
                                          subtaskId: oldSubtask.id,
                                          title: title,
                                        );
                                      },
                                      onDeleteSubtask: () async {
                                        await _deleteSubtask(
                                          subtaskId: oldSubtask.id,
                                        );
                                      },
                                    ),
                                  );
                                },
                            removeDuration: const Duration(milliseconds: 300),
                            insertDuration: const Duration(milliseconds: 300),
                            updateDuration: const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
