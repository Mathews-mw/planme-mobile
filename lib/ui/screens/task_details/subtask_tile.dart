import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/data/models/sub_task.dart';
import 'package:planme/components/custom_text_field.dart';

class SubtaskTile extends StatefulWidget {
  final SubTask subtask;
  final Future<void> Function(String data) onEditSubtask;
  final Future<void> Function() onDeleteSubtask;

  const SubtaskTile({
    super.key,
    required this.subtask,
    required this.onEditSubtask,
    required this.onDeleteSubtask,
  });

  @override
  State<SubtaskTile> createState() => _SubtaskTileState();
}

class _SubtaskTileState extends State<SubtaskTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              final result = await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  final formKey = GlobalKey<FormState>();
                  final controller = TextEditingController();

                  controller.text = widget.subtask.title;

                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Edit subtask'),
                    content: Form(
                      key: formKey,
                      child: CustomTextField(
                        controller: controller,
                        textInputAction: TextInputAction.done,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required field. Please, fill it in.';
                          }

                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(
                              dialogContext,
                            ).pop(controller.text.trim());
                          }
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(
                              dialogContext,
                            ).pop(controller.text.trim());
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.purpleBase,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (result != null && result.isNotEmpty) {
                await widget.onEditSubtask(result);
              }
            },
            icon: PhosphorIcons.pencilSimpleLine(),
            backgroundColor: AppColors.purpleLight,
            foregroundColor: AppColors.purpleBase,
          ),
          SlidableAction(
            icon: PhosphorIcons.trash(),
            backgroundColor: Color.fromRGBO(239, 68, 68, 0.2),
            foregroundColor: AppColors.dangerBase,
            onPressed: (context) async {
              final result = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Subtask'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Are you sure you want to delete this task?'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: AppColors.dangerBase),
                      ),
                    ),
                  ],
                ),
              );

              if (result != null && result) {
                await widget.onDeleteSubtask();
              }
            },
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
          onPressed: () {},
          icon: widget.subtask.isCompleted
              ? Icon(Icons.check, size: 20, color: AppColors.purpleBase)
              : Icon(Icons.radio_button_unchecked, size: 20),
          tooltip: 'Mark task as uncompleted',
        ),
        title: Text(widget.subtask.title),
      ),
    );
  }
}
