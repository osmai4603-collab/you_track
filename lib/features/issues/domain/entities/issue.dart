import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';

class Issue extends Entity {
  final String id;
  final String issueKey;
  final int issueNumber;
  final String summary;
  final String description;
  final IssueStateEnum state;
  final IssuePriorityTypeEnum priority;
  final IssueTypeEnum issueType;
  final String? assigneeId;
  final String? assigneeName;
  final String? assigneeAvatarUrl;
  final String reporterId;
  final String reporterName;
  final String? subsystemId;
  final String fixVersions;
  final Build? build;
  final List<Tag> tags;
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
  final List<String> visibility;
  final List<Sprint> sprints;
  final List<IssueLink> links;

  const Issue({
    required this.id,
    required this.issueKey,
    required this.issueNumber,
    required this.summary,
    this.description = '',
    this.state = IssueStateEnum.toDo,
    this.priority = IssuePriorityTypeEnum.normal,
    this.issueType = IssueTypeEnum.task,
    this.assigneeId,
    this.assigneeName,
    this.assigneeAvatarUrl,
    required this.reporterId,
    required this.reporterName,
    this.subsystemId,
    this.fixVersions = '',
    this.build,
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
    this.visibility = const ['team'],
    this.sprints = const [],
    this.links = const [],
  });

  @override
  Issue copyWith({
    String? id,
    String? projectId,
    int? issueNumber,
    String? summary,
    String? description,
    IssueStateEnum? state,
    IssuePriorityTypeEnum? priority,
    IssueTypeEnum? issueType,
    String? assigneeId,
    String? assigneeName,
    String? assigneeAvatarUrl,
    bool clearAssignee = false,
    String? reporterId,
    String? reporterName,
    String? subsystemId,
    String? fixVersions,
    Build? build,
    bool clearBuild = false,
    List<Tag>? tags,
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
    List<String>? visibility,
    List<Sprint>? sprints,
    List<IssueLink>? links,
  }) {
    return Issue(
      id: id ?? this.id,
      issueKey: issueKey,
      issueNumber: issueNumber ?? this.issueNumber,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      state: state ?? this.state,
      priority: priority ?? this.priority,
      issueType: issueType ?? this.issueType,
      assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
      assigneeName: clearAssignee ? null : (assigneeName ?? this.assigneeName),
      assigneeAvatarUrl: clearAssignee
          ? null
          : (assigneeAvatarUrl ?? this.assigneeAvatarUrl),
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      subsystemId: subsystemId ?? this.subsystemId,
      fixVersions: fixVersions ?? this.fixVersions,
      build: clearBuild ? null : (build ?? this.build),
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
      visibility: visibility ?? this.visibility,
      sprints: sprints ?? this.sprints,
      links: links ?? this.links,
    );
  }

  @override
  List<Object?> get props => [
    id,
    issueKey,
    issueNumber,
    summary,
    description,
    state,
    priority,
    issueType,
    assigneeId,
    assigneeName,
    assigneeAvatarUrl,
    reporterId,
    reporterName,
    subsystemId,
    fixVersions,
    build,
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
    visibility,
    sprints,
    links,
  ];
}
