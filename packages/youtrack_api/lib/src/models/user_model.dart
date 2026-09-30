import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
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

  String get userKey {
    return (username).length >= 2 ? '${username[0]}${username[1]}' : '';
  }

  const UserModel({
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

  static UserModel? tryParseFromJson(Map<String, dynamic>? data) {
    print('model: $data');
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    print('model from json: $data');

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

  @override
  List<Object?> get props => [id, fullName, username, email, avatarUrl, createdAt, isBanned, groups, projects];
}