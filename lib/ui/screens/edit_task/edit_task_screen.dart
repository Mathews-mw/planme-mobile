import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:planme/@mixins/form_validations_mixin.dart';
import 'package:planme/components/custom_button.dart';
import 'package:planme/components/custom_text_field.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:provider/provider.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/custom_app_bar.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final Task task;

  const EditTaskScreen({super.key, required this.taskId, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen>
    with FormValidationsMixin {
  bool _isLoading = false;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();

    setState(() {
      _formData['title'] = widget.task!.title;
      if (widget.task.description != null) {
        _formData['description'] = widget.task!.description as String;
      }
      if (widget.task.date != null) {
        _pickedDate = DateTime(
          widget.task.date!.year,
          widget.task.date!.month,
          widget.task.date!.day,
        );
      }
      if (widget.task.time != null) {
        _pickedTime = TimeOfDay(
          hour: widget.task.date!.hour,
          minute: widget.task.date!.minute,
        );
      }
    });
  }

  Future<DateTime?> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.deepPurple, // cor dos botões, seleção, etc.
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: AppColors.purpleLight,
            ),
          ),
          child: child!,
        );
      },
    );

    return pickedDate;
  }

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.purpleBase, // cor dos botões/ponteiro
            ),
            timePickerTheme: const TimePickerThemeData(
              dialBackgroundColor: AppColors.purpleLight,
            ),
          ),
          child: child!,
        );
      },
    );

    return pickedTime;
  }

  Future<void> _handleEditTask() async {
    setState(() => _isLoading = true);

    final bool isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please, check the form fields.')),
      );

      return;
    }

    _formKey.currentState?.save();

    try {
      final tasksProvider = Provider.of<TasksProvider>(context, listen: false);

      await tasksProvider.editTask(
        taskId: widget.taskId,
        title: _formData['title'] as String,
        description: _formData['description'] as String?,
        date: _pickedDate,
        time: _pickedTime,
      );

      _formData.clear();
      _pickedDate = null;
      _pickedTime = null;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Task edited successfully')),
        );

        context.pop(
          true,
        ); // return "edited = true" to inform the details screen to reload the data
      }
    } catch (e) {
      print('Create task error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              children: [
                const Text(
                  'Oops! It seems there was an error during the process...',
                ),
                const SizedBox(height: 5),
                Text(e.toString()),
              ],
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _formData.clear();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(title: 'Edit task', showAvatar: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        validator: isNotEmpty,
                        initialValue: widget.task.title,
                        textInputAction: TextInputAction.done,
                        onSaved: (value) {
                          if (value != null) {
                            _formData['title'] = value;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Add details...',
                        minLines: 1,
                        maxLines: 10,
                        initialValue: widget.task.description,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onSaved: (value) {
                          final text = value?.trim();
                          if (text != null) {
                            _formData['description'] = text;
                          }
                        },
                      ),

                      if (_pickedDate != null || _pickedTime != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  // color: AppColors.grayLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.purpleLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if (_pickedDate != null)
                                      Text(
                                        '${DateFormat.yMMMEd().format(_pickedDate!)} ',
                                      ),
                                    if (_pickedTime != null)
                                      Text(
                                        '- ${_pickedTime!.hour.toString().padLeft(2, '0')}:${_pickedTime!.minute.toString().padLeft(2, '0')}',
                                      ),
                                    IconButton(
                                      iconSize: 18,
                                      icon: Icon(Icons.close),
                                      padding: const EdgeInsets.all(0),
                                      tooltip: 'Remove date/time',
                                      onPressed: () {
                                        setState(() {
                                          _pickedDate = null;
                                          _pickedTime = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final picketDate = await _selectDate();

                                  setState(() {
                                    _pickedDate = picketDate;
                                  });
                                },
                                icon: Icon(
                                  PhosphorIcons.calendarDots(),
                                  size: 28,
                                ),
                                tooltip: 'Set date',
                              ),
                              IconButton(
                                onPressed: () async {
                                  final pickedTime = await _selectTime();

                                  setState(() {
                                    _pickedDate ??= DateTime.now();
                                    _pickedTime = pickedTime;
                                  });
                                },
                                icon: Icon(PhosphorIcons.clock(), size: 28),
                                tooltip: 'Set time',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: 'Save',
                  disabled: _isLoading,
                  isLoading: _isLoading,
                  onPressed: _handleEditTask,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
