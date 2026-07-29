import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';

class VcsUserMappingModel extends VcsUserMappingEntity {
  const VcsUserMappingModel({
    required super.id,
    required super.integrationId,
    required super.vcsUsernameOrEmail,
    required super.youtrackUserId,
    required super.createdAt,
  });

  factory VcsUserMappingModel.fromEntity(VcsUserMappingEntity entity) {
    return VcsUserMappingModel(
      id: entity.id,
      integrationId: entity.integrationId,
      vcsUsernameOrEmail: entity.vcsUsernameOrEmail,
      youtrackUserId: entity.youtrackUserId,
      createdAt: entity.createdAt,
    );
  }

  factory VcsUserMappingModel.fromJson(Map<String, dynamic> json) {
    return VcsUserMappingModel(
      id: (json['id'] ?? '').toString(),
      integrationId: (json['integration_id'] ?? '').toString(),
      vcsUsernameOrEmail: (json['vcs_username_or_email'] ?? '').toString(),
      youtrackUserId: (json['youtrack_user_id'] ?? '').toString(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'integration_id': integrationId,
      'vcs_username_or_email': vcsUsernameOrEmail,
      'youtrack_user_id': youtrackUserId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'integration_id': integrationId,
      'vcs_username_or_email': vcsUsernameOrEmail,
      'youtrack_user_id': youtrackUserId,
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
