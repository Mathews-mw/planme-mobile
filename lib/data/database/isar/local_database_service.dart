import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:planme/data/database/isar/collections/user_isar.dart';
import 'package:planme/data/database/isar/collections/task_isar.dart';
import 'package:planme/data/database/isar/collections/subtask_isar.dart';

/// Isar Singleton Service Instance
class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();

  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  late Isar _isar;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [UserIsarSchema, TaskIsarSchema, SubtaskIsarSchema],
      directory: dir.path,
      inspector: true,
    );
  }

  Isar get isar => _isar;
}
