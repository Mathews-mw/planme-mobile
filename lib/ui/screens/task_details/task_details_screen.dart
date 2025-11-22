import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:planme/data/models/task.dart';
import 'package:planme/providers/tasks_provider.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/components/custom_button.dart';
import 'package:planme/components/custom_app_bar.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Future<Task>? _taskDetails;

  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void initState() {
    super.initState();

    _taskDetails = getTaskDetails(context, widget.taskId);
  }

  Future<Task> getTaskDetails(BuildContext context, String taskId) async {
    final taskDetails = Provider.of<TasksProvider>(
      context,
      listen: false,
    ).getTaskDetails(taskId);

    return taskDetails;
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? _pickedDate = DateTime.now();
    final TimeOfDay? _pickedTime = TimeOfDay.now();

    return FutureBuilder(
      future: _taskDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading task details...'),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return const Center(
            child: Text('Task not found!', textAlign: TextAlign.center),
          );
        }

        final taskDetails = snapshot.data!;

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          appBar: CustomAppBar(
            title: 'Task Details',
            showAvatar: false,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(PhosphorIcons.star())),
              MenuAnchor(
                style: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.lightBackground,
                  ),
                  elevation: const WidgetStatePropertyAll(8),
                ),
                childFocusNode: _buttonFocusNode,
                menuChildren: <Widget>[
                  MenuItemButton(
                    leadingIcon: Icon(PhosphorIcons.pencilSimpleLine()),
                    onPressed: () {},
                    child: const Text('Edit'),
                  ),
                  MenuItemButton(
                    leadingIcon: Icon(PhosphorIcons.trash()),
                    style: ButtonStyle(
                      foregroundColor: const WidgetStatePropertyAll(Colors.red),
                      iconColor: const WidgetStatePropertyAll(Colors.red),
                      overlayColor: WidgetStatePropertyAll(
                        Colors.red.withValues(alpha: 0.06),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Delete'),
                  ),
                ],
                builder: (_, MenuController controller, Widget? child) {
                  return IconButton(
                    focusNode: _buttonFocusNode,
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.more_vert),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.note(),
                          color: AppColors.purpleBase,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'English Class',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    ),
                    const SizedBox(height: 20),

                    if (_pickedDate != null || _pickedTime != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.purpleLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom: 0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.calendarCheck(),
                                    color: AppColors.purpleBase,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Date and Time',
                                    style: TextStyle(color: AppColors.gray500),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: AppColors.purpleLight),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  if (_pickedDate != null)
                                    Text(
                                      '${DateFormat.yMMMEd().format(_pickedDate!)} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (_pickedTime != null)
                                    Text(
                                      '- ${_pickedTime!.hour.toString().padLeft(2, '0')}:${_pickedTime!.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.purpleLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                              bottom: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.library_add,
                                      color: AppColors.purpleBase,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Subtasks (9)',
                                      style: TextStyle(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  variant: Variant.muted,
                                  label: 'Add subtask',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.purpleLight),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                final isCompleted = false;

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: isCompleted
                                        ? Icon(
                                            Icons.check,
                                            size: 20,
                                            color: AppColors.purpleBase,
                                          )
                                        : Icon(
                                            Icons.radio_button_unchecked,
                                            size: 20,
                                          ),
                                    tooltip: 'Mark task as uncompleted',
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.close, size: 20),
                                    tooltip: 'Remove subtask',
                                  ),
                                  title: Text('Task title'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
