import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/providers/tasks_provider.dart';

class CompletedTaskTile extends StatelessWidget {
  final Task task;

  const CompletedTaskTile({super.key, required this.task});

  Future<void> _onCompleteToggle(BuildContext context) async {
    try {
      await context.read<TasksProvider>().toggleCompleted(
        taskId: task.id,
        isCompleted: !task.isCompleted,
      );
    } catch (e) {
      print('Error toggle complete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () {
          print('Tapped on task: ${task.title}');
        },
        leading: IconButton(
          onPressed: () => _onCompleteToggle(context),
          icon: Icon(Icons.check, size: 22, color: AppColors.purpleBase),
          tooltip: 'Mark task as uncompleted',
        ),
        title: Text(task.title, style: theme.textTheme.bodyMedium),
        subtitle: Text(
          'Completed: ${DateFormat('yMMMd').format(task.completedAt!)}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
