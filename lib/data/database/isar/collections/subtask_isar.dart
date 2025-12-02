import 'package:isar/isar.dart';

part 'subtask_isar.g.dart';

@collection
@Name("subtasks")
class SubtaskIsar {
  Id id = Isar.autoIncrement;

  /// ID estável pra sync com backend
  @Index(unique: true, replace: true)
  late String uid;

  late String taskId;

  late String title;
  String? description;

  /// posição manual na ReorderableList
  @Index()
  int position = 0;

  @Name("is_completed")
  bool isCompleted = false;
  @Name("completed_at")
  DateTime? completedAt;
  @Name("created_at")
  late DateTime createdAt;
  @Name("updated_at")
  DateTime? updatedAt;
}
