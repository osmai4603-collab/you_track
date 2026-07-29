import 'package:issues_tracking/core/entities/entity.dart';

class UserEntity extends Entity {
  final String id;
  final String displayName;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime? registrationDate;
  final bool isBanned;
  final List<String> groups;
  final List<String> projects;
  final String initials;

  const UserEntity({
    required this.id,
    required this.displayName,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.registrationDate,
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
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      registrationDate: registrationDate ?? this.registrationDate,
      isBanned: isBanned ?? this.isBanned,
      groups: groups ?? this.groups,
      projects: projects ?? this.projects,
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        username,
        email,
        avatarUrl,
        registrationDate,
        isBanned,
        groups,
        projects,
        initials,
      ];
}
