import 'package:issues_tracking/core/enums/project_template_enum.dart';

import '../../domain/entities/project_entity.dart';
import '../../data/models/project_member_model.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.projectKey,
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
    super.startingNumber,
  });

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      projectKey: entity.projectKey,
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
      startingNumber: entity.startingNumber,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? <String, dynamic>{};
    printMap(title: 'Project', data: safeJson);

    return ProjectModel(
      id: safeJson['id']?.toString() ?? '',
      name: safeJson['name']?.toString() ?? '',
      projectKey: safeJson['project_id']?.toString() ?? '',
      description: safeJson['description']?.toString(),
      isArchived: safeJson['is_archived'] == true,
      templateType: ProjectTemplateType.of(safeJson['template_type']),
      ownerId: safeJson['owner_id']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(safeJson['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isFavorite: safeJson['is_favorite'] == true,
      members: ProjectMemberModel.fromListJson(
        safeJson['group_members'] is List
            ? safeJson['group_members'] as List
            : null,
      ),
      visibility: safeJson['visibility'] is String
          ? safeJson['visibility'] as String
          : null,
      recommendedVisibility: _tryParseRecommendedVisibility(
        safeJson['recommended_visibility'] is List
            ? safeJson['recommended_visibility'] as List<dynamic>
            : null,
      ),
      hasTimeTracking: safeJson['has_time_tracking'] == true,
      estimation: safeJson['estimation'] is int
          ? safeJson['estimation'] as int
          : (safeJson['estimation'] is num
                ? (safeJson['estimation'] as num).toInt()
                : null),
      spentTime: safeJson['spent_time'] is int
          ? safeJson['spent_time'] as int
          : (safeJson['spent_time'] is num
                ? (safeJson['spent_time'] as num).toInt()
                : null),
      startingNumber: safeJson['starting_number'] is int
          ? safeJson['starting_number'] as int
          : (safeJson['starting_number'] is num
                ? (safeJson['starting_number'] as num).toInt()
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'project_id': projectKey,
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
      'starting_number': startingNumber,
    };
  }

  static List<String> _tryParseRecommendedVisibility(List<dynamic>? allData) {
    if (allData == null) return [];
    return allData.map((data) => data as String).toList();
  }
}
