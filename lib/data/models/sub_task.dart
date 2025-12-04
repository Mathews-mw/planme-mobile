class SubTask {
  final String id;
  final String taskId;
  final String title;
  final String? description;
  final int position;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SubTask({
    required this.id,
    required this.taskId,
    required this.title,
    this.description,
    this.position = 0,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    this.updatedAt,
  });

  SubTask copyWith({
    String? id,
    String? taskId,
    String? title,
    String? description,
    int? position,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubTask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      position: position ?? this.position,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SubTask(id: $id, taskId: $taskId, title: $title, description: $description, '
        'position: $position, isCompleted: $isCompleted, completedAt: $completedAt, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
