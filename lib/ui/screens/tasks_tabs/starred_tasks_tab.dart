import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/task_components/no_starred_card.dart';
import 'package:planme/components/task_components/task_section_widget.dart';

class StarredTasksTab extends StatefulWidget {
  final Future<void> Function(String taskId) navigateToTaskDetails;

  const StarredTasksTab({super.key, required this.navigateToTaskDetails});

  @override
  State<StarredTasksTab> createState() => _StarredTasksTabState();
}

class _StarredTasksTabState extends State<StarredTasksTab> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<TasksProvider>(
            builder: (context, tasksProvider, child) {
              final tasksSections = tasksProvider.buildFavoriteTasksSections(
                now: now,
                onlyActives: true,
              );

              if (tasksSections.isEmpty) {
                return const NoStarredCard();
              }

              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
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
                                'Starred Tasks',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Section list
                        ImplicitlyAnimatedList<TaskSection>(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          items: tasksSections,
                          areItemsTheSame: (a, b) => a.label == b.label,
                          itemBuilder:
                              (context, animation, taskSection, index) {
                                final isLast =
                                    index == tasksSections.length - 1;

                                return SizeFadeTransition(
                                  animation: animation,
                                  curve: Curves.easeOut,
                                  child: TaskSectionWidget(
                                    section: taskSection,
                                    isLast: isLast,
                                    onNavigateToTaskDetails:
                                        (String taskId) async {
                                          await widget.navigateToTaskDetails(
                                            taskId,
                                          );
                                        },
                                  ),
                                );
                              },
                          removeItemBuilder:
                              (context, animation, oldTaskSection) {
                                return SizeFadeTransition(
                                  animation: animation,
                                  curve: Curves.easeIn,
                                  child: TaskSectionWidget(
                                    section: oldTaskSection,
                                    isLast: false,
                                    onNavigateToTaskDetails:
                                        (String taskId) async {
                                          await widget.navigateToTaskDetails(
                                            taskId,
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
