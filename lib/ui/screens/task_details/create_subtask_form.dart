import 'package:flutter/material.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/components/custom_button.dart';
import 'package:planme/components/custom_text_field.dart';

class CreateSubtaskForm extends StatefulWidget {
  final Future<void> Function(String data) onSubmitForm;

  const CreateSubtaskForm({super.key, required this.onSubmitForm});

  @override
  State<CreateSubtaskForm> createState() => _CreateSubtaskFormState();
}

class _CreateSubtaskFormState extends State<CreateSubtaskForm> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      variant: Variant.muted,
      label: 'Add subtask',
      onPressed: () async {
        final result = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            final formKey = GlobalKey<FormState>();
            final controller = TextEditingController();

            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('New Subtask'),
              content: Form(
                key: formKey,
                child: CustomTextField(
                  hintText: 'New subtask title...',
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
                      Navigator.of(dialogContext).pop(controller.text.trim());
                    }
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 18, color: AppColors.gray500),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(dialogContext).pop(controller.text.trim());
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: AppColors.purpleBase),
                  ),
                ),
              ],
            );
          },
        );

        if (result != null && result.isNotEmpty) {
          await widget.onSubmitForm(result);
        }
      },
    );
  }
}
