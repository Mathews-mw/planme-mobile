import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/components/task_tile.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/data/models/task_occurrence.dart';

class TaskSectionWidget extends StatelessWidget {
  final TaskSection section;
  final bool isLast;
  final Future<void> Function(String taskId) onNavigateToTaskDetails;

  const TaskSectionWidget({
    super.key,
    required this.section,
    required this.isLast,
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
          // label da seção (data)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              section.label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Lista animada de occurrences dentro da seção
          ImplicitlyAnimatedList<TaskOccurrence>(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            items: section.items,
            areItemsTheSame: (a, b) {
              if (a.task.id != b.task.id) return false;

              final aDate = a.scheduledAt;
              final bDate = b.scheduledAt;

              if (aDate == null && bDate == null) return true;
              if (aDate == null || bDate == null) return false;

              return aDate.isAtSameMomentAs(bDate);
            },
            itemBuilder: (context, animation, occurrence, index) {
              return SizeFadeTransition(
                animation: animation,
                curve: Curves.easeOut,
                child: TaskTile(
                  task: occurrence.task,
                  scheduledAt: occurrence.scheduledAt,
                  onNavigateToTaskDetails: onNavigateToTaskDetails,
                ),
              );
            },
            removeItemBuilder: (context, animation, oldOccurrence) {
              return SizeFadeTransition(
                animation: animation,
                curve: Curves.easeIn,
                child: TaskTile(
                  task: oldOccurrence.task,
                  onNavigateToTaskDetails: onNavigateToTaskDetails,
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
