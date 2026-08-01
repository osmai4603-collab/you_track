import 'package:issues_tracking/core/utils/printing.dart';
import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.userName,
    super.avatarUrl,
    super.createdAt,
    super.groups,
    super.projects,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      userName: entity.userName,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      groups: entity.groups,
      projects: entity.projects,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'User', data: json);

    List<String> parsedGroups = [];
    List<String> parsedProjects = [];

    if (json['group_members'] != null && json['group_members'] is List) {
      for (final gm in json['group_members']) {
        final group = gm['groups'];
        if (group != null) {
          if (group['name'] != null) {
            parsedGroups.add(group['name']);
          }
          if (group['group_projects'] != null &&
              group['group_projects'] is List) {
            for (final gp in group['group_projects']) {
              final proj = gp['projects'];
              if (proj != null && proj['name'] != null) {
                if (!parsedProjects.contains(proj['name'])) {
                  parsedProjects.add(proj['name']);
                }
              }
            }
          }
        }
      }
    }

    // Support direct array format (e.g. from sqlite JSON parse)
    if (json['groups'] != null && json['groups'] is List) {
      parsedGroups = List<String>.from(json['groups']);
    }
    if (json['projects'] != null && json['projects'] is List) {
      parsedProjects = List<String>.from(json['projects']);
    }

    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      userName: json['user_name'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      groups: parsedGroups,
      projects: parsedProjects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'groups': groups,
      'projects': projects,
    };
  }
}
