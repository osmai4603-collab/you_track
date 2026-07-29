import 'package:issues_tracking/core/enums/vcs_pr_state_enum.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_pull_request_entity.dart';

class VcsPullRequestModel extends VcsPullRequestEntity {
  const VcsPullRequestModel({
    required super.id,
    required super.integrationId,
    required super.taskId,
    required super.prNumber,
    required super.title,
    required super.authorName,
    required super.sourceBranch,
    required super.targetBranch,
    required super.state,
    required super.openedAt,
    super.mergedAt,
    super.closedAt,
    required super.createdAt,
  });

  factory VcsPullRequestModel.fromEntity(VcsPullRequestEntity entity) {
    return VcsPullRequestModel(
      id: entity.id,
      integrationId: entity.integrationId,
      taskId: entity.taskId,
      prNumber: entity.prNumber,
      title: entity.title,
      authorName: entity.authorName,
      sourceBranch: entity.sourceBranch,
      targetBranch: entity.targetBranch,
      state: entity.state,
      openedAt: entity.openedAt,
      mergedAt: entity.mergedAt,
      closedAt: entity.closedAt,
      createdAt: entity.createdAt,
    );
  }

  factory VcsPullRequestModel.fromJson(Map<String, dynamic> json) {
    return VcsPullRequestModel(
      id: (json['id'] ?? '').toString(),
      integrationId: (json['integration_id'] ?? '').toString(),
      taskId: (json['task_id'] ?? '').toString(),
      prNumber: (json['pr_number'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      authorName: (json['author_name'] ?? '').toString(),
      sourceBranch: (json['source_branch'] ?? '').toString(),
      targetBranch: (json['target_branch'] ?? '').toString(),
      state: VcsPrState.fromValue(json['state']?.toString() ?? 'open'),
      openedAt: _parseDate(json['opened_at']),
      mergedAt: json['merged_at'] != null ? _parseDate(json['merged_at']) : null,
      closedAt: json['closed_at'] != null ? _parseDate(json['closed_at']) : null,
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'integration_id': integrationId,
      'task_id': taskId,
      'pr_number': prNumber,
      'title': title,
      'author_name': authorName,
      'source_branch': sourceBranch,
      'target_branch': targetBranch,
      'state': state.value,
      'opened_at': openedAt.toIso8601String(),
      'merged_at': mergedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'integration_id': integrationId,
      'task_id': taskId,
      'pr_number': prNumber,
      'title': title,
      'author_name': authorName,
      'source_branch': sourceBranch,
      'target_branch': targetBranch,
      'state': state.value,
      'opened_at': openedAt.toIso8601String(),
      'merged_at': mergedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
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
