import 'package:planme/data/models/task.dart';

class TaskWithNextOccurrence {
  final Task task;
  final DateTime? nextOccurrenceAt;

  const TaskWithNextOccurrence({
    required this.task,
    required this.nextOccurrenceAt,
  });
}
