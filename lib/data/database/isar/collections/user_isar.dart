import 'package:isar/isar.dart';
import 'package:planme/domains/auth/types/provider_type.dart';

part 'user_isar.g.dart';

@collection
@Name("users")
class UserIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late String name;

  @Index(unique: true, replace: true)
  late String email;

  String? password;

  @Name("avatar_url")
  String? avatarUrl;

  @Enumerated(EnumType.ordinal)
  late ProviderType provider;

  @Name("provider_id")
  String? providerId;

  @Name("created_at")
  late DateTime createdAt;
  @Name("updated_at")
  DateTime? updatedAt;
}
