import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/providers/tasks_provider.dart';

class StarredTaskTile extends StatelessWidget {
  final Task task;
  final Future<void> Function(String taskId) onNavigateToTaskDetails;

  const StarredTaskTile({
    super.key,
    required this.task,
    required this.onNavigateToTaskDetails,
  });

  Future<void> _onStarredToggle(BuildContext context) async {
    try {
      await context.read<TasksProvider>().setStarredStatus(
        taskId: task.id,
        isStarred: !task.isStarred,
      );
    } catch (e) {
      print('Error toggle star: $e');
    }
  }

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
        onTap: () async {
          await onNavigateToTaskDetails(task.id);
        },
        leading: IconButton(
          onPressed: () => _onCompleteToggle(context),
          icon: task.isCompleted
              ? Icon(Icons.check, size: 22, color: AppColors.purpleBase)
              : Icon(Icons.radio_button_unchecked, size: 22),
          tooltip: 'Mark task as completed',
        ),
        title: Text(
          task.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: theme.textTheme.bodyMedium,
        ),
        subtitle: Row(
          children: [
            Text(
              task.date != null
                  ? DateFormat.yMMMEd().format(task.date!)
                  : 'No date',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue),
            ),
            if (task.time != null)
              Row(
                children: [
                  Text(
                    ' - ${task.time!}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                  if (task.isRepeating) ...[
                    const SizedBox(width: 4),
                    Icon(PhosphorIcons.repeat(), size: 16, color: Colors.blue),
                  ],
                ],
              ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _onStarredToggle(context),
          icon: Icon(
            task.isStarred ? PhosphorIconsFill.star : PhosphorIcons.star(),
            size: 20,
            color: task.isStarred ? Colors.amber : Colors.grey[400],
          ),
          tooltip: 'Mark task as favorite',
        ),
      ),
    );
  }
}
