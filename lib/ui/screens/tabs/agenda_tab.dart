import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:expandable/expandable.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/app_router.dart';
import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/components/no_tasks_card.dart';
import 'package:planme/components/task_section_widget.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/components/all_tasks_completed_card.dart';
import 'package:planme/ui/screens/tabs/components/completed_task_tile.dart';

class AgendaTab extends StatefulWidget {
  const AgendaTab({super.key});

  @override
  State<AgendaTab> createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  bool _isLoading = false;
  late DateTime _rangeStart;
  late DateTime _rangeEnd;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _rangeStart = DateTime(now.year, now.month, now.day); // hoje 00:00
    _rangeEnd = _rangeStart.add(const Duration(days: 7)); // próximos 7 dias

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasksForCurrentRange();
    });
  }

  Future<void> _loadTasksForCurrentRange() async {
    setState(() => _isLoading = true);

    try {
      final tasksProvider = context.read<TasksProvider>();

      await tasksProvider.loadTaskSectionsForRange(
        from: _rangeStart,
        to: _rangeEnd,
      );
    } catch (e) {
      debugPrint('Error loading tasks sections: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading tasks')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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

    // se você quiser recarregar depois de voltar (por caso de edição),
    // pode chamar _loadTasksForCurrentRange() de novo aqui.
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
                    final tasksSections = tasksProvider.taskSections;
                    final completedTasks = tasksProvider.completedTasks;

                    if (tasksSections.isEmpty && completedTasks.isEmpty) {
                      return const NoTasksCard();
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
                              // Header "My Tasks"
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
                                                await _navigateToTaskDetails(
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
