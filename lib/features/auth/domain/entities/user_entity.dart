import 'package:issues_tracking/core/entities/entity.dart';

class UserEntity extends Entity {
  final String id;
  final String email;
  final String? userName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final List<String> groups;
  final List<String> projects;

  const UserEntity({
    required this.id,
    required this.email,
    this.userName,
    this.avatarUrl,
    this.createdAt,
    this.groups = const [],
    this.projects = const [],
  });

  String get userKey {
    return (userName ?? '').length >= 2 ? '${userName![0]}${userName![1]}' : '';
  }

  @override
  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    bool clearFullName = false,
    String? avatarUrl,
    bool clearAvatarUrl = false,
    DateTime? createdAt,
    List<String>? groups,
    List<String>? projects,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: clearFullName ? null : (fullName ?? this.userName),
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      createdAt: createdAt ?? this.createdAt,
      groups: groups ?? this.groups,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object?> get props => [id, email, userName, avatarUrl, createdAt, groups, projects];
}
