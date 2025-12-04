import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import 'package:planme/theme/app_colors.dart';
import 'package:planme/providers/tasks_provider.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/domains/agenda/agenda_range_filter.dart';
import 'package:planme/components/task_components/no_tasks_card.dart';
import 'package:planme/ui/screens/tasks_tabs/completed_tasks_section.dart';
import 'package:planme/components/task_components/task_section_widget.dart';
import 'package:planme/components/task_components/all_tasks_completed_card.dart';

class AgendaTab extends StatefulWidget {
  final Future<void> Function(String taskId) navigateToTaskDetails;

  const AgendaTab({super.key, required this.navigateToTaskDetails});

  @override
  State<AgendaTab> createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  AgendaRangeFilter _selectedFilter = AgendaRangeFilter.next7Days;
  DateTimeRange? _customRange;
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  /// Constrói o range atual com base no filtro selecionado
  DateTimeRange _buildRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedFilter == AgendaRangeFilter.custom && _customRange != null) {
      return _customRange!;
    }

    final days = _selectedFilter.days ?? 7; // fallback
    final end = today.add(Duration(days: days));

    return DateTimeRange(start: today, end: end);
  }

  /// Label amigável pro botão "Custom"
  String get _customLabel {
    if (_selectedFilter != AgendaRangeFilter.custom || _customRange == null) {
      return 'Custom';
    }

    final start = _customRange!.start;
    final end = _customRange!.end;
    final fmt = DateFormat('MMM d');

    return '${fmt.format(start)} - ${fmt.format(end)}';
  }

  Future<void> _handleFilterChange(AgendaRangeFilter filter) async {
    // Se for um preset (7/15/30/60), só troca o filtro
    if (filter != AgendaRangeFilter.custom) {
      setState(() {
        _selectedFilter = filter;
        // não mexe no _customRange, deixa guardado pro usuário voltar depois se quiser
      });

      return;
    }

    // Se for Custom, abre o DateRangePicker
    final now = DateTime.now();

    final initialRange =
        _customRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: DateTime(
            now.year,
            now.month,
            now.day,
          ).add(const Duration(days: 7)),
        );

    final picked = await showDateRangePicker(
      context: context,
      barrierColor: AppColors.darkBackground,
      initialDateRange: initialRange,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      helpText: 'Select an interval',
      builder: (BuildContext context, Widget? child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            // Esquema de cores geral do picker
            colorScheme: theme.colorScheme.copyWith(
              primary:
                  AppColors.purpleBase, // cor principal (seleção, botão OK)
              onPrimary: Colors.white, // texto por cima do primary
              surface: AppColors.lightBackground, // fundo de cards/dialogos
              onSurface: AppColors.gray800, // textos
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),

            // Tema mais específico do date picker (Material 3)
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.lightBackground,
              headerBackgroundColor: AppColors.purpleBase,
              headerForegroundColor: AppColors.lightBackground,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return AppColors.gray800;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.purpleBase;
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.purpleLight.withValues(alpha: 0.2);
                }
                return Colors.transparent;
              }),
              rangePickerBackgroundColor: AppColors.lightBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedFilter = AgendaRangeFilter.custom;
        _customRange = picked;
      });
    } else {
      // Se o usuário cancelou e ainda não tinha range custom,
      // mantém o filtro anterior pra não ficar "Custom" vazio.
      if (_customRange == null) {
        // não muda _selectedFilter
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final range = _buildRange();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<TasksProvider>(
            builder: (context, tasksProvider, child) {
              final tasksSections = tasksProvider.buildAgendaSections(
                rangeStart: range.start,
                rangeEnd: range.end,
              );
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
                        // --- Header & Date filters
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Show the next',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              MenuAnchor(
                                style: MenuStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    AppColors.lightBackground,
                                  ),
                                  elevation: const WidgetStatePropertyAll(8),
                                  minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(90, 0),
                                  ),
                                ),
                                childFocusNode: _buttonFocusNode,
                                menuChildren: AgendaRangeFilter.values.map((
                                  item,
                                ) {
                                  return MenuItemButton(
                                    onPressed: () {
                                      setState(() => _selectedFilter = item);
                                      _handleFilterChange(item);
                                    },
                                    child: Text(item.label),
                                  );
                                }).toList(),
                                builder:
                                    (
                                      _,
                                      MenuController controller,
                                      Widget? child,
                                    ) {
                                      return TextButton.icon(
                                        focusNode: _buttonFocusNode,
                                        iconAlignment: IconAlignment.end,
                                        style: ButtonStyle().copyWith(
                                          foregroundColor:
                                              WidgetStateProperty.all<Color>(
                                                AppColors.gray700,
                                              ),
                                        ),
                                        icon: const Icon(
                                          Icons.swap_vert,
                                          size: 20,
                                        ),
                                        label: Text(
                                          _selectedFilter.days != null
                                              ? _selectedFilter.label
                                              : _customLabel,
                                        ),
                                        onPressed: () {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        },
                                      );
                                    },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        if (tasksSections.isEmpty && completedTasks.isNotEmpty)
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
                                          await widget.navigateToTaskDetails(
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
                                          await widget.navigateToTaskDetails(
                                            taskId,
                                          );
                                        },
                                  ),
                                );
                              },
                          removeDuration: const Duration(milliseconds: 300),
                          insertDuration: const Duration(milliseconds: 300),
                          updateDuration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Completed tasks section
                  CompletedTasksSection(completedTasks: completedTasks),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
