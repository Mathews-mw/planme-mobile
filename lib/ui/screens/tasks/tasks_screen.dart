import 'package:flutter/material.dart';
import 'package:planme/ui/screens/tasks/all_tasks_completed_card.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/components/custom_app_bar.dart';
import 'package:planme/ui/screens/tasks/task_section.dart';
import 'package:planme/ui/screens/tasks/no_tasks_card.dart';
import 'package:planme/ui/screens/tasks/completed_task_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(title: 'Tasks'),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text('Loading tasks...'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Consumer<TasksProvider>(
                  builder: (context, tasksProvider, child) {
                    final tasksSections = tasksProvider.taskSections;
                    final completedTasks = tasksProvider.completedTasks;

                    if (tasksSections.isEmpty && completedTasks.isEmpty) {
                      return const NoTasksCard();
                    }

                    return Column(
                      children: [
                        // Active tasks section
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
                                  vertical: 4,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'My Tasks',
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

                              if (tasksSections.isEmpty &&
                                  completedTasks.isNotEmpty)
                                const AllTasksCard(),

                              // Active tasks list
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
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Completed tasks section
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: completedTasks.isEmpty
                              ? SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.1,
                                        ),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
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
                                      'Completed Tasks (${completedTasks.length})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    collapsed: Text(
                                      'See completed tasks',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.gray500,
                                      ),
                                    ),

                                    // Completed tasks list
                                    expanded: ImplicitlyAnimatedList<Task>(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      items: completedTasks,
                                      areItemsTheSame: (a, b) => a.id == b.id,
                                      itemBuilder:
                                          (context, animation, tasks, index) {
                                            return SizeFadeTransition(
                                              animation: animation,
                                              curve: Curves.easeOut,
                                              child: CompletedTaskTile(
                                                task: tasks,
                                              ),
                                            );
                                          },
                                      removeItemBuilder:
                                          (context, animation, oldTask) {
                                            return SizeFadeTransition(
                                              animation: animation,
                                              curve: Curves.easeIn,
                                              child: CompletedTaskTile(
                                                task: oldTask,
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
