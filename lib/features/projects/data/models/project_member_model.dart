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
    List<String> parsedRoles = [];
    if (rolesRaw is String) {
      final decoded = jsonDecode(rolesRaw) as List;
      parsedRoles = decoded.map((e) => e.toString()).toList();
    } else if (rolesRaw is List) {
      parsedRoles = rolesRaw.map((e) => e.toString()).toList();
    }

    return ProjectMemberModel(
      id: map['id'] as String,
      projectId: map['projectId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      roles: parsedRoles,
      avatarUrl: map['avatarUrl'] as String?,
      isOwner: (map['isOwner'] as int? ?? 0) == 1,
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
}
