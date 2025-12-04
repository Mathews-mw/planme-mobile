import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:planme/data/models/sub_task.dart';
import 'package:planme/data/repositories/mappers/subtask_mapper.dart';
import 'package:planme/data/database/isar/local_database_service.dart';
import 'package:planme/data/database/isar/collections/subtask_isar.dart';

class SubtasksRepository {
  final Isar _database = LocalDatabaseService().isar;
  final _uuid = const Uuid();

  Future<List<SubTask>> fetchManyByTaskId(String taskId) async {
    final subtasksData = await _database.subtaskIsars
        .filter()
        .taskIdEqualTo(taskId)
        .sortByPosition()
        .findAll();

    return subtasksData.map((sub) {
      return SubtaskMapper.toDomain(sub);
    }).toList();
  }

  Future<SubtaskIsar?> getByUid(String uid) async {
    return await _database.subtaskIsars.filter().uidEqualTo(uid).findFirst();
  }

  Future<SubtaskIsar> createSubtask(SubTask subtask) async {
    final data = SubtaskMapper.toIsar(subtask);

    final last = await _database.subtaskIsars
        .filter()
        .taskIdEqualTo(subtask.taskId)
        .sortByPositionDesc()
        .findFirst();

    final nextPosition = (last?.position ?? -1) + 1;

    data.position = nextPosition;

    await _database.writeTxn(() async {
      await _database.subtaskIsars.put(data);
    });

    return data;
  }

  Future<void> updateSubtask(SubTask subtask) async {
    final data = SubtaskMapper.toIsar(subtask);

    await _database.writeTxn(() async {
      await _database.subtaskIsars.put(data);
    });
  }

  Future<SubtaskIsar> deleteSubtask(String uid) async {
    final subtask = await getByUid(uid);

    if (subtask == null) {
      throw Exception('Subtask not found');
    }

    await _database.writeTxn(() async {
      await _database.subtaskIsars.delete(subtask.id);
    });

    return subtask;
  }

  Future<SubtaskIsar> restore({
    required SubTask subtask,
    required int position,
  }) async {
    final data = SubtaskMapper.toIsar(subtask);

    final subtaskInCurrentPosition = await _database.subtaskIsars
        .filter()
        .positionEqualTo(position)
        .sortByPositionDesc()
        .findFirst();

    if (subtaskInCurrentPosition != null) {
      data.position = position;
      subtaskInCurrentPosition.position = position + 1;

      await _database.writeTxn(() async {
        await _database.subtaskIsars.putAll([data, subtaskInCurrentPosition]);
      });
    }

    data.position = position;

    await _database.writeTxn(() async {
      await _database.subtaskIsars.put(data);
    });

    return data;
  }

  Future<void> updateOrder(List<SubTask> ordered) async {
    final dataOrdered = ordered.map((sub) {
      return SubtaskMapper.toIsar(sub);
    }).toList();

    await _database.writeTxn(() async {
      for (var i = 0; i < dataOrdered.length; i++) {
        final s = dataOrdered[i];
        s.position = i;

        await _database.subtaskIsars.put(s);
      }
    });
  }
}
