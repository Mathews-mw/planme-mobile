import 'package:planme/data/models/task.dart';

/// Uma instância concreta de uma Task em um dia/hora específico.
class TaskOccurrence {
  final Task task;
  final DateTime? scheduledAt;

  const TaskOccurrence({required this.task, this.scheduledAt});
}
