import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:planme/app_router.dart';
import 'package:planme/components/no_starred_card.dart';
import 'package:planme/components/no_tasks_card.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/data/models/task.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/ui/screens/starred_tasks/starred_task_tile.dart';
import 'package:provider/provider.dart';

class StarredTasksScreen extends StatefulWidget {
  const StarredTasksScreen({super.key});

  @override
  State<StarredTasksScreen> createState() => _StarredTasksScreenState();
}

class _StarredTasksScreenState extends State<StarredTasksScreen> {
  bool _isLoading = false;

  Future<void> _navigateToTaskDetails(String taskId) async {
    final result = await context.pushNamed<(bool, TaskDetails?)>(
      AppRouter.taskDetails,
      pathParameters: {'taskId': taskId},
    );

    if (!mounted) return;

    if (result != null && result.$1) {
      final deletedTask = result.$2;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task deleted'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              if (deletedTask != null) {
                await context.read<TasksProvider>().restoreTask(deletedTask);
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      extendBody: true,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading tasks...'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Consumer<TasksProvider>(
                  builder: (context, tasksProvider, child) {
                    final starredTasks = tasksProvider.starredTasks;

                    if (starredTasks.isEmpty) {
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
                                      'Starred Tasks',
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

                              // Active tasks list
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12),
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
                                child: ImplicitlyAnimatedList<Task>(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  items: starredTasks,
                                  areItemsTheSame: (a, b) => a.id == b.id,
                                  itemBuilder:
                                      (context, animation, tasks, index) {
                                        return SizeFadeTransition(
                                          animation: animation,
                                          curve: Curves.easeOut,
                                          child: StarredTaskTile(
                                            task: tasks,
                                            onNavigateToTaskDetails:
                                                (String taskId) async {
                                                  await _navigateToTaskDetails(
                                                    taskId,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                  removeItemBuilder:
                                      (context, animation, oldTask) {
                                        return SizeFadeTransition(
                                          animation: animation,
                                          curve: Curves.easeIn,
                                          child: StarredTaskTile(
                                            task: oldTask,
                                            onNavigateToTaskDetails:
                                                (String taskId) async {
                                                  await _navigateToTaskDetails(
                                                    taskId,
                                                  );
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
