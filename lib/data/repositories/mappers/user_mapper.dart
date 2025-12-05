import 'package:planme/data/models/user.dart';
import 'package:planme/data/database/isar/collections/user_isar.dart';

class UserMapper {
  static User toDomain(UserIsar data) {
    return User(
      id: data.uid,
      name: data.name,
      email: data.email,
      password: data.password,
      avatarUrl: data.avatarUrl,
      provider: data.provider,
      providerId: data.providerId,

      updatedAt: data.updatedAt,
      createdAt: data.createdAt,
    );
  }

  static UserIsar toIsar(User data) {
    return UserIsar()
      ..uid = data.id
      ..name = data.name
      ..email = data.email
      ..password = data.password
      ..avatarUrl = data.avatarUrl
      ..provider = data.provider
      ..providerId = data.providerId
      ..createdAt = data.createdAt
      ..updatedAt = data.updatedAt;
  }
}
