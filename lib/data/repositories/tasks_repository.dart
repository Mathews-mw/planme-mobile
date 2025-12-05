import 'package:uuid/uuid.dart';
import 'package:isar/isar.dart';

import 'package:planme/data/models/task.dart';
import 'package:planme/data/repositories/mappers/task_mapper.dart';
import 'package:planme/data/database/isar/collections/task_isar.dart';
import 'package:planme/data/database/isar/local_database_service.dart';
import 'package:planme/data/database/isar/collections/subtask_isar.dart';

class TasksRepository {
  final Isar _database = LocalDatabaseService().isar;
  final _uuid = const Uuid();

  Future<List<Task>> getAllTasks() async {
    final tasksData = await _database.taskIsars.where().findAll();

    return tasksData.map((data) {
      return TaskMapper.toDomain(data);
    }).toList();
  }

  Future<List<Task>> getTasksInDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final tasksData = await _database.taskIsars
        .filter()
        .baseDateTimeBetween(from, to)
        .findAll();

    return tasksData.map((data) {
      return TaskMapper.toDomain(data);
    }).toList();
  }

  Future<TaskIsar?> getByUid(String uid) async {
    return await _database.taskIsars.filter().uidEqualTo(uid).findFirst();
  }

  Future<TaskIsar> createTask(Task task) async {
    final data = TaskMapper.toIsar(task);

    await _database.writeTxn(() async {
      await _database.taskIsars.put(data);
    });

    return data;
  }

  Future<void> updateTask(Task task) async {
    final data = TaskMapper.toIsar(task);

    await _database.writeTxn(() async {
      await _database.taskIsars.put(data);
    });
  }

  Future<void> deleteTaskByUid(String uid) async {
    final task = await getByUid(uid);
    if (task == null) return;

    await _database.writeTxn(() async {
      // subtasks com FK taskId => deletar também
      await _database.subtaskIsars.filter().taskIdEqualTo(task.uid).deleteAll();

      await _database.taskIsars.delete(task.id);
    });
  }
}
