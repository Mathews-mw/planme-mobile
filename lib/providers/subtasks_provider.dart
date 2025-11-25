import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/sub_task.dart';

class SubtasksProvider with ChangeNotifier {
  final uuid = Uuid();

  List<SubTask> _subtasks = [];

  List<SubTask> get subtasks {
    return [..._subtasks];
  }

  Future<List<SubTask>> listingSubtasksByTask(String taskId) async {
    final subtasks = _subtasks
        .where((subtask) => subtask.taskId == taskId)
        .toList();

    return subtasks;
  }

  Future<void> loadSubtasksByTaskId(String taskId) async {
    final subtasks = await listingSubtasksByTask(taskId);
    _subtasks = subtasks;

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

    notifyListeners();
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

    notifyListeners();
  }

  Future<void> deleteSubtask(String subtaskId) async {
    _subtasks.removeWhere((subtask) => subtask.id == subtaskId);

    notifyListeners();
  }

  Future<void> deleteAllByTaskId(String taskId) async {
    _subtasks.removeWhere((subTask) => subTask.taskId == taskId);
  }

  Future<void> restoreSubtasks(List<SubTask> subtasks) async {
    _subtasks.addAll(subtasks);
  }
}
