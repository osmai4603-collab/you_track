import 'dart:convert';
import '../../domain/entities/project_member_entity.dart';

class ProjectMemberModel extends ProjectMemberEntity {
  const ProjectMemberModel({
    required super.id,
    required super.projectId,
    required super.name,
    required super.email,
    required super.roles,
    super.avatarUrl,
    super.isOwner,
  });

  factory ProjectMemberModel.fromEntity(ProjectMemberEntity entity) {
    return ProjectMemberModel(
      id: entity.id,
      projectId: entity.projectId,
      name: entity.name,
      email: entity.email,
      roles: entity.roles,
      avatarUrl: entity.avatarUrl,
      isOwner: entity.isOwner,
    );
  }

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) {
    final rolesRaw = json['roles'];
    final roleField = json['role']?.toString();
    List<String> parsedRoles = [];
    if (rolesRaw is String) {
      try {
        final decoded = jsonDecode(rolesRaw) as List;
        parsedRoles = decoded.map((e) => e.toString()).toList();
      } catch (_) {
        parsedRoles = [];
      }
    } else if (rolesRaw is List) {
      parsedRoles = rolesRaw.map((e) => e.toString()).toList();
    } else if (roleField != null && roleField.isNotEmpty) {
      parsedRoles = [roleField];
    }

    final isOwnerValue = json['is_owner'] ?? json['isOwner'];
    final role = json['role']?.toString().toLowerCase();
    final bool inferredIsOwner = isOwnerValue == true ||
        isOwnerValue == 1 ||
        role == 'admin' ||
        role == 'owner';

    final userData = json['users'] as Map<String, dynamic>?;

    return ProjectMemberModel(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      projectId: (json['project_id'] ?? json['projectId'] ?? '').toString(),
      name: (userData?['full_name'] ?? json['name'] ?? '').toString(),
      email: (userData?['email'] ?? json['email'] ?? '').toString(),
      roles: parsedRoles,
      avatarUrl: userData?['avatar_url']?.toString() ?? json['avatar_url']?.toString() ?? json['avatarUrl']?.toString(),
      isOwner: inferredIsOwner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'name': name,
      'email': email,
      'roles': roles,
      'avatar_url': avatarUrl,
      'is_owner': isOwner,
    };
  }
}
