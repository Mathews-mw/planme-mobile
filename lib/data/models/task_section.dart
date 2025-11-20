import 'package:planme/data/models/task.dart';

class TaskSection {
  final String label;
  final DateTime? date;
  final List<Task> tasks;

  const TaskSection({required this.label, this.date, required this.tasks});
}
