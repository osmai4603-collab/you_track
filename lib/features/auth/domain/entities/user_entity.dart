import 'package:issues_tracking/core/entities/entity.dart';

class UserEntity extends Entity {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.createdAt,
  });

  @override
  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    bool clearFullName = false,
    String? avatarUrl,
    bool clearAvatarUrl = false,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: clearFullName ? null : (fullName ?? this.fullName),
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        avatarUrl,
        createdAt,
      ];
}
