import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/components/task_components/completed_task_tile.dart';

class CompletedTasksSection extends StatelessWidget {
  final List<Task> completedTasks;

  const CompletedTasksSection({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: completedTasks.isEmpty
          ? SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
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
              child: ExpandablePanel(
                theme: ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: true,
                ),
                header: Text(
                  'Completed Tasks (${completedTasks.length})',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                  physics: const NeverScrollableScrollPhysics(),
                  items: completedTasks,
                  areItemsTheSame: (a, b) => a.id == b.id,
                  itemBuilder: (context, animation, tasks, index) {
                    return SizeFadeTransition(
                      animation: animation,
                      curve: Curves.easeOut,
                      child: CompletedTaskTile(task: tasks),
                    );
                  },
                  removeItemBuilder: (context, animation, oldTask) {
                    return SizeFadeTransition(
                      animation: animation,
                      curve: Curves.easeIn,
                      child: CompletedTaskTile(task: oldTask),
                    );
                  },
                  removeDuration: const Duration(milliseconds: 300),
                  insertDuration: const Duration(milliseconds: 300),
                  updateDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
    );
  }
}
