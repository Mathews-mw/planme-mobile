import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/sub_task.dart';

class SubtasksProvider with ChangeNotifier {
  final uuid = Uuid();

  List<SubTask> _subtasks = [];
  List<SubTask> _activeSubtasks = [];
  List<SubTask> _completedSubtasks = [];

  List<SubTask> get subtasks => [..._subtasks];
  List<SubTask> get activeSubtasks => [..._activeSubtasks];
  List<SubTask> get completedSubtasks => [..._completedSubtasks];

  Future<List<SubTask>> listingSubtasksByTask(String taskId) async {
    final subtasks = _subtasks
        .where((subtask) => subtask.taskId == taskId)
        .toList();

    return subtasks;
  }

  Future<void> loadSubtasksByTaskId(String taskId) async {
    final subtasks = await listingSubtasksByTask(taskId);

    _subtasks = subtasks;
    _activeSubtasks = subtasks.where((sub) => !sub.isCompleted).toList();
    _completedSubtasks = subtasks.where((sub) => sub.isCompleted).toList();

    notifyListeners();
  }

  void setSubtasksOrder(List<SubTask> newOrder) {
    _activeSubtasks = List<SubTask>.from(newOrder);
    notifyListeners();
  }

  Future<void> createSubtask({
    required String taskId,
    required String title,
    String? description,
  }) async {
    final newSubtask = SubTask(
      id: uuid.v4(),
      taskId: taskId,
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    _subtasks.add(newSubtask);

    await loadSubtasksByTaskId(taskId);
  }

  Future<void> editSubtask({
    required String subtaskId,
    String? title,
    String? description,
  }) async {
    final subtaskIndex = _subtasks.indexWhere(
      (subtask) => subtask.id == subtaskId,
    );

    if (subtaskIndex == -1) {
      throw Exception('Task not found');
    }

    final current = _subtasks[subtaskIndex];

    _subtasks[subtaskIndex] = current.copyWith(
      title: title,
      description: description,
      updatedAt: DateTime.now(),
    );

    await loadSubtasksByTaskId(current.taskId);
  }

  Future<int> deleteSubtask(String subtaskId) async {
    final subtaskIndex = _subtasks.indexWhere(
      (subtask) => subtask.id == subtaskId,
    );

    if (subtaskIndex == -1) {
      throw Exception('Task not found');
    }

    final current = _subtasks[subtaskIndex];

    _subtasks.removeWhere((subtask) => subtask.id == subtaskId);

    await loadSubtasksByTaskId(current.taskId);

    return subtaskIndex;
  }

  Future<void> deleteAllByTaskId(String taskId) async {
    _subtasks.removeWhere((subTask) => subTask.taskId == taskId);
  }

  Future<void> restoreSubtask({
    required int subtaskIndex,
    required SubTask subtask,
  }) async {
    _subtasks.insert(subtaskIndex, subtask);

    await loadSubtasksByTaskId(subtask.taskId);
  }

  Future<void> restoreSubtasks(List<SubTask> subtasks) async {
    _subtasks.addAll(subtasks);
  }

  Future<void> toggleCompleted({
    required String subtaskId,
    required bool isCompleted,
  }) async {
    final subtaskIndex = _subtasks.indexWhere(
      (subtask) => subtask.id == subtaskId,
    );

    if (subtaskIndex == -1) {
      throw Exception('Task not found');
    }

    final current = _subtasks[subtaskIndex];

    _subtasks[subtaskIndex] = current.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
      updatedAt: DateTime.now(),
    );

    if (isCompleted) {
      _completedSubtasks.add(_subtasks[subtaskIndex]);
      _activeSubtasks.removeWhere((sub) => sub.id == subtaskId);
    } else {
      _activeSubtasks.add(_subtasks[subtaskIndex]);
      _completedSubtasks.removeWhere((sub) => sub.id == subtaskId);
    }

    notifyListeners();
  }
}
