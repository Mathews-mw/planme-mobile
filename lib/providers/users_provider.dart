import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:planme/data/models/user.dart';
import 'package:planme/data/repositories/users_repository.dart';
import 'package:planme/domains/auth/types/provider_type.dart';

class UsersProvider with ChangeNotifier {
  final uuid = const Uuid();
  final UsersRepository usersRepository;

  static const String _userKey = "user_data";

  UsersProvider({required this.usersRepository});

  User? _user;

  User? get user {
    return _user;
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<void> createUser({
    required String name,
    required String email,
    String? password,
    String? avatarUrl,
    ProviderType provider = ProviderType.credentials,
    String? providerId,
  }) async {
    final newUser = User(
      id: uuid.v4(),
      name: name,
      email: email,
      provider: provider,
      providerId: providerId,
      createdAt: DateTime.now(),
    );

    await usersRepository.createUser(newUser);
  }

  Future<User?> getUserById(String id) async {
    final user = await usersRepository.getByUid(id);

    return user;
  }

  Future<User?> getUserByEmail(String email) async {
    final user = await usersRepository.getByEmail(email);

    return user;
  }
}
