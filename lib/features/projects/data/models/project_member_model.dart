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

  factory ProjectMemberModel.fromMap(Map<String, dynamic> map) {
    final rolesRaw = map['roles'];
    final roleField = map['role']?.toString();
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

    final isOwnerValue = map['isOwner'] ?? map['is_owner'];
    final role = map['role']?.toString().toLowerCase();
    final bool inferredIsOwner = isOwnerValue == true || 
                                 isOwnerValue == 1 || 
                                 role == 'admin' || 
                                 role == 'owner';

    return ProjectMemberModel(
      id: (map['id'] ?? '').toString(),
      projectId: (map['projectId'] ?? map['project_id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      roles: parsedRoles,
      avatarUrl: map['avatarUrl']?.toString() ?? map['avatar_url']?.toString(),
      isOwner: inferredIsOwner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'email': email,
      'roles': jsonEncode(roles),
      'avatarUrl': avatarUrl,
      'isOwner': isOwner ? 1 : 0,
    };
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

    return ProjectMemberModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? json['projectId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roles: parsedRoles,
      avatarUrl: json['avatar_url']?.toString() ?? json['avatarUrl']?.toString(),
      isOwner: inferredIsOwner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'name': name,
      'email': email,
      'roles': roles,
      'avatar_url': avatarUrl,
      'is_owner': isOwner,
    };
  }
}
