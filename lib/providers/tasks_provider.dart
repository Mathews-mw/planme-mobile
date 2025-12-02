import 'package:intl/intl.dart';
import 'package:planme/domains/recurrence/recurrence_engine.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/data/models/task_section.dart';
import 'package:planme/providers/subtasks_provider.dart';
import 'package:planme/data/models/task_occurrence.dart';
import 'package:planme/data/repositories/tasks_repository.dart';
import 'package:planme/data/models/aggregates/task_details.dart';
import 'package:planme/ui/screens/task_details/task_details_state.dart';

class TasksProvider with ChangeNotifier {
  final SubtasksProvider subtasksProvider;
  final TasksRepository tasksRepository;
  final RecurrenceEngine _recurrenceEngine;

  TasksProvider({
    required this.subtasksProvider,
    required this.tasksRepository,
    RecurrenceEngine? recurrenceEngine,
  }) : _recurrenceEngine = recurrenceEngine ?? const RecurrenceEngine();

  final uuid = Uuid();

  List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get activeTasks =>
      _tasks.where((t) => !t.isCompleted).toList(growable: false);

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList(growable: false);

  List<Task> get starredTasks =>
      _tasks.where((task) => task.isStarred).toList(growable: false);

  TaskDetailsState _detailsState = const TaskDetailsState();
  TaskDetailsState get detailsState => _detailsState;

  Future<void> loadAllTasks() async {
    _tasks = await tasksRepository.getAllTasks();
    notifyListeners();
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
    await tasksRepository.createTask(task);

    _tasks.add(task);

    await loadAllTasks();
  }

  Future<void> editTask(Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);

    if (taskIndex == -1) {
      throw Exception('Task not found');
    }

    _tasks[taskIndex] = updatedTask.copyWith(updatedAt: DateTime.now());

    await loadTaskDetails(updatedTask.id);
    await loadAllTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await subtasksProvider.deleteAllByTaskId(taskId);

    _tasks.removeWhere((task) => task.id == taskId);

    await loadAllTasks();
  }

  Future<void> restoreTask(TaskDetails taskDetails) async {
    _tasks.add(taskDetails.task);

    await subtasksProvider.restoreSubtasks(taskDetails.subtasks);

    await loadAllTasks();
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

  // ==========================================================
  //   SECTION TABS
  // ==========================================================

  /// Uma ocorrência por task, agrupada por data ou "No date"
  List<TaskSection> buildAllTaskSections(
    DateTime now, [
    bool onlyActives = false,
  ]) {
    final tasks = onlyActives ? activeTasks : _tasks;

    final List<TaskOccurrence> occurrences = [];

    for (final task in tasks) {
      // se não tem data nem recorrência, cai em "No date"
      if (task.baseDateTime == null && task.recurrence == null) {
        occurrences.add(
          TaskOccurrence(
            task: task,
            scheduledAt: now, // placeholder, não usado no label
          ),
        );

        continue;
      }

      // Somente a próxima ocorrência futura
      final next = _recurrenceEngine.getNextOccurrenceForTask(task, from: now);

      if (next != null) {
        occurrences.add(
          TaskOccurrence(task: task, scheduledAt: next.scheduledAt),
        );
      } else if (task.baseDateTime != null) {
        // fallback: usa baseDateTime se não achou futura (ex: só passado)
        occurrences.add(
          TaskOccurrence(task: task, scheduledAt: task.baseDateTime!),
        );
      }
    }

    return _groupOccurrencesIntoSections(
      occurrences: occurrences,
      includeNoDateSection: true,
    );
  }

  List<TaskSection> buildFavoriteTasksSections(
    DateTime now, [
    bool onlyActives = false,
  ]) {
    final favoriteTasks = onlyActives
        ? starredTasks.where((task) => !task.isCompleted).toList()
        : starredTasks;

    final List<TaskOccurrence> occurrences = [];

    for (final task in favoriteTasks) {
      if (task.baseDateTime == null && task.recurrence == null) {
        occurrences.add(TaskOccurrence(task: task, scheduledAt: now));
        continue;
      }

      final next = _recurrenceEngine.getNextOccurrenceForTask(task, from: now);
      if (next != null) {
        occurrences.add(
          TaskOccurrence(task: task, scheduledAt: next.scheduledAt),
        );
      } else if (task.baseDateTime != null) {
        occurrences.add(
          TaskOccurrence(task: task, scheduledAt: task.baseDateTime!),
        );
      }
    }

    return _groupOccurrencesIntoSections(
      occurrences: occurrences,
      includeNoDateSection: true,
    );
  }

  /// Gera TODAS as ocorrências dentro de um range e agrupa por dia
  List<TaskSection> buildAgendaSections({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    bool onlyActives = false,
  }) {
    final tasks = onlyActives ? activeTasks : _tasks;

    final occurrences = _recurrenceEngine.generateOccurrencesInRange(
      from: rangeStart,
      to: rangeEnd,
      tasks: tasks,
      maxOccurrences: 1,
    );

    return _groupOccurrencesIntoSections(
      occurrences: occurrences,
      includeNoDateSection: false, // agenda sempre baseada em data
    );
  }

  // ==========================================================
  //   Helper para agrupar/ordenar seções
  // ==========================================================
  List<TaskSection> _groupOccurrencesIntoSections({
    required List<TaskOccurrence> occurrences,
    required bool includeNoDateSection,
  }) {
    final Map<String, List<TaskOccurrence>> map = {};

    for (final occ in occurrences) {
      final task = occ.task;

      // tasks sem data vão pra seção "No date"
      if ((task.baseDateTime == null && task.recurrence == null) &&
          includeNoDateSection) {
        map.putIfAbsent('No date', () => []);
        map['No date']!.add(occ);
        continue;
      }

      // usa apenas a data (sem hora) como chave
      final dateOnly = DateUtils.dateOnly(occ.scheduledAt);
      final key = DateFormat('yyyy-MM-dd').format(dateOnly);

      map.putIfAbsent(key, () => []);
      map[key]!.add(occ);
    }

    final sections = <TaskSection>[];

    // monta seções normais (com data)
    final dateKeys = map.keys.where((k) => k != 'No date').toList()
      ..sort((a, b) => a.compareTo(b));

    for (final key in dateKeys) {
      final occs = map[key]!
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

      final date = DateTime.parse(key);
      final labelDate = date;
      final label = DateFormat.yMMMd().format(labelDate);

      sections.add(TaskSection(label: label, date: date, items: occs));
    }

    // por fim, seção No date se existir
    if (includeNoDateSection && map.containsKey('No date')) {
      final occs = map['No date']!;
      sections.add(TaskSection(label: 'No date', date: null, items: occs));
    }

    return sections;
  }
}
