import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:expandable/expandable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/app_router.dart';
import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/utils/map_weekdays.dart';
import 'package:planme/data/models/sub_task.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/providers/subtasks_provider.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/ui/screens/task_details/subtask_tile.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';
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
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onStarToggle(BuildContext context) async {
    try {
      final taskDetails = context.read<TasksProvider>().getTaskDetails(
        widget.taskId,
      );

      await context.read<TasksProvider>().toggleStarred(
        taskId: taskDetails.id,
        isStarred: !taskDetails.isStarred,
      );
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

  Future<void> _deleteSubtask(SubTask subtask) async {
    try {
      final subtaskProvider = Provider.of<SubtasksProvider>(
        context,
        listen: false,
      );

      final deletedSubtaskIndex = await subtaskProvider.deleteSubtask(
        subtask.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtask deleted',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.lightBackground,
          action: SnackBarAction(
            label: 'UNDO',
            textColor: AppColors.purpleBase,
            onPressed: () async {
              await subtaskProvider.restoreSubtask(
                subtaskIndex: deletedSubtaskIndex,
                subtask: subtask,
              );
            },
          ),
        ),
      );
    } catch (e) {
      print('delete subtask error: $e');
    }
  }

  Future<void> _toggleCompleteSubtask(
    BuildContext context,
    SubTask subtask,
  ) async {
    try {
      final subtaskProvider = Provider.of<SubtasksProvider>(
        context,
        listen: false,
      );

      await subtaskProvider.toggleCompleted(
        subtaskId: subtask.id,
        isCompleted: !subtask.isCompleted,
      );

      // await subtaskProvider.loadSubtasksByTaskId(subtask.taskId);
    } catch (e) {
      print('toggle complete subtask error: $e');
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

  Widget _recurrenceDetails(RecurrenceRule recurrence) {
    if (recurrence.type == RecurrenceType.none) {
      return const SizedBox.shrink();
    }

    switch (recurrence.type) {
      case RecurrenceType.intervalDays:
        if (recurrence.interval == 1) {
          return Text('Daily', style: TextStyle(fontWeight: FontWeight.bold));
        }

        return RichText(
          text: TextSpan(
            text: 'Repeats every ',

            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: '${recurrence.interval}',
                style: const TextStyle(color: AppColors.purpleBase),
              ),
              const TextSpan(text: ' days'),
            ],
          ),
        );
      case RecurrenceType.weekly:
        final weekdaysList = recurrence.weekdays!.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Repeats every: '),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: mapWeekDays(weekdaysList, DayFormat.short).map((
                weekday,
              ) {
                return Chip(
                  label: Text(
                    weekday,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.purpleLight,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        );

      case RecurrenceType.monthlyDayOfMonth:
        return Text('Repeats monthly on the ${recurrence.dayOfMonth}th.');

      case RecurrenceType.monthlyWeekdayOfMonth:
        final weekday = mapWeekDays([
          recurrence.weekdayOfMonth!,
        ], DayFormat.full).first;

        final weekOfMonth = switch (recurrence.weekOfMonth!) {
          1 => '1st',
          2 => '2nd',
          3 => '3rd',
          4 => '4th',
          -1 => 'Last',
          _ => 'Unknown',
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Repeats every: '),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: [
                Chip(
                  label: Text(
                    weekOfMonth,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.purpleLight,
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(
                    weekday,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.purpleLight,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        );

      case RecurrenceType.yearly:
        if (recurrence.interval == 1) {
          return Text('Yearly', style: TextStyle(fontWeight: FontWeight.bold));
        }

        return RichText(
          text: TextSpan(
            text: 'Repeats every ',

            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: '${recurrence.interval}',
                style: const TextStyle(color: AppColors.purpleBase),
              ),
              const TextSpan(text: ' years'),
            ],
          ),
        );
      case RecurrenceType.none:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasksProvider, _) {
        final taskDetails = tasksProvider.getTaskDetails(widget.taskId);

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: AppColors.lightBackground,
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
                          backgroundColor: AppColors.lightBackground,
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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

                    if (taskDetails.baseDateTime != null ||
                        taskDetails.timeLabel != null)
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
                                  if (taskDetails.baseDateTime != null)
                                    Text(
                                      DateFormat.yMMMEd().format(
                                        taskDetails.baseDateTime!,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (taskDetails.timeLabel != null)
                                    Text(
                                      ' at ${taskDetails.timeLabel!}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (taskDetails.recurrence != null) ...[
                      const SizedBox(height: 10),
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
                                    PhosphorIcons.repeat(),
                                    color: AppColors.purpleBase,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Recurrence',
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
                              child: _recurrenceDetails(
                                taskDetails.recurrence!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Subtasks section
                    Consumer<SubtasksProvider>(
                      child: CreateSubtaskForm(
                        onSubmitForm: (String data) async {
                          await _createSubtask(data);
                        },
                      ),
                      builder: (context, subtasksProvider, child) {
                        final subtasks = subtasksProvider.activeSubtasks;
                        final completedSubtasks =
                            subtasksProvider.completedSubtasks;

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              ImplicitlyAnimatedReorderableList<SubTask>(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                items: subtasks,
                                areItemsTheSame: (a, b) => a.id == b.id,
                                onReorderFinished: (item, from, to, newItems) {
                                  context
                                      .read<SubtasksProvider>()
                                      .setSubtasksOrder(newItems);
                                },
                                itemBuilder:
                                    (context, itemAnimation, subtask, index) {
                                      return Reorderable(
                                        key: ValueKey(subtask.id),
                                        builder: (context, dragAnimation, inDrag) {
                                          final t = dragAnimation.value;
                                          final elevation = lerpDouble(0, 8, t);
                                          final color = Color.lerp(
                                            Colors.white,
                                            Colors.white.withValues(alpha: 0.8),
                                            t,
                                          );

                                          return AnimatedBuilder(
                                            animation: dragAnimation,
                                            builder: (context, _) {
                                              return SizeFadeTransition(
                                                sizeFraction: 0.7,
                                                curve: Curves.easeOut,
                                                animation: itemAnimation,
                                                child: Material(
                                                  color: color,
                                                  elevation: elevation!,
                                                  type:
                                                      MaterialType.transparency,
                                                  child: SubtaskTile(
                                                    subtask: subtask,
                                                    onToggleComplete: () async {
                                                      await _toggleCompleteSubtask(
                                                        context,
                                                        subtask,
                                                      );
                                                    },
                                                    onEditSubtask:
                                                        (String title) async {
                                                          await _editSubtask(
                                                            subtaskId:
                                                                subtask.id,
                                                            title: title,
                                                          );
                                                        },
                                                    onDeleteSubtask: () async {
                                                      await _deleteSubtask(
                                                        subtask,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                removeDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                insertDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                updateDuration: const Duration(
                                  milliseconds: 300,
                                ),
                              ),

                              const Divider(color: AppColors.purpleLight),

                              // Completed Subtasks section
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 16,
                                ),
                                child: ExpandablePanel(
                                  theme: ExpandableThemeData(
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                    tapBodyToExpand: true,
                                    tapBodyToCollapse: true,
                                    hasIcon: true,
                                  ),
                                  header: Text(
                                    'Completed Subtasks (${completedSubtasks.length})',
                                  ),
                                  collapsed: const SizedBox.shrink(),

                                  // Completed tasks list
                                  expanded: ImplicitlyAnimatedList<SubTask>(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    items: completedSubtasks,
                                    areItemsTheSame: (a, b) => a.id == b.id,
                                    itemBuilder:
                                        (context, animation, subtask, index) {
                                          return SizeFadeTransition(
                                            animation: animation,
                                            curve: Curves.easeOut,
                                            child: SubtaskTile(
                                              subtask: subtask,
                                              isDraggable: false,
                                              onToggleComplete: () async {
                                                await _toggleCompleteSubtask(
                                                  context,
                                                  subtask,
                                                );
                                              },
                                              onEditSubtask:
                                                  (String title) async {
                                                    await _editSubtask(
                                                      subtaskId: subtask.id,
                                                      title: title,
                                                    );
                                                  },
                                              onDeleteSubtask: () async {
                                                await _deleteSubtask(subtask);
                                              },
                                            ),
                                          );
                                        },
                                    removeDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    insertDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    updateDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                  ),
                                ),
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
      },
    );
  }
}
