import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';

class IssueFormState extends Equatable {
  final String summary;
  final String description;
  final DescriptionFormat descriptionFormat;
  final IssuePriorityTypeEnum priority;
  final IssueStateEnum state;
  final IssueTypeEnum issueType;
  final String? assigneeId;
  final String? assigneeName;
  final String subsystem;
  final String fixVersions;
  final String fixedInBuild;
  final Duration? estimation;
  final Duration? spentTime;
  final List<String> visibility;
  final List<IssueAttachment> attachments;
  final Map<String, String> validationErrors;
  final bool isSubmitting;
  final bool isEditing;
  final String? issueId;
  final String? projectKey;
  final String? errorMessage;

  const IssueFormState({
    this.summary = '',
    this.description = '',
    this.descriptionFormat = DescriptionFormat.visual,
    this.priority = IssuePriorityTypeEnum.normal,
    this.state = IssueStateEnum.toDo,
    this.issueType = IssueTypeEnum.task,
    this.assigneeId,
    this.assigneeName,
    this.subsystem = '',
    this.fixVersions = '',
    this.fixedInBuild = 'Next Build',
    this.estimation,
    this.spentTime,
    this.visibility = const ['team'],
    this.attachments = const [],
    this.validationErrors = const {},
    this.isSubmitting = false,
    this.isEditing = false,
    this.issueId,
    this.projectKey,
    this.errorMessage,
  });

  bool get isDirty =>
      summary.isNotEmpty ||
      description.isNotEmpty ||
      priority != IssuePriorityTypeEnum.normal ||
      state != IssueStateEnum.toDo ||
      issueType != IssueTypeEnum.task ||
      assigneeId != null ||
      subsystem.isNotEmpty ||
      fixVersions.isNotEmpty ||
      estimation != null ||
      spentTime != null ||
      visibility != const ['team'] ||
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
    String? subsystem,
    String? fixVersions,
    String? fixedInBuild,
    Duration? estimation,
    bool clearEstimation = false,
    Duration? spentTime,
    bool clearSpentTime = false,
    List<String>? visibility,
    List<IssueAttachment>? attachments,
    Map<String, String>? validationErrors,
    bool? isSubmitting,
    bool? isEditing,
    String? issueId,
    String? projectKey,
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
      assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
      assigneeName: clearAssignee ? null : (assigneeName ?? this.assigneeName),
      subsystem: subsystem ?? this.subsystem,
      fixVersions: fixVersions ?? this.fixVersions,
      fixedInBuild: fixedInBuild ?? this.fixedInBuild,
      estimation: clearEstimation ? null : (estimation ?? this.estimation),
      spentTime: clearSpentTime ? null : (spentTime ?? this.spentTime),
      visibility: visibility ?? this.visibility,
      attachments: attachments ?? this.attachments,
      validationErrors: validationErrors ?? this.validationErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isEditing: isEditing ?? this.isEditing,
      issueId: issueId ?? this.issueId,
      projectKey: projectKey ?? this.projectKey,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
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
        fixedInBuild,
        estimation,
        spentTime,
        visibility,
        attachments,
        validationErrors,
        isSubmitting,
        isEditing,
        issueId,
        projectKey,
        errorMessage,
      ];
}
