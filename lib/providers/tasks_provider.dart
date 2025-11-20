import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/data/models/task_section.dart';

class TasksProvider with ChangeNotifier {
  final uuid = Uuid();

  // List<Task> _tasks = [];
  List<Task> _tasks = [
    Task(
      id: Uuid().v4(),
      title: 'Tomar remédio',
      date: DateTime(2025, 11, 17, 17, 30),
      time: '17:30',
      isRepeating: true,
      isStarred: true,
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Cancelar gamepass',
      date: DateTime(2025, 11, 20, 20, 0),
      time: '20:00',
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Renovar certificado do Itaú até o dia 29',
      date: DateTime(2026, 9, 22),
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade número 1',
      date: DateTime(2025, 11, 24, 10, 0),
      time: '10:00',
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade número 2',
      date: DateTime(2025, 11, 24, 11, 0),
      time: '11:00',
      isStarred: true,
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade número 3',
      date: DateTime(2025, 11, 24, 16, 45),
      time: '16:45',
      isRepeating: true,
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade sem data específica 1',
      isRepeating: false,
      createdAt: DateTime.now(),
    ),
    Task(
      id: Uuid().v4(),
      title: 'Atividade sem data específica 2',
      isRepeating: false,
      createdAt: DateTime.now(),
    ),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get activeTasks =>
      _tasks.where((t) => !t.isCompleted).toList(growable: false);

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList(growable: false);

  List<TaskSection> get taskSections {
    final completedTasksOnly = activeTasks;

    Map<String, List<Task>> sectionsMap = {};

    for (var task in completedTasksOnly) {
      String sectionKey = task.date != null
          ? task.date!.toIso8601String().split('T')[0]
          : 'No Date';

      if (!sectionsMap.containsKey(sectionKey)) {
        sectionsMap[sectionKey] = [];
      }

      sectionsMap[sectionKey]!.add(task);
    }

    List<TaskSection> sections = sectionsMap.entries.map((entry) {
      print('entry key: ${entry.key}');

      String label = entry.key == 'No Date'
          ? 'No Date'
          : DateFormat('yMMMEd').format(DateTime.parse(entry.key));
      return TaskSection(
        label: label,
        date: entry.key == 'No Date'
            ? null
            : DateTime.parse(entry.key).toLocal(),
        tasks: entry.value,
      );
    }).toList();

    sections.sort((a, b) {
      if (a.label == 'No Date') return 1;
      if (b.label == 'No Date') return -1;

      return a.date!.compareTo(b.date!);
    });

    return sections;
  }

  Future<void> createTask(Task task) async {
    _tasks.add(task);
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
