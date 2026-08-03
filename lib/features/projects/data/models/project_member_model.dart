import 'package:issues_tracking/features/users/data/models/user_model.dart';

import '../../domain/entities/project_member_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

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

  static List<ProjectMemberModel> fromListJson(List<dynamic>? allData) {
    if (allData == null) return [];
    return allData.whereType<Map<String, dynamic>>().map((data) {
      final payload = data['groups'];
      if (payload is Map<String, dynamic>) {
        return ProjectMemberModel.fromJson(payload);
      }
      if (payload is Map) {
        return ProjectMemberModel.fromJson(Map<String, dynamic>.from(payload));
      }
      return const ProjectMemberModel(
        id: '',
        projectId: '',
        roles: [],
        userId: '',
        isOwner: false,
      );
    }).toList();
  }

  factory ProjectMemberModel.fromJson(Map<String, dynamic>? json) {
    printMap(title: 'ProjectMember', data: json ?? {});

    if (json == null) {
      return const ProjectMemberModel(
        id: '',
        projectId: '',
        roles: [],
        userId: '',
        isOwner: false,
      );
    }

    return ProjectMemberModel(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      projectId: json['project_id']?.toString() ?? '',
      roles: [],
      userId: json['user_id']?.toString() ?? '',
      isOwner: json['is_owner'] == true,
      userData: UserModel.tryParseFromJson(
        json['users'] is Map ? Map<String, dynamic>.from(json['users']) : null,
      ),
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
