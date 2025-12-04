import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/sub_task.dart';
import 'package:planme/data/repositories/subtasks_repository.dart';

class SubtasksProvider with ChangeNotifier {
  final SubtasksRepository subtasksRepository;

  SubtasksProvider({required this.subtasksRepository});

  final uuid = const Uuid();

  List<SubTask> _subtasks = [];

  List<SubTask> get subtasks => [..._subtasks];

  List<SubTask> get activeSubtasks =>
      _subtasks.where((sub) => !sub.isCompleted).toList(growable: false);

  List<SubTask> get completedSubtasks =>
      _subtasks.where((sub) => sub.isCompleted).toList(growable: false);

  Future<void> loadSubtasksByTaskId(String taskId) async {
    final subtasks = await subtasksRepository.fetchManyByTaskId(taskId);

    _subtasks = subtasks;
    notifyListeners();
  }

  void setSubtasksOrder(List<SubTask> ordering) async {
    final newOrder = [...ordering];

    completedSubtasks.forEach((item) => newOrder.insert(item.position, item));

    await subtasksRepository.updateOrder(newOrder);
    await loadSubtasksByTaskId(ordering[0].taskId);
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

    try {
      await subtasksRepository.createSubtask(newSubtask);
    } catch (e) {
      _subtasks.removeWhere((item) => item.id == newSubtask.id);
      notifyListeners();
      rethrow;
    }

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
      throw Exception('Subtask not found');
    }

    final oldSubtask = _subtasks[subtaskIndex];

    final persisted = oldSubtask.copyWith(
      title: title,
      description: description,
      updatedAt: DateTime.now(),
    );

    _subtasks[subtaskIndex] = persisted;
    notifyListeners();

    try {
      await subtasksRepository.updateSubtask(persisted);
    } catch (e) {
      _subtasks[subtaskIndex] = oldSubtask;
      notifyListeners();
      rethrow;
    }
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
    notifyListeners();

    try {
      await subtasksRepository.deleteSubtask(subtaskId);
      await subtasksRepository.updateOrder(_subtasks);
      await loadSubtasksByTaskId(current.taskId);
    } catch (e) {
      rethrow;
    }

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
    await subtasksRepository.restore(
      subtask: subtask,
      position: subtask.position,
    );
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

    final oldSubtask = _subtasks[subtaskIndex];

    final updatedSubtask = oldSubtask.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
      updatedAt: DateTime.now(),
    );

    _subtasks[subtaskIndex] = updatedSubtask;
    notifyListeners();

    try {
      await subtasksRepository.updateSubtask(updatedSubtask);
    } catch (e) {
      _subtasks[subtaskIndex] = oldSubtask;
      notifyListeners();
      rethrow;
    }
  }
}
