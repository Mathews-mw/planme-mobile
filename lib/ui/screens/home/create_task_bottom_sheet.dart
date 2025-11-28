import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/theme/app_colors.dart';
import 'package:planme/components/custom_button.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/components/custom_text_field.dart';
import 'package:planme/@mixins/form_validations_mixin.dart';
import 'package:planme/components/custom_dropdown_button.dart';
import 'package:planme/domains/recurrence/models/recurrence_end.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({super.key});

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet>
    with FormValidationsMixin {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  RecurrenceType _recurrenceType = RecurrenceType.none;

  // Campos específicos de recorrência
  int _intervalDays = 1; // intervalDays / yearly
  Set<int> _weeklyWeekdays = {}; // weekly
  int _monthlyDayOfMonth = 1; // monthlyDayOfMonth
  int _monthlyWeekOfMonth = 1; // monthlyWeekdayOfMonth (1..4 ou -1 = last)
  int _monthlyWeekdayOfMonth = DateTime.monday; // 1..7
  int _yearlyIntervalYears = 1;

  RecurrenceEndType _recurrenceEndType = RecurrenceEndType.never;
  DateTime? _recurrenceEndDate;
  int _recurrenceEndCount = 10;

  bool _isSubmitting = false;

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
        if (_weeklyWeekdays.isEmpty) {
          // se não marcar nenhum dia, não faz sentido
          return null;
        }

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

    // se for recorrente, precisa pelo menos de data+hora
    final baseDateTime = _combineDateAndTime(_selectedDate, _selectedTime);

    if (_recurrenceType != RecurrenceType.none && baseDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('To create a recurring task, select date and time.'),
        ),
      );

      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final tasksProvider = context.read<TasksProvider>();

      final now = DateTime.now();

      final recurrence = baseDateTime != null
          ? _buildRecurrenceRule(baseDateTime)
          : null;

      final task = Task(
        id: Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        baseDateTime: baseDateTime,
        isStarred: false,
        createdAt: now,
        recurrence: recurrence,
      );

      await tasksProvider.createTask(task);

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Task created successfully'),
        ),
      );
    } catch (e) {
      debugPrint('Create task error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating task: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

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
    // DateTime.monday = 1 ... sunday = 7
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final weekday = index + 1;
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

                      return null; // Válido
                    },
                    onChanged: (value) {
                      final parsed = int.tryParse(value);

                      if (parsed != null) {
                        if (parsed == 0) {
                          _intervalDays = 1;
                        } else {
                          _intervalDays = parsed;
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
        return Row(
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
                        _yearlyIntervalYears = parsed;
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    final dateText = _selectedDate != null
        ? DateFormat.yMMMd().format(_selectedDate!)
        : 'Select date';

    final timeText = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'Select time';

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle e título
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New task',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
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

                    // Description
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: 'Add details (optional)...',
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),

                    // Date / time row
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

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: _isSubmitting ? 'Saving...' : 'Save task',
                            onPressed: _handleSubmit,
                            disabled: _isSubmitting,
                            isLoading: _isSubmitting,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
