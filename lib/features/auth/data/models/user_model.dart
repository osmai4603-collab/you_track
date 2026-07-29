import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.userName,
    super.avatarUrl,
    super.createdAt,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      userName: entity.userName,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('user: $json');
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      userName: json['user_name'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.tryParse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
