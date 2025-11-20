class Task {
  final String id;
  final String title;
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
    return 'Task(id: $id, title: $title, date: $date, time: $time, '
        'isStarred: $isStarred, isRepeating: $isRepeating, isCompleted: $isCompleted, completedAt: $completedAt, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
