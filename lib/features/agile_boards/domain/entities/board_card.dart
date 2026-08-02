import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';

class BoardCard extends Entity {
  final String id;
  final String issueKey;
  final String summary;
  final IssueStateEnum state;
  final IssuePriorityTypeEnum priority;
  final IssueTypeEnum issueType;
  final IssueSubsystemEnum subsystem;
  final String? assigneeAvatarUrl;
  final String? assigneeName;
  final Duration? estimation;
  final int totalSubtasks;
  final int completedSubtasks;

  const BoardCard({
    required this.id,
    required this.issueKey,
    required this.summary,
    required this.state,
    this.priority = IssuePriorityTypeEnum.normal,
    this.issueType = IssueTypeEnum.task,
    this.subsystem = IssueSubsystemEnum.noValue,
    this.assigneeAvatarUrl,
    this.assigneeName,
    this.estimation,
    this.totalSubtasks = 0,
    this.completedSubtasks = 0,
  });

  @override
  BoardCard copyWith({
    String? id,
    String? projectId,
    String? summary,
    IssueStateEnum? state,
    IssuePriorityTypeEnum? priority,
    IssueTypeEnum? issueType,
    IssueSubsystemEnum? subsystemId,
    String? assigneeAvatarUrl,
    bool clearAssigneeAvatarUrl = false,
    String? assigneeName,
    bool clearAssigneeName = false,
    Duration? estimation,
    bool clearEstimation = false,
    int? totalSubtasks,
    int? completedSubtasks,
  }) {
    return BoardCard(
      id: id ?? this.id,
      issueKey: projectId ?? issueKey,
      summary: summary ?? this.summary,
      state: state ?? this.state,
      priority: priority ?? this.priority,
      issueType: issueType ?? this.issueType,
      subsystem: subsystemId ?? this.subsystem,
      assigneeAvatarUrl: clearAssigneeAvatarUrl
          ? null
          : (assigneeAvatarUrl ?? this.assigneeAvatarUrl),
      assigneeName: clearAssigneeName
          ? null
          : (assigneeName ?? this.assigneeName),
      estimation: clearEstimation ? null : (estimation ?? this.estimation),
      totalSubtasks: totalSubtasks ?? this.totalSubtasks,
      completedSubtasks: completedSubtasks ?? this.completedSubtasks,
    );
  }

  @override
  List<Object?> get props => [
    id,
    issueKey,
    summary,
    state,
    priority,
    issueType,
    subsystem,
    assigneeAvatarUrl,
    assigneeName,
    estimation,
    totalSubtasks,
    completedSubtasks,
  ];
}
