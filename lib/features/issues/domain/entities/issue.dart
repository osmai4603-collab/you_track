import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_priority.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_state.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_type.dart';

class Issue extends Entity {
  final String id;
  final String projectKey;
  final int issueNumber;
  final String title;
  final String description;
  final IssueTrackState state;
  final IssuePriority priority;
  final IssueType issueType;
  final String? assigneeId;
  final String? assigneeName;
  final String? assigneeAvatarUrl;
  final String reporterId;
  final String reporterName;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final Duration? estimation;
  final Duration? spentTime;
  final int votes;
  final int watchersCount;
  final int attachmentsCount;
  final int commentsCount;
  final bool isStarred;
  final String? parentId;

  const Issue({
    required this.id,
    required this.projectKey,
    required this.issueNumber,
    required this.title,
    this.description = '',
    this.state = IssueTrackState.open,
    this.priority = IssuePriority.normal,
    this.issueType = IssueType.task,
    this.assigneeId,
    this.assigneeName,
    this.assigneeAvatarUrl,
    required this.reporterId,
    required this.reporterName,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.estimation,
    this.spentTime,
    this.votes = 0,
    this.watchersCount = 0,
    this.attachmentsCount = 0,
    this.commentsCount = 0,
    this.isStarred = false,
    this.parentId,
  });

  String get fullId => '$projectKey-$issueNumber';

  @override
  Issue copyWith({
    String? id,
    String? projectKey,
    int? issueNumber,
    String? title,
    String? description,
    IssueTrackState? state,
    IssuePriority? priority,
    IssueType? issueType,
    String? assigneeId,
    String? assigneeName,
    String? assigneeAvatarUrl,
    bool clearAssignee = false,
    String? reporterId,
    String? reporterName,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    bool clearDueDate = false,
    Duration? estimation,
    bool clearEstimation = false,
    Duration? spentTime,
    int? votes,
    int? watchersCount,
    int? attachmentsCount,
    int? commentsCount,
    bool? isStarred,
    String? parentId,
    bool clearParentId = false,
  }) {
    return Issue(
      id: id ?? this.id,
      projectKey: projectKey ?? this.projectKey,
      issueNumber: issueNumber ?? this.issueNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      state: state ?? this.state,
      priority: priority ?? this.priority,
      issueType: issueType ?? this.issueType,
      assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
      assigneeName: clearAssignee ? null : (assigneeName ?? this.assigneeName),
      assigneeAvatarUrl: clearAssignee ? null : (assigneeAvatarUrl ?? this.assigneeAvatarUrl),
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      estimation: clearEstimation ? null : (estimation ?? this.estimation),
      spentTime: spentTime ?? this.spentTime,
      votes: votes ?? this.votes,
      watchersCount: watchersCount ?? this.watchersCount,
      attachmentsCount: attachmentsCount ?? this.attachmentsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isStarred: isStarred ?? this.isStarred,
      parentId: clearParentId ? null : (parentId ?? this.parentId),
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectKey,
    issueNumber,
    title,
    description,
    state,
    priority,
    issueType,
    assigneeId,
    assigneeName,
    assigneeAvatarUrl,
    reporterId,
    reporterName,
    tags,
    createdAt,
    updatedAt,
    dueDate,
    estimation,
    spentTime,
    votes,
    watchersCount,
    attachmentsCount,
    commentsCount,
    isStarred,
    parentId,
  ];
}
