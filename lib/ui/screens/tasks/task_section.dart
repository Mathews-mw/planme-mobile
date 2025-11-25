import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/ui/screens/tasks/task_tile.dart';

class TaskSectionWidget extends StatelessWidget {
  final TaskSection section;
  final bool isLast;
  final bool dimmed;
  final Future<void> Function(String taskId) onNavigateToTaskDetails;

  const TaskSectionWidget({
    super.key,
    required this.section,
    required this.isLast,
    this.dimmed = false,
    required this.onNavigateToTaskDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: isLast
            ? BorderRadius.vertical(bottom: Radius.circular(12))
            : BorderRadius.circular(6),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              section.label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Lista animada de tasks dentro da seção
          ImplicitlyAnimatedList<Task>(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            items: section.tasks,
            areItemsTheSame: (a, b) => a.id == b.id,
            itemBuilder: (context, animation, task, index) {
              return SizeFadeTransition(
                animation: animation,
                curve: Curves.easeOut,
                child: Opacity(
                  opacity: dimmed ? 0.6 : 1.0,
                  child: TaskTile(
                    task: task,
                    onNavigateToTaskDetails: (String taskId) async {
                      await onNavigateToTaskDetails(taskId);
                    },
                  ),
                ),
              );
            },
            removeItemBuilder: (context, animation, oldTask) {
              return SizeFadeTransition(
                animation: animation,
                curve: Curves.easeIn,
                child: Opacity(
                  opacity: dimmed ? 0.6 : 1.0,
                  child: TaskTile(
                    task: oldTask,
                    onNavigateToTaskDetails: onNavigateToTaskDetails,
                  ),
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
  }
}
