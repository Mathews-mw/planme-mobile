import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:planme/app_router.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/task_section_widget.dart';

class AllTasksTab extends StatelessWidget {
  const AllTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasksProvider, child) {
        final sections = tasksProvider.allTaskSections;

        if (sections.isEmpty) {
          return const Center(child: Text('No tasks found'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final section = sections[index];
            final isLast = index == sections.length - 1;

            return TaskSectionWidget(
              section: section,
              isLast: isLast,
              onNavigateToTaskDetails: (taskId) async {
                await context.pushNamed(
                  AppRouter.taskDetails,
                  pathParameters: {'taskId': taskId},
                );
              },
            );
          },
        );
      },
    );
  }
}
