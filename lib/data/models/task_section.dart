import 'package:planme/data/models/task_occurrence.dart';

class TaskSection {
  final String label;
  final DateTime? date;
  final List<TaskOccurrence> items;

  const TaskSection({
    required this.label,
    required this.date,
    required this.items,
  });
}
