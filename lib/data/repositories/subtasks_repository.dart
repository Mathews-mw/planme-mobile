// lib/data/repositories/subtasks_repository.dart
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:planme/data/database/isar/local_database_service.dart';
import 'package:planme/data/database/isar/collections/subtask_isar.dart';

class SubtasksRepository {
  final Isar _database = LocalDatabaseService().isar;
  final _uuid = const Uuid();

  Future<List<SubtaskIsar>> getByTaskId(String taskId) async {
    return await _database.subtaskIsars
        .filter()
        .taskIdEqualTo(taskId)
        .sortByPosition()
        .findAll();
  }

  Future<SubtaskIsar> createSubtask({
    required String taskId,
    required String title,
    String? description,
  }) async {
    final now = DateTime.now();

    // pega a última posição
    final last = await _database.subtaskIsars
        .filter()
        .taskIdEqualTo(taskId)
        .sortByPositionDesc()
        .findFirst();
    final nextPosition = (last?.position ?? -1) + 1;

    final sub = SubtaskIsar()
      ..uid = _uuid.v4()
      ..taskId = taskId
      ..title = title
      ..description = description
      ..position = nextPosition
      ..createdAt = now;

    await _database.writeTxn(() async {
      await _database.subtaskIsars.put(sub);
    });

    return sub;
  }

  Future<void> updateSubtask(SubtaskIsar subtask) async {
    subtask.updatedAt = DateTime.now();

    await _database.writeTxn(() async {
      await _database.subtaskIsars.put(subtask);
    });
  }

  Future<void> deleteSubtask(SubtaskIsar subtask) async {
    await _database.writeTxn(() async {
      await _database.subtaskIsars.delete(subtask.id);
    });
  }

  Future<void> updateOrder(List<SubtaskIsar> ordered) async {
    await _database.writeTxn(() async {
      for (var i = 0; i < ordered.length; i++) {
        final s = ordered[i];
        s.position = i;

        await _database.subtaskIsars.put(s);
      }
    });
  }
}
