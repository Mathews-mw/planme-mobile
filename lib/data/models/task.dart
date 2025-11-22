class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? date;
  final String? time;
  final bool isStarred;
  final bool isRepeating;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.date,
    this.time,
    this.isStarred = false,
    this.isRepeating = false,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? time,
    bool? isStarred,
    bool? isRepeating,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      isStarred: isStarred ?? this.isStarred,
      isRepeating: isRepeating ?? this.isRepeating,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, date: $date, time: $time, '
        'isStarred: $isStarred, isRepeating: $isRepeating, isCompleted: $isCompleted, completedAt: $completedAt, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
