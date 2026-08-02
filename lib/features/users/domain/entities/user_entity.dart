import 'package:issues_tracking/core/entities/entity.dart';

class UserEntity extends Entity {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool isBanned;
  final List<String> groups;
  final List<String> projects;
  final String initials;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.createdAt,
    this.isBanned = false,
    this.groups = const [],
    this.projects = const [],
    this.initials = '',
  });

  @override
  UserEntity copyWith({
    String? id,
    String? displayName,
    String? username,
    String? email,
    String? avatarUrl,
    DateTime? registrationDate,
    bool? isBanned,
    List<String>? groups,
    List<String>? projects,
    String? initials,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: displayName ?? fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: registrationDate ?? createdAt,
      isBanned: isBanned ?? this.isBanned,
      groups: groups ?? this.groups,
      projects: projects ?? this.projects,
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    username,
    email,
    avatarUrl,
    createdAt,
    isBanned,
    groups,
    projects,
    initials,
  ];
}
