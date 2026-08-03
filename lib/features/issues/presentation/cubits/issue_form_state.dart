import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/entities/project_data.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
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
  final ProjectMemberEntity? assignee;
  final SubsystemEntity? subsystem;
  final String fixVersions;
  final Build? build;
  final Duration? estimation;
  final Duration? spentTime;
  final Map<String, String> validationErrors;
  final bool isSubmitting;
  final bool isLoading;
  final String? issueId;
  final ProjectEntity? project;
  final String? errorMessage;


 bool get isEditing => issueId != null;
  const IssueFormState({
    this.summary = '',
    this.description = '',
    this.descriptionFormat = DescriptionFormat.visual,
    this.priority = IssuePriorityTypeEnum.normal,
    this.state = IssueStateEnum.toDo,
    this.issueType = IssueTypeEnum.task,
    this.assignee,
    this.subsystem,
    this.fixVersions = '',
    this.build,
    this.estimation,
    this.spentTime,
    this.validationErrors = const {},
    this.isSubmitting = false,
    this.isLoading = false,
    this.issueId,
    this.project,
    this.errorMessage,
  });

  bool get isDirty =>
      summary.isNotEmpty ||
      description.isNotEmpty ||
      priority != IssuePriorityTypeEnum.normal ||
      state != IssueStateEnum.toDo ||
      issueType != IssueTypeEnum.task ||
      assignee != null ||
      subsystem != null ||
      fixVersions.isNotEmpty ||
      build != null ||
      estimation != null ||
      spentTime != null;

  bool get canSubmit => summary.trim().isNotEmpty && !isSubmitting;

  IssueFormState copyWith({
    String? summary,
    String? description,
    DescriptionFormat? descriptionFormat,
    IssuePriorityTypeEnum? priority,
    IssueStateEnum? state,
    IssueTypeEnum? issueType,
    ProjectMemberEntity? assignee,
    bool clearAssignee = false,
    SubsystemEntity? subsystem,
    String? fixVersions,
    Build? build,
    bool clearBuild = false,
    Duration? estimation,
    bool clearEstimation = false,
    Duration? spentTime,
    bool clearSpentTime = false,
    Map<String, String>? validationErrors,
    bool? isSubmitting,
    bool? isLoading,
    String? issueId,
    ProjectEntity? project,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return IssueFormState(
      summary: summary ?? this.summary,
      description: description ?? this.description,
      descriptionFormat: descriptionFormat ?? this.descriptionFormat,
      priority: priority ?? this.priority,
      state: state ?? this.state,
      issueType: issueType ?? this.issueType,
      assignee: clearAssignee ? null : (assignee ?? this.assignee),
      subsystem: subsystem ?? this.subsystem,
      fixVersions: fixVersions ?? this.fixVersions,
      build: clearBuild ? null : (build ?? this.build),
      estimation: clearEstimation ? null : (estimation ?? this.estimation),
      spentTime: clearSpentTime ? null : (spentTime ?? this.spentTime),
      validationErrors: validationErrors ?? this.validationErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
      issueId: issueId ?? this.issueId,
      project: project ?? this.project,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
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
    assignee,
    subsystem,
    fixVersions,
    build,
    estimation,
    spentTime,
    validationErrors,
    isSubmitting,
    isLoading,
    isEditing,
    issueId,
    project,
    errorMessage,
  ];
}
