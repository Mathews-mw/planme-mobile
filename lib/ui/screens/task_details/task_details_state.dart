import 'package:planme/data/models/task.dart';

class TaskDetailsState {
  final bool isLoading;
  final Task? task;
  final Object? error;

  const TaskDetailsState({this.isLoading = false, this.task, this.error});
}
