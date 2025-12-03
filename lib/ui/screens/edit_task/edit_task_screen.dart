import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/data/models/task.dart';
import 'package:planme/components/custom_button.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/custom_text_field.dart';
import 'package:planme/components/custom_dropdown_button.dart';
import 'package:planme/domains/recurrence/models/recurrence_end.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final Task task;

  const EditTaskScreen({super.key, required this.taskId, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  RecurrenceType _recurrenceType = RecurrenceType.none;

  // Campos específicos de recorrência
  int _intervalDays = 1;
  Set<int> _weeklyWeekdays = {};
  int _monthlyDayOfMonth = 1;
  int _monthlyWeekOfMonth = 1; // 1..4, -1 = last
  int _monthlyWeekdayOfMonth = DateTime.monday;
  int _yearlyIntervalYears = 1;

  RecurrenceEndType _recurrenceEndType = RecurrenceEndType.never;
  DateTime? _recurrenceEndDate;
  int _recurrenceEndCount = 10;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );

    _initFromTask(widget.task);
  }

  void _initFromTask(Task task) {
    // baseDateTime -> date/time
    if (task.baseDateTime != null) {
      final dt = task.baseDateTime!;

      _selectedDate = DateTime(dt.year, dt.month, dt.day);
      _selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
    }

    // recurrence
    if (task.recurrence != null) {
      final rule = task.recurrence!;
      _recurrenceType = rule.type;

      switch (rule.type) {
        case RecurrenceType.intervalDays:
          _intervalDays = rule.interval ?? 1;
          break;

        case RecurrenceType.weekly:
          _weeklyWeekdays = {...(rule.weekdays ?? {})};
          break;

        case RecurrenceType.monthlyDayOfMonth:
          _monthlyDayOfMonth = rule.dayOfMonth ?? 1;
          break;

        case RecurrenceType.monthlyWeekdayOfMonth:
          _monthlyWeekOfMonth = rule.weekOfMonth ?? 1;
          _monthlyWeekdayOfMonth = rule.weekdayOfMonth ?? DateTime.monday;
          break;

        case RecurrenceType.yearly:
          _yearlyIntervalYears = rule.interval ?? 1;
          break;

        case RecurrenceType.none:
          break;
      }

      // RecurrenceEnd
      final end = rule.end;

      _recurrenceEndType = end.type;
      _recurrenceEndDate = end.untilDate;
      _recurrenceEndCount = end.maxOccurrences ?? 10;
    } else {
      _recurrenceType = RecurrenceType.none;
      _recurrenceEndType = RecurrenceEndType.never;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime? _combineDateAndTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  RecurrenceEnd _buildRecurrenceEnd() {
    switch (_recurrenceEndType) {
      case RecurrenceEndType.never:
        return const RecurrenceEnd.never();
      case RecurrenceEndType.onDate:
        if (_recurrenceEndDate != null) {
          return RecurrenceEnd.onDate(_recurrenceEndDate!);
        }
        return const RecurrenceEnd.never();
      case RecurrenceEndType.afterCount:
        return RecurrenceEnd.afterCount(_recurrenceEndCount);
    }
  }

  RecurrenceRule? _buildRecurrenceRule(DateTime baseDateTime) {
    if (_recurrenceType == RecurrenceType.none) return null;

    final end = _buildRecurrenceEnd();

    switch (_recurrenceType) {
      case RecurrenceType.intervalDays:
        return RecurrenceRule(
          type: RecurrenceType.intervalDays,
          start: baseDateTime,
          interval: _intervalDays,
          end: end,
        );

      case RecurrenceType.weekly:
        if (_weeklyWeekdays.isEmpty) return null;
        return RecurrenceRule(
          type: RecurrenceType.weekly,
          start: baseDateTime,
          weekdays: _weeklyWeekdays,
          end: end,
        );

      case RecurrenceType.monthlyDayOfMonth:
        return RecurrenceRule(
          type: RecurrenceType.monthlyDayOfMonth,
          start: baseDateTime,
          dayOfMonth: _monthlyDayOfMonth,
          end: end,
        );

      case RecurrenceType.monthlyWeekdayOfMonth:
        return RecurrenceRule(
          type: RecurrenceType.monthlyWeekdayOfMonth,
          start: baseDateTime,
          weekOfMonth: _monthlyWeekOfMonth,
          weekdayOfMonth: _monthlyWeekdayOfMonth,
          end: end,
        );

      case RecurrenceType.yearly:
        return RecurrenceRule(
          type: RecurrenceType.yearly,
          start: baseDateTime,
          interval: _yearlyIntervalYears,
          end: end,
        );

      case RecurrenceType.none:
        return null;
    }
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final baseDateTime = _combineDateAndTime(_selectedDate, _selectedTime);

    if (_recurrenceType != RecurrenceType.none && baseDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('To save a recurring task, select date and time.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final tasksProvider = context.read<TasksProvider>();

      final recurrence = baseDateTime != null
          ? _buildRecurrenceRule(baseDateTime)
          : null;

      final updatedTask = widget.task.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        baseDateTime: baseDateTime,
        recurrence: recurrence,
        updatedAt: DateTime.now(),
      );

      await tasksProvider.editTask(updatedTask);

      if (!mounted) return;

      context.pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Task updated successfully'),
        ),
      );
    } catch (e) {
      debugPrint('Edit task error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating task: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // ==== UI helpers de recorrência ====
  Widget _buildRecurrenceTypeSelector() {
    return CustomDropdownButton<RecurrenceType>(
      value: _recurrenceType,
      items: const [
        DropdownMenuItem(
          value: RecurrenceType.none,
          child: Text('Do not repeat'),
        ),
        DropdownMenuItem(
          value: RecurrenceType.intervalDays,
          child: Text('Every X days'),
        ),
        DropdownMenuItem(
          value: RecurrenceType.weekly,
          child: Text('On specific weekdays'),
        ),
        DropdownMenuItem(
          value: RecurrenceType.monthlyDayOfMonth,
          child: Text('Monthly on day X'),
        ),
        DropdownMenuItem(
          value: RecurrenceType.monthlyWeekdayOfMonth,
          child: Text('Monthly on weekday/week'),
        ),
        DropdownMenuItem(
          value: RecurrenceType.yearly,
          child: Text('Every X years'),
        ),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() => _recurrenceType = value);
      },
    );
  }

  Widget _buildRecurrenceEndSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'End of repetition',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        RadioGroup<RecurrenceEndType>(
          groupValue: _recurrenceEndType,
          onChanged: (value) async {
            if (value == null) return;

            if (value == RecurrenceEndType.onDate) {
              final now = DateTime.now();

              final picked = await showDatePicker(
                context: context,
                initialDate: _recurrenceEndDate ?? now,
                firstDate: now,
                lastDate: DateTime(now.year + 10),
              );

              if (picked != null) {
                setState(() {
                  _recurrenceEndDate = picked;
                });
              }
            }

            setState(() => _recurrenceEndType = value);
          },
          child: Column(
            children: [
              RadioListTile<RecurrenceEndType>(
                dense: true,
                activeColor: AppColors.purpleBase,
                contentPadding: EdgeInsets.zero,
                value: RecurrenceEndType.never,
                title: const Text('Never'),
              ),
              RadioListTile<RecurrenceEndType>(
                dense: true,
                activeColor: AppColors.purpleBase,
                contentPadding: EdgeInsets.zero,
                value: RecurrenceEndType.onDate,
                title: Row(
                  children: [
                    const Text('On date'),
                    const SizedBox(width: 8),
                    if (_recurrenceEndDate != null)
                      Text(
                        DateFormat.yMMMd().format(_recurrenceEndDate!),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              RadioListTile<RecurrenceEndType>(
                dense: true,
                activeColor: AppColors.purpleBase,
                contentPadding: EdgeInsets.zero,
                value: RecurrenceEndType.afterCount,
                title: Row(
                  children: [
                    const Text('After'),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 36,
                      child: TextFormField(
                        initialValue: _recurrenceEndCount.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final number = int.tryParse(value);

                            if (number == null || number < 1) {
                              return 'The value must be between 1 and 999';
                            }
                          }

                          return null;
                        },
                        onChanged: (value) {
                          final parsed = int.tryParse(value);
                          if (parsed != null && parsed > 0) {
                            _recurrenceEndCount = parsed;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Times'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChips() {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final weekday = index + 1; // 1..7
        final isSelected = _weeklyWeekdays.contains(weekday);

        return ChoiceChip(
          label: Text(labels[index]),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _weeklyWeekdays.add(weekday);
              } else {
                _weeklyWeekdays.remove(weekday);
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildRecurrenceDetails() {
    if (_recurrenceType == RecurrenceType.none) {
      return const SizedBox.shrink();
    }

    switch (_recurrenceType) {
      case RecurrenceType.intervalDays:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Repeat every $_intervalDays day(s)'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Every'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: TextFormField(
                    initialValue: _intervalDays.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final number = int.tryParse(value);

                        if (number == null || number < 1) {
                          return 'The value must be between 1 and 999';
                        }
                      }

                      return null;
                    },
                    onChanged: (value) {
                      final parsed = int.tryParse(value);

                      if (parsed != null) {
                        if (parsed == 0) {
                          setState(() => _intervalDays = 1);
                        } else {
                          setState(() => _intervalDays = parsed);
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('day(s)'),
              ],
            ),
          ],
        );

      case RecurrenceType.weekly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Repeat on weekdays'),
            const SizedBox(height: 8),
            _buildWeeklyChips(),
          ],
        );

      case RecurrenceType.monthlyDayOfMonth:
        return Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 0, bottom: 0),
          child: Row(
            children: [
              const Text('Repeat monthly on day'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                isDense: true,
                dropdownColor: AppColors.lightBackground,
                menuMaxHeight: 350,
                value: _monthlyDayOfMonth,
                items: List.generate(31, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  if (value == null) return;

                  if (value >= 1 && value <= 31) {
                    setState(() => _monthlyDayOfMonth = value);
                  }
                },
              ),
            ],
          ),
        );

      case RecurrenceType.monthlyWeekdayOfMonth:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Repeat monthly on'),
            const SizedBox(height: 8),
            Row(
              children: [
                DropdownButton<int>(
                  dropdownColor: AppColors.lightBackground,
                  value: _monthlyWeekOfMonth,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1st')),
                    DropdownMenuItem(value: 2, child: Text('2nd')),
                    DropdownMenuItem(value: 3, child: Text('3rd')),
                    DropdownMenuItem(value: 4, child: Text('4th')),
                    DropdownMenuItem(value: -1, child: Text('Last')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _monthlyWeekOfMonth = value);
                    }
                  },
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  dropdownColor: AppColors.lightBackground,
                  value: _monthlyWeekdayOfMonth,
                  items: const [
                    DropdownMenuItem(
                      value: DateTime.monday,
                      child: Text('Monday'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.tuesday,
                      child: Text('Tuesday'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.wednesday,
                      child: Text('Wednesday'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.thursday,
                      child: Text('Thursday'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.friday,
                      child: Text('Friday'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.saturday,
                      child: Text('Saturday'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.sunday,
                      child: Text('Sunday'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _monthlyWeekdayOfMonth = value);
                    }
                  },
                ),
              ],
            ),
          ],
        );

      case RecurrenceType.yearly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Repeat every $_yearlyIntervalYears years'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Every'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: TextFormField(
                    initialValue: _yearlyIntervalYears.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final number = int.tryParse(value);

                        if (number == null || number < 1) {
                          return 'The value must be between 1 and 999';
                        }
                      }

                      return null;
                    },
                    onChanged: (value) {
                      final parsed = int.tryParse(value);

                      if (parsed != null && parsed > 0) {
                        setState(() {
                          _yearlyIntervalYears = parsed;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('year(s)'),
              ],
            ),
          ],
        );

      case RecurrenceType.none:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate != null
        ? DateFormat.yMMMd().format(_selectedDate!)
        : 'Select date';

    final timeText = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'Select time';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: const Text('Edit task'),
      ),
      body: SafeArea(
        child: Padding(
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
                          controller: _titleController,
                          hintText: 'Task title',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _descriptionController,
                          hintText: 'Add details (optional)...',
                          minLines: 1,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: AppColors.purpleBase,
                                ),
                                label: Text(
                                  dateText,
                                  style: TextStyle(color: AppColors.purpleBase),
                                ),
                                onPressed: _pickDate,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  Icons.schedule,
                                  size: 18,
                                  color: AppColors.purpleBase,
                                ),
                                label: Text(
                                  timeText,
                                  style: TextStyle(color: AppColors.purpleBase),
                                ),
                                onPressed: _pickTime,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Repeat',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),

                        // Recurrence
                        _buildRecurrenceTypeSelector(),
                        const SizedBox(height: 8),
                        _buildRecurrenceDetails(),
                        if (_recurrenceType != RecurrenceType.none) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildRecurrenceEndSection(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: _isSubmitting ? 'Saving...' : 'Save changes',
                      onPressed: _handleSubmit,
                      isLoading: _isSubmitting,
                      disabled: _isSubmitting,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
