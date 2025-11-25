import 'package:planme/data/models/task.dart';
import 'package:planme/data/models/sub_task.dart';

class TaskDetails {
  final Task task;
  final List<SubTask> subtasks;

  const TaskDetails({required this.task, this.subtasks = const []});
}
