import 'package:planme/data/models/sub_task.dart';
import 'package:planme/data/database/isar/collections/subtask_isar.dart';

class SubtaskMapper {
  static SubTask toDomain(SubtaskIsar data) {
    return SubTask(
      id: data.uid,
      taskId: data.taskId,
      title: data.title,
      description: data.description,
      position: data.position,
      isCompleted: data.isCompleted,
      completedAt: data.completedAt,

      updatedAt: data.updatedAt,
      createdAt: data.createdAt,
    );
  }

  static SubtaskIsar toIsar(SubTask data) {
    return SubtaskIsar()
      ..uid = data.id
      ..taskId = data.taskId
      ..title = data.title
      ..description = data.description
      ..isCompleted = data.isCompleted
      ..position = data.position
      ..completedAt = data.completedAt
      ..createdAt = data.createdAt
      ..updatedAt = data.updatedAt;
  }
}
