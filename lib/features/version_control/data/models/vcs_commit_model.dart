import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';

class VcsCommitModel extends VcsCommitEntity {
  const VcsCommitModel({
    required super.id,
    required super.integrationId,
    required super.taskId,
    required super.commitSha,
    required super.authorName,
    required super.authorEmail,
    required super.message,
    required super.branch,
    required super.committedAt,
    required super.processedAt,
  });

  factory VcsCommitModel.fromEntity(VcsCommitEntity entity) {
    return VcsCommitModel(
      id: entity.id,
      integrationId: entity.integrationId,
      taskId: entity.taskId,
      commitSha: entity.commitSha,
      authorName: entity.authorName,
      authorEmail: entity.authorEmail,
      message: entity.message,
      branch: entity.branch,
      committedAt: entity.committedAt,
      processedAt: entity.processedAt,
    );
  }

  factory VcsCommitModel.fromJson(Map<String, dynamic> json) {
    return VcsCommitModel(
      id: (json['id'] ?? '').toString(),
      integrationId: (json['integration_id'] ?? '').toString(),
      taskId: (json['task_id'] ?? '').toString(),
      commitSha: (json['commit_sha'] ?? '').toString(),
      authorName: (json['author_name'] ?? '').toString(),
      authorEmail: (json['author_email'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      branch: (json['branch'] ?? '').toString(),
      committedAt: _parseDate(json['committed_at']),
      processedAt: _parseDate(json['processed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'integration_id': integrationId,
      'task_id': taskId,
      'commit_sha': commitSha,
      'author_name': authorName,
      'author_email': authorEmail,
      'message': message,
      'branch': branch,
      'committed_at': committedAt.toIso8601String(),
      'processed_at': processedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'integration_id': integrationId,
      'task_id': taskId,
      'commit_sha': commitSha,
      'author_name': authorName,
      'author_email': authorEmail,
      'message': message,
      'branch': branch,
      'committed_at': committedAt.toIso8601String(),
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
