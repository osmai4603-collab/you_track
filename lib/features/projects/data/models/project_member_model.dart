import 'dart:convert';
import 'package:issues_tracking/features/auth/data/models/user_model.dart';

import '../../domain/entities/project_member_entity.dart';

class ProjectMemberModel extends ProjectMemberEntity {
  const ProjectMemberModel({
    required super.id,
    required super.projectId,
    required super.roles,
    required super.userId,
    super.userData,
    required super.isOwner,
  });

  factory ProjectMemberModel.fromEntity(ProjectMemberEntity entity) {
    return ProjectMemberModel(
      id: entity.id,
      projectId: entity.projectId,
      roles: entity.roles,
      userData: entity.userData,
      userId: entity.userId,
      isOwner: entity.isOwner,
    );
  }

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) {
    print('member: $json');

    return ProjectMemberModel(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      projectId: json['project_id'],
      roles: [], // [json['role']],
      userId: json['user_id'],
      isOwner: json['is_owner'],
      userData: json['users'] == null
          ? null
          : UserModel.fromJson(json['users']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'user_id': userId,
      //'roles': roles,
      'is_owner': isOwner,
    };
  }
}
