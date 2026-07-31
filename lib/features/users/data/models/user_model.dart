import 'package:flutter/foundation.dart';
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

  factory UserModel.fromJson(Map<String, dynamic> data) {
    printMap(title: 'User', data: data);
    return UserModel(
      id: data['id'],
      fullName: data['full_name'] ?? '',
      username: (data['user_name'] ?? '').toString(),
      email: data['email'],
      avatarUrl: data['avatar_url'],
      createdAt: DateTime.tryParse(data['created_at'] ?? ''),
      isBanned: data['is_banned'] == true,
      groups:
          (data['groups'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      projects:
          (data['projects'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
