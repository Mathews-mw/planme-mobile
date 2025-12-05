import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:planme/data/models/user.dart';
import 'package:planme/data/repositories/mappers/user_mapper.dart';
import 'package:planme/data/database/isar/collections/user_isar.dart';
import 'package:planme/data/database/isar/local_database_service.dart';

class UsersRepository {
  final Isar _database = LocalDatabaseService().isar;
  final _uuid = const Uuid();

  Future<UserIsar> createUser(User user) async {
    final data = UserMapper.toIsar(user);

    await _database.writeTxn(() async {
      await _database.userIsars.put(data);
    });

    return data;
  }

  Future<void> updateUser(User user) async {
    final data = UserMapper.toIsar(user);

    await _database.writeTxn(() async {
      await _database.userIsars.put(data);
    });
  }

  Future<User?> getByUid(String uid) async {
    final data = await _database.userIsars.filter().uidEqualTo(uid).findFirst();

    if (data == null) {
      return null;
    }

    return UserMapper.toDomain(data);
  }

  Future<User?> getByEmail(String email) async {
    final data = await _database.userIsars
        .filter()
        .emailEqualTo(email)
        .findFirst();

    if (data == null) {
      return null;
    }

    return UserMapper.toDomain(data);
  }
}
