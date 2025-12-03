import 'package:flutter/material.dart';
import 'package:planme/components/task_components/no_tasks_card.dart';
import 'package:provider/provider.dart';

import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/ui/screens/tasks_tabs/completed_tasks_section.dart';
import 'package:planme/components/task_components/task_section_widget.dart';

class AllTasksTab extends StatelessWidget {
  final Future<void> Function(String taskId) navigateToTaskDetails;

  const AllTasksTab({super.key, required this.navigateToTaskDetails});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SingleChildScrollView(
      child: Consumer<TasksProvider>(
        builder: (context, tasksProvider, child) {
          final sections = tasksProvider.buildAllTaskSections(
            now: now,
            onlyActives: true,
          );
          final completedTasks = tasksProvider.completedTasks;

          if (sections.isEmpty && completedTasks.isEmpty) {
            return const NoTasksCard();
          }

          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                margin: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.swap_vert),
                          onPressed: () {},
                          tooltip: 'Sort',
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                          tooltip: 'More options',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Tasks list Section
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final isLast = index == sections.length - 1;

                  return TaskSectionWidget(
                    section: section,
                    isLast: isLast,
                    onNavigateToTaskDetails: navigateToTaskDetails,
                  );
                },
              ),

              const SizedBox(height: 4),

              // Completed tasks section
              CompletedTasksSection(completedTasks: completedTasks),
            ],
          );
        },
      ),
    );
  }
}
