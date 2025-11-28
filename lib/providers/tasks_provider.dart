import 'package:intl/intl.dart';
import 'package:planme/data/models/task_with_next_occurrence.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/providers/subtasks_provider.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/domains/recurrence/recurrence_generator.dart';
import 'package:planme/domains/recurrence/models/recurrence_end.dart';
import 'package:planme/data/models/task_occurrence.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';
import 'package:planme/domains/recurrence/models/recurrence_type.dart';
import 'package:planme/ui/screens/task_details/task_details_state.dart';

class TasksProvider with ChangeNotifier {
  final SubtasksProvider subtasksProvider;

  TasksProvider({required this.subtasksProvider});

  final uuid = Uuid();

  // List<Task> _tasks = [];
  final List<Task> _tasks = [
    Task(
      id: Uuid().v4(),
      title: 'Tomar remédio',
      baseDateTime: DateTime.now(),
      isStarred: true,
      createdAt: DateTime.now(),
      recurrence: RecurrenceRule(
        type: RecurrenceType.intervalDays,
        start: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          8,
          0,
        ),
        interval: 5,
        end: const RecurrenceEnd.afterCount(36),
      ),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Cancelar gamepass',
      description: 'Cancelar a assinatura do gamepass.',
      baseDateTime: DateTime(2025, 12, 10, 10, 15),
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Comprar presente',
      description: 'Comprar o presente do evento.',
      baseDateTime: DateTime(2025, 12, 10, 14, 30),
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Ir ao evento',
      description: 'Chegou a hora de ir para o evento.',
      baseDateTime: DateTime(2025, 12, 10, 20, 0),
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Renovar certificado anual',
      baseDateTime: DateTime(2026, 9, 22),
      createdAt: DateTime.now(),
      recurrence: RecurrenceRule(
        type: RecurrenceType.intervalDays,
        start: DateTime(2025, 28, 11, 10, 0, 0),
        end: RecurrenceEnd.afterCount(10),
        interval: 365,
      ),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade número 1',
      baseDateTime: DateTime(2025, 11, 24, 10, 0),
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade número 2',
      baseDateTime: DateTime(2025, 11, 24, 11, 0),
      isStarred: true,
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade número 3',
      baseDateTime: DateTime(2025, 11, 24, 16, 45),
      createdAt: DateTime.now(),
      recurrence: RecurrenceRule(
        type: RecurrenceType.monthlyWeekdayOfMonth,
        start: DateTime(2025, 12, 1, 10, 00),
        weekOfMonth: 3,
        weekdayOfMonth: DateTime.wednesday, // 3
        end: const RecurrenceEnd.never(),
      ),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade sem data específica 1',
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade sem data específica 2',
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      createdAt: DateTime.now(),
    ),
  ];

  List<TaskSection> _taskSections = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<TaskSection> get taskSections => List.unmodifiable(_taskSections);

  List<Task> get activeTasks =>
      _tasks.where((t) => !t.isCompleted).toList(growable: false);

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList(growable: false);

  List<Task> get starredTasks =>
      _tasks.where((task) => task.isStarred).toList(growable: false);

  TaskDetailsState _detailsState = const TaskDetailsState();
  TaskDetailsState get detailsState => _detailsState;

  // List<TaskSection> get taskSections {
  //   final completedTasksOnly = activeTasks;

  //   Map<String, List<Task>> sectionsMap = {};

  //   for (var task in completedTasksOnly) {
  //     String sectionKey = task.baseDateTime != null
  //         ? task.baseDateTime!.toIso8601String().split('T')[0]
  //         : 'No Date';

  //     if (!sectionsMap.containsKey(sectionKey)) {
  //       sectionsMap[sectionKey] = [];
  //     }

  //     sectionsMap[sectionKey]!.add(task);
  //   }

  //   List<TaskSection> sections = sectionsMap.entries.map((entry) {
  //     String label = entry.key == 'No Date'
  //         ? 'No Date'
  //         : DateFormat('yMMMEd').format(DateTime.parse(entry.key));
  //     return TaskSection(
  //       label: label,
  //       date: entry.key == 'No Date'
  //           ? null
  //           : DateTime.parse(entry.key).toLocal(),
  //       tasks: entry.value,
  //     );
  //   }).toList();

  //   sections.sort((a, b) {
  //     if (a.label == 'No Date') return 1;
  //     if (b.label == 'No Date') return -1;

  //     return a.date!.compareTo(b.date!);
  //   });

  //   return sections;
  // }

  List<TaskSection> get allTaskSections {
    final now = DateTime.now();
    final dateFmt = DateFormat.yMMMEd();

    // chave pode ser 'yyyy-MM-dd' ou 'NO_DATE'
    final Map<String, List<TaskOccurrence>> map = {};

    for (final task in _tasks) {
      // tenta achar a próxima ocorrência futura
      final occ = getNextOccurrenceForTask(task, from: now);

      DateTime? refDateTime;

      if (occ != null && occ.scheduledAt != null) {
        refDateTime = occ.scheduledAt;
      } else if (task.baseDateTime != null) {
        // se não tem próxima, mas tem uma base (mesmo que no passado)
        refDateTime = task.baseDateTime;
      } else {
        // nenhuma data associada
        refDateTime = null;
      }

      final String key;
      if (refDateTime != null) {
        final day = DateTime(
          refDateTime.year,
          refDateTime.month,
          refDateTime.day,
        );
        key = day.toIso8601String().split('T').first;
      } else {
        key = 'NO_DATE';
      }

      final occurrence = TaskOccurrence(
        task: task,
        scheduledAt: refDateTime, // pode ser null
      );

      map.putIfAbsent(key, () => []);
      map[key]!.add(occurrence);
    }

    final List<TaskSection> sections = [];

    map.forEach((key, occs) {
      DateTime? date;
      String label;

      if (key == 'NO_DATE') {
        date = null;
        label = 'No date';
      } else {
        date = DateTime.parse(key);
        label = dateFmt.format(date);
      }

      // ordena cada seção por horário (e se não tiver horário usa createdAt, por exemplo)
      occs.sort((a, b) {
        final aDt = a.scheduledAt ?? a.task.createdAt;
        final bDt = b.scheduledAt ?? b.task.createdAt;
        return aDt.compareTo(bDt);
      });

      sections.add(TaskSection(date: date, label: label, items: occs));
    });

    // ordena sections: datas primeiro, "No date" por último
    sections.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1; // "No date" vai pro fim
      if (b.date == null) return -1;
      return a.date!.compareTo(b.date!);
    });

    return sections;
  }

  /// Carrega as sections de tasks para um range de datas (ex: hoje até +7 dias).
  Future<void> loadTaskSectionsForRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final occs = getOccurrencesInRange(from: from, to: to);

    final Map<DateTime, List<TaskOccurrence>> map = {};

    for (final occ in occs) {
      final day = DateTime(
        occ.scheduledAt!.year,
        occ.scheduledAt!.month,
        occ.scheduledAt!.day,
      );

      map.putIfAbsent(day, () => []);
      map[day]!.add(occ);
    }

    final DateFormat labelFormat = DateFormat.yMMMEd(); // ex: Wed, Dec 10, 2025

    final List<TaskSection> sections = map.entries.map((entry) {
      entry.value.sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));

      return TaskSection(
        date: entry.key,
        label: labelFormat.format(entry.key),
        items: entry.value,
      );
    }).toList();

    // Ordena as sections pela data
    sections.sort((a, b) => a.date!.compareTo(b.date!));

    _taskSections = sections;
    notifyListeners();
  }

  /// Gera as ocorrências de todas as tasks entre [from] e [to].
  List<TaskOccurrence> getOccurrencesInRange({
    required DateTime from,
    required DateTime to,
    int? maxOccurrences = 1,
  }) {
    final List<TaskOccurrence> occurrences = [];

    for (final task in _tasks) {
      // Task sem data base = não aparece na agenda
      if (task.baseDateTime == null) continue;

      // 1) Task não recorrente: data única
      if (task.recurrence == null ||
          task.recurrence!.type == RecurrenceType.none) {
        final dt = task.baseDateTime!;
        if (!dt.isBefore(from) && !dt.isAfter(to)) {
          occurrences.add(TaskOccurrence(task: task, scheduledAt: dt));
        }
        continue;
      }

      // 2) Task recorrente: usa o motor de recorrência
      final rule = task.recurrence!;

      final generated = generateOccurrences(rule: rule, from: from, until: to);

      for (final date in generated) {
        occurrences.add(TaskOccurrence(task: task, scheduledAt: date));
      }
    }

    // Ordena por data/hora
    occurrences.sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));

    return occurrences;
  }

  List<TaskWithNextOccurrence> getAllTasksWithNextOccurrence({
    DateTime? from,
    bool includePastNonRecurring = false,
  }) {
    final DateTime reference = from ?? DateTime.now();

    final List<TaskWithNextOccurrence> list = [];

    for (final task in _tasks) {
      final occ = getNextOccurrenceForTask(task, from: reference);

      if (occ == null) {
        // Se não tem próxima ocorrência:
        // - para task não recorrente que já passou, você decide se mostra ou não.
        if (includePastNonRecurring &&
            (task.recurrence == null ||
                task.recurrence!.type == RecurrenceType.none) &&
            task.baseDateTime != null) {
          list.add(
            TaskWithNextOccurrence(
              task: task,
              nextOccurrenceAt: task.baseDateTime,
            ),
          );
        }
        continue;
      }

      list.add(
        TaskWithNextOccurrence(task: task, nextOccurrenceAt: occ.scheduledAt),
      );
    }

    // Ordena pela próxima ocorrência (as sem data vão pro final)
    list.sort((a, b) {
      if (a.nextOccurrenceAt == null && b.nextOccurrenceAt == null) return 0;
      if (a.nextOccurrenceAt == null) return 1;
      if (b.nextOccurrenceAt == null) return -1;
      return a.nextOccurrenceAt!.compareTo(b.nextOccurrenceAt!);
    });

    return list;
  }

  TaskOccurrence? getNextOccurrenceForTask(Task task, {DateTime? from}) {
    final DateTime reference = from ?? DateTime.now();

    // Task sem data base não tem próxima ocorrência
    if (task.baseDateTime == null) return null;

    // 1) Task NÃO recorrente
    if (task.recurrence == null ||
        task.recurrence!.type == RecurrenceType.none) {
      final dt = task.baseDateTime!;

      // regra de negócio: se já passou, você pode:
      // - retornar null (não mostrar), ou
      // - ainda mostrar como "já aconteceu".
      if (dt.isBefore(reference)) {
        return null;
      }

      return TaskOccurrence(task: task, scheduledAt: dt);
    }

    // 2) Task recorrente: usa o motor para pegar só a próxima
    final rule = task.recurrence!;

    final occs = generateOccurrences(
      rule: rule,
      from: reference,
      maxOccurrences: 1,
    );

    if (occs.isEmpty) return null;

    return TaskOccurrence(task: task, scheduledAt: occs.first);
  }

  Future<Task> getTaskDetails(String taskId) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);

    return task;
  }

  Future<void> loadTaskDetails(String taskId) async {
    _detailsState = const TaskDetailsState(isLoading: true);
    notifyListeners();

    try {
      final task = await getTaskDetails(taskId);
      _detailsState = TaskDetailsState(task: task);
    } catch (e) {
      _detailsState = TaskDetailsState(error: e);
    }

    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> editTask(Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);

    if (taskIndex == -1) {
      throw Exception('Task not found');
    }

    _tasks[taskIndex] = updatedTask.copyWith(updatedAt: DateTime.now());

    await loadTaskDetails(updatedTask.id);
    // notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await subtasksProvider.deleteAllByTaskId(taskId);

    _tasks.removeWhere((task) => task.id == taskId);

    notifyListeners();
  }

  Future<void> restoreTask(TaskDetails taskDetails) async {
    _tasks.add(taskDetails.task);

    await subtasksProvider.restoreSubtasks(taskDetails.subtasks);

    notifyListeners();
  }

  Future<void> setStarredStatus({
    required String taskId,
    required bool isStarred,
  }) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1) {
      final current = _tasks[taskIndex];

      _tasks[taskIndex] = current.copyWith(
        isStarred: isStarred,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
    }
  }

  Future<void> toggleCompleted({
    required String taskId,
    required bool isCompleted,
  }) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);

    if (taskIndex == -1) return;

    final current = _tasks[taskIndex];

    _tasks[taskIndex] = current.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
      updatedAt: DateTime.now(),
    );

    notifyListeners();
  }
}
