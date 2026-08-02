import 'package:issues_tracking/core/enums/project_template_enum.dart';

import '../../domain/entities/project_entity.dart';
import '../../data/models/project_member_model.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.projectId,
    super.description,
    super.isArchived,
    required super.templateType,
    required super.ownerId,
    required super.createdAt,
    super.isFavorite,
    super.members,
    super.visibility,
    super.recommendedVisibility,
    super.hasTimeTracking,
    super.estimation,
    super.spentTime,
  });

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      projectId: entity.projectId,
      description: entity.description,
      isArchived: entity.isArchived,
      templateType: entity.templateType,
      ownerId: entity.ownerId,
      createdAt: entity.createdAt,
      isFavorite: entity.isFavorite,
      members: entity.members,
      visibility: entity.visibility,
      recommendedVisibility: entity.recommendedVisibility,
      hasTimeTracking: entity.hasTimeTracking,
      estimation: entity.estimation,
      spentTime: entity.spentTime,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Project', data: json);
    // print('project: $json');
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      projectId: json['project_id'],
      description: json['description'],
      isArchived: json['is_archived'] == true,
      templateType: ProjectTemplateType.of(json['template_type']),
      ownerId: json['owner_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      isFavorite: json['is_favorite'] == true,
      members: ProjectMemberModel.fromListJson(json['group_members']),
      visibility: json['visibility'],
      recommendedVisibility: _tryParseRecommendedVisibility(
        json['recommended_visibility'],
      ),
      hasTimeTracking: json['has_time_tracking'] == true,
      estimation: json['estimation'] is int
          ? json['estimation'] as int
          : (json['estimation'] is num
              ? (json['estimation'] as num).toInt()
              : null),
      spentTime: json['spent_time'] is int
          ? json['spent_time'] as int
          : (json['spent_time'] is num
              ? (json['spent_time'] as num).toInt()
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'project_id': projectId,
      'description': description,
      'is_archived': isArchived,
      'template_type': templateType.name,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
      'visibility': visibility,
      'recommended_visibility': recommendedVisibility,
      'has_time_tracking': hasTimeTracking,
      'estimation': estimation,
      'spent_time': spentTime,
    };
  }

  static List<String> _tryParseRecommendedVisibility(List<dynamic>? allData) {
    if (allData == null) return [];
    return allData.map((data) => data as String).toList();
  }
}
