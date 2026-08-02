import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';

import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';

class IssueFormState extends Equatable {
  final String summary;
  final String description;
  final DescriptionFormat descriptionFormat;
  final IssuePriorityTypeEnum priority;
  final IssueStateEnum state;
  final IssueTypeEnum issueType;
  final String? assigneeId;
  final String? assigneeName;
  final SubsystemEntity? subsystem;
  final String fixVersions;
  final Build? build;
  final Duration? estimation;
  final Duration? spentTime;
  final List<String> visibility;
  final List<Tag> tags;
  final List<Sprint> sprints;
  final List<IssueLink> links;
  final List<IssueAttachment> attachments;
  final List<ProjectEntity> availableProjects;
  final List<ProjectMemberEntity> projectMembers;
  final List<Sprint> availableSprints;
  final List<Build> availableBuilds;
  final Map<String, String> validationErrors;
  final bool isSubmitting;
  final bool isLoading;
  final bool isEditing;
  final String? issueId;
  final String? projectKey;
  final String? errorMessage;

  final List<SubsystemEntity> availableSubsystems;

  const IssueFormState({
    this.summary = '',
    this.description = '',
    this.descriptionFormat = DescriptionFormat.visual,
    this.priority = IssuePriorityTypeEnum.normal,
    this.state = IssueStateEnum.toDo,
    this.issueType = IssueTypeEnum.task,
    this.assigneeId,
    this.assigneeName,
    this.subsystem,
    this.fixVersions = '',
    this.build,
    this.estimation,
    this.spentTime,
    this.visibility = const ['team'],
    this.tags = const [],
    this.sprints = const [],
    this.links = const [],
    this.attachments = const [],
    this.availableProjects = const [],
    this.projectMembers = const [],
    this.availableSprints = const [],
    this.availableBuilds = const [],
    this.validationErrors = const {},
    this.isSubmitting = false,
    this.isLoading = false,
    this.isEditing = false,
    this.issueId,
    this.projectKey,
    this.errorMessage,
    this.availableSubsystems = const [],
  });

  bool get isDirty =>
      summary.isNotEmpty ||
      description.isNotEmpty ||
      priority != IssuePriorityTypeEnum.normal ||
      state != IssueStateEnum.toDo ||
      issueType != IssueTypeEnum.task ||
      assigneeId != null ||
      subsystem != IssueSubsystemEnum.noValue ||
      fixVersions.isNotEmpty ||
      build != null ||
      estimation != null ||
      spentTime != null ||
      visibility != const ['team'] ||
      tags.isNotEmpty ||
      sprints.isNotEmpty ||
      links.isNotEmpty ||
      attachments.isNotEmpty;

  bool get canSubmit => summary.trim().isNotEmpty && !isSubmitting;

  IssueFormState copyWith({
    String? summary,
    String? description,
    DescriptionFormat? descriptionFormat,
    IssuePriorityTypeEnum? priority,
    IssueStateEnum? state,
    IssueTypeEnum? issueType,
    String? assigneeId,
    String? assigneeName,
    bool clearAssignee = false,
    SubsystemEntity? subsystem,
    String? fixVersions,
    Build? build,
    bool clearBuild = false,
    Duration? estimation,
    bool clearEstimation = false,
    Duration? spentTime,
    bool clearSpentTime = false,
    List<String>? visibility,
    List<Tag>? tags,
    List<Sprint>? sprints,
    List<IssueLink>? links,
    List<IssueAttachment>? attachments,
    List<ProjectEntity>? availableProjects,
    List<ProjectMemberEntity>? projectMembers,
    List<Sprint>? availableSprints,
    List<Build>? availableBuilds,
    Map<String, String>? validationErrors,
    bool? isSubmitting,
    bool? isLoading,
    bool? isEditing,
    String? issueId,
    String? projectKey,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<SubsystemEntity>? availableSubsystems,
  }) {
    return IssueFormState(
      summary: summary ?? this.summary,
      description: description ?? this.description,
      descriptionFormat: descriptionFormat ?? this.descriptionFormat,
      priority: priority ?? this.priority,
      state: state ?? this.state,
      issueType: issueType ?? this.issueType,
      assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
      assigneeName: clearAssignee ? null : (assigneeName ?? this.assigneeName),
      subsystem: subsystem ?? this.subsystem,
      fixVersions: fixVersions ?? this.fixVersions,
      build: clearBuild ? null : (build ?? this.build),
      estimation: clearEstimation ? null : (estimation ?? this.estimation),
      spentTime: clearSpentTime ? null : (spentTime ?? this.spentTime),
      visibility: visibility ?? this.visibility,
      tags: tags ?? this.tags,
      sprints: sprints ?? this.sprints,
      links: links ?? this.links,
      attachments: attachments ?? this.attachments,
      availableProjects: availableProjects ?? this.availableProjects,
      projectMembers: projectMembers ?? this.projectMembers,
      availableSprints: availableSprints ?? this.availableSprints,
      availableBuilds: availableBuilds ?? this.availableBuilds,
      validationErrors: validationErrors ?? this.validationErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      issueId: issueId ?? this.issueId,
      projectKey: projectKey ?? this.projectKey,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      availableSubsystems: availableSubsystems ?? this.availableSubsystems,
    );
  }

  @override
  List<Object?> get props => [
    summary,
    description,
    descriptionFormat,
    priority,
    state,
    issueType,
    assigneeId,
    assigneeName,
    subsystem,
    fixVersions,
    build,
    estimation,
    spentTime,
    visibility,
    tags,
    sprints,
    links,
    attachments,
    availableProjects,
    projectMembers,
    availableSprints,
    availableBuilds,
    validationErrors,
    isSubmitting,
    isLoading,
    isEditing,
    issueId,
    projectKey,
    errorMessage,
    availableSubsystems,
  ];
}
