import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.displayName,
    required super.username,
    required super.email,
    super.avatarUrl,
    super.registrationDate,
    super.isBanned,
    super.groups,
    super.projects,
    super.initials,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      displayName: entity.displayName,
      username: entity.username,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      registrationDate: entity.registrationDate,
      isBanned: entity.isBanned,
      groups: entity.groups,
      projects: entity.projects,
      initials: entity.initials,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      displayName: (json['display_name'] ?? (json['full_name'] ?? '')).toString(),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatarUrl: json['avatar_url']?.toString(),
      registrationDate: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      isBanned: json['is_banned'] == true,
      groups: (json['groups'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      initials: _computeInitials(
        (json['display_name'] ?? (json['full_name'] ?? '')).toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': registrationDate?.toIso8601String(),
      'is_banned': isBanned,
      'groups': groups,
      'projects': projects,
    };
  }

  static String _computeInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }
}
