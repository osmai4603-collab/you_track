import 'package:issues_tracking/core/utils/printing.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.username,
    required super.email,
    super.avatarUrl,
    super.createdAt,
    super.isBanned,
    super.groups,
    super.projects,
    super.initials,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      username: entity.username,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      isBanned: entity.isBanned,
      groups: entity.groups,
      projects: entity.projects,
      initials: entity.initials,
    );
  }

  static UserModel? tryParseFromJson(Map<String, dynamic>? data) {
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    printMap(title: 'User', data: data);

    List<String> parsedGroups = [];
    List<String> parsedProjects = [];

    if (data['group_members'] != null && data['group_members'] is List) {
      for (final gm in data['group_members']) {
        final group = gm['groups'];
        if (group != null) {
          if (group['name'] != null) {
            parsedGroups.add(group['name'].toString());
          }
          if (group['group_projects'] != null &&
              group['group_projects'] is List) {
            for (final gp in group['group_projects']) {
              final proj = gp['projects'];
              if (proj != null && proj['name'] != null) {
                if (!parsedProjects.contains(proj['name'].toString())) {
                  parsedProjects.add(proj['name'].toString());
                }
              }
            }
          }
        }
      }
    }

    // Support direct array format (e.g. from sqlite JSON parse)
    if (data['groups'] != null && data['groups'] is List) {
      parsedGroups = (data['groups'] as List).map((e) => e.toString()).toList();
    }
    if (data['projects'] != null && data['projects'] is List) {
      parsedProjects = (data['projects'] as List)
          .map((e) => e.toString())
          .toList();
    }

    return UserModel(
      id: data['id'],
      fullName: data['full_name'] ?? '',
      username: (data['user_name'] ?? '').toString(),
      email: data['email'],
      avatarUrl: data['avatar_url'],
      createdAt: DateTime.tryParse(data['created_at'] ?? ''),
      isBanned: data['is_banned'] as bool? ?? false,
      groups: parsedGroups,
      projects: parsedProjects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'user_name': username,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'is_banned': isBanned,
      // 'groups': groups,
      // 'projects': projects,
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
