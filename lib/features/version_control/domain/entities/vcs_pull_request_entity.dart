import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/vcs_pr_state_enum.dart';

class VcsPullRequestEntity extends Equatable {
  final String id;
  final String integrationId;
  final String taskId;
  final int prNumber;
  final String title;
  final String authorName;
  final String sourceBranch;
  final String targetBranch;
  final VcsPrState state;
  final DateTime openedAt;
  final DateTime? mergedAt;
  final DateTime? closedAt;
  final DateTime createdAt;

  const VcsPullRequestEntity({
    required this.id,
    required this.integrationId,
    required this.taskId,
    required this.prNumber,
    required this.title,
    required this.authorName,
    required this.sourceBranch,
    required this.targetBranch,
    required this.state,
    required this.openedAt,
    this.mergedAt,
    this.closedAt,
    required this.createdAt,
  });

  VcsPullRequestEntity copyWith({
    String? id,
    String? integrationId,
    String? taskId,
    int? prNumber,
    String? title,
    String? authorName,
    String? sourceBranch,
    String? targetBranch,
    VcsPrState? state,
    DateTime? openedAt,
    DateTime? mergedAt,
    bool clearMergedAt = false,
    DateTime? closedAt,
    bool clearClosedAt = false,
    DateTime? createdAt,
  }) {
    return VcsPullRequestEntity(
      id: id ?? this.id,
      integrationId: integrationId ?? this.integrationId,
      taskId: taskId ?? this.taskId,
      prNumber: prNumber ?? this.prNumber,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      sourceBranch: sourceBranch ?? this.sourceBranch,
      targetBranch: targetBranch ?? this.targetBranch,
      state: state ?? this.state,
      openedAt: openedAt ?? this.openedAt,
      mergedAt: clearMergedAt ? null : (mergedAt ?? this.mergedAt),
      closedAt: clearClosedAt ? null : (closedAt ?? this.closedAt),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        integrationId,
        taskId,
        prNumber,
        title,
        authorName,
        sourceBranch,
        targetBranch,
        state,
        openedAt,
        mergedAt,
        closedAt,
        createdAt,
      ];
}
