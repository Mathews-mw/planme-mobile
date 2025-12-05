import 'package:planme/domains/auth/types/provider_type.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? avatarUrl;
  final ProviderType provider;
  final String? providerId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.avatarUrl,
    this.provider = ProviderType.credentials,
    this.providerId,
    required this.createdAt,
    this.updatedAt,
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   final user = User(
  //     id: json['id'],
  //     name: json['name'],
  //     email: json['email'],
  //     password: json['password'],
  //     avatarUrl: json['avatarUrl'],
  //   );

  //   return user;
  // }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password, avatarUrl: $avatarUrl, provider: $provider, providerId: $providerId)';
  }
}
