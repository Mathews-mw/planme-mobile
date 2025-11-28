import 'package:planme/data/models/sub_task.dart';
import 'package:planme/domains/recurrence/models/recurrence_rule.dart';

class Task {
  final String id;
  final String title;
  final String? description;

  /// Primeira data/hora “base” da task (para não recorrente é a data única).
  final DateTime? baseDateTime;

  /// Regra de recorrência (null = não recorrente).
  final RecurrenceRule? recurrence;

  final bool isStarred;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<SubTask>? subTasks;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.baseDateTime,
    this.isStarred = false,
    this.isCompleted = false,
    this.completedAt,
    this.recurrence,
    required this.createdAt,
    this.updatedAt,
    this.subTasks,
  });

  bool get isRepeating => recurrence != null;

  String? get timeLabel {
    if (baseDateTime == null) return null;

    final onlyTime = baseDateTime.toString().split(' ').last;

    if (onlyTime == '00:00:00.000') return null;

    return '${baseDateTime!.hour.toString().padLeft(2, '0')}:${baseDateTime!.minute.toString().padLeft(2, '0')}';
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? baseDateTime,
    RecurrenceRule? recurrence,
    bool? isStarred,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      baseDateTime: baseDateTime ?? this.baseDateTime,
      recurrence: recurrence ?? this.recurrence,
      isStarred: isStarred ?? this.isStarred,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, baseDateTime: $baseDateTime, '
        'isStarred: $isStarred, isRepeating: $isRepeating, isCompleted: $isCompleted, completedAt: $completedAt, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
