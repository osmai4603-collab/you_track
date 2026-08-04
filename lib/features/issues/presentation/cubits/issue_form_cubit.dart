import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/extensions/either_result.dart';
import 'package:issues_tracking/core/models/project_data_model.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/issues/domain/usecases/create_issue.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_by_issue.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issue_by_id.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_subsystems_use_case.dart';

import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_members_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/update_project_starting_number_use_case.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_builds_use_case.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_sprints_use_case.dart';
import '../../../../core/usecase/usecase.dart';

import 'issue_form_state.dart';

class IssueFormCubit extends Cubit<IssueFormState> {
  final GetProjectsUseCase getProjectsUseCase;
  final GetProjectMembersUseCase getProjectMembersUseCase;
  final UpdateProjectStartingNumberUseCase updateProjectStartingNumberUseCase;
  final GetBuildsUseCase getBuildsUseCase;
  final GetSprintsUseCase getSprintsUseCase;
  final GetSubsystemsUseCase getSubsystemsUseCase;
  final GetTagsByIssueId getTagsByIssueId;
  final GetLinksByIssueId getIssueLinksByIssueId;
  final GetIssueById getIssueById;
  final UpdateIssue updateIssue;
  final CreateIssue createIssue;
  final DeleteIssue deleteIssue;
  final UploadAttachment uploadAttachment;

  List<String> _visibility = [];
  List<String> get visibility => _visibility;

  List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  List<IssueLink> _links = [];
  List<IssueLink> get links => _links;

  List<IssueAttachment> _attachments = [];
  List<IssueAttachment> get attachments => _attachments;

  List<ProjectEntity> _availableProjects = [];
  List<ProjectEntity> get availableProjects => _availableProjects;

  List<ProjectMemberEntity> _projectMembers = [];
  List<ProjectMemberEntity> get projectMembers => _projectMembers;

  List<Sprint> _availableSprints = [];
  List<Sprint> get availableSprints => _availableSprints;

  List<Build> _availableBuilds = [];
  List<Build> get availableBuilds => _availableBuilds;

  List<SubsystemEntity> _subsystems = [];
  List<SubsystemEntity> get subsystems => _subsystems;

  IssueFormCubit({
    required this.getProjectsUseCase,
    required this.getProjectMembersUseCase,
    required this.getBuildsUseCase,
    required this.getSprintsUseCase,
    required this.getSubsystemsUseCase,
    required this.getIssueById,
    required this.updateIssue,
    required this.createIssue,
    required this.deleteIssue,
    required this.uploadAttachment,
    required this.getTagsByIssueId,
    required this.getIssueLinksByIssueId,
    required this.updateProjectStartingNumberUseCase,
  }) : super(const IssueFormState());

  void initIssue({String? issueId}) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    await loadProjects();
    if (issueId == null) {
      emit(state.copyWith(isLoading: false, clearErrorMessage: true));
      return;
    }

    ProjectMemberEntity? projectMember;
    ProjectEntity? project;
    SubsystemEntity? subsystem;
    Issue? issue;

    await getIssueLinksByIssueId(
      params: GetByIssueIdParams(issueId: issueId),
    ).then(
      (result) => result.fold((failure) {
        debugPrint('Error on get links');
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
      }, (links) => _links = links),
    );

    if (state.errorMessage != null) return;
    await getTagsByIssueId(params: GetByIssueIdParams(issueId: issueId)).then(
      (result) => result.fold((failure) {
        debugPrint('Error on get tags');
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
      }, (tags) => _tags = tags),
    );
    if (state.errorMessage != null) return;

    await getIssueById(params: GetIssueByIdParams(id: issueId)).then(
      (result) => result.fold((failure) {
        issue = null;
        debugPrint('Error on get issue');
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
      }, (issueResult) => issue = issueResult),
    );
    if (state.errorMessage != null) return;

    if (issue != null) {
      final result = await _initWithProjectChildren(issue!.projectId);
      if (result) return;
      projectMember = _projectMembers.cast<ProjectMemberEntity?>().firstWhere(
        (member) => member?.userId == issue!.assigneeId,
        orElse: () => null,
      );
      project = _availableProjects.cast<ProjectEntity?>().firstWhere(
        (project) => project?.id == issue!.projectId,
        orElse: () => null,
      );
      subsystem = _subsystems.cast<SubsystemEntity?>().firstWhere(
        (subsystem) => subsystem?.id == issue!.subsystemId,
        orElse: () => null,
      );
      return;
    }

    emit(
      IssueFormState(
        summary: issue?.summary ?? '',
        project: project,
        subsystem: subsystem,
        description: issue?.description ?? '',
        priority: issue?.priority ?? .normal,
        state: issue?.state ?? .toDo,
        issueType: issue?.issueType ?? .task,
        assignee: projectMember,
        estimation: issue?.estimation,
        spentTime: issue?.spentTime,
        build: issue?.build,
        issueId: issue?.id,
        isFavorite: issue?.isStarred ?? false,
        isLoading: false,
      ),
    );
  }

  Future<void> loadProjects() async {
    _availableProjects = await getProjectsUseCase().then(
      (result) => result.toNullable() ?? [],
    );
  }

  Future<bool> _initWithProjectChildren(String projectId) async {
    debugPrint('project_id: $projectId');
    await getSprintsUseCase(
      params: GetSprintsParams(projectId: projectId),
    ).then(
      (result) => result.fold((failure) {
        debugPrint('Error on get sprints');
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
      }, (tags) => _availableSprints = tags),
    );
    if (state.errorMessage != null) return false;
    debugPrint('get it sprints');

    await getProjectMembersUseCase(
      params: GetProjectMembersParams(projectId: projectId),
    ).then(
      (result) => result.fold((failure) {
        debugPrint('Error on get project members');
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
      }, (tags) => _projectMembers = tags),
    );
    if (state.errorMessage != null) return false;
    debugPrint('get it members');

    await getSubsystemsUseCase(
      params: GetSubsystemsParams(projectId: projectId),
    ).then(
      (result) => result.fold((failure) {
        debugPrint('Error on get subsystems');
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
      }, (tags) => _subsystems = tags),
    );
    if (state.errorMessage != null) return false;
    debugPrint('get it subsystems');

    await getBuildsUseCase(params: GetBuildsParams(projectId: projectId)).then(
      (result) => result.fold((failure) {
        emit(state.copyWith(errorMessage: failure.message, isLoading: false));
        debugPrint('Error on get issue builds');
      }, (tags) => _availableBuilds = tags),
    );
    if (state.errorMessage != null) return false;
    debugPrint('get it builds');
    return true;
  }

  void updateSummary(String value) {
    emit(state.copyWith(summary: value));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void updateDescriptionFormat(DescriptionFormat format) {
    emit(state.copyWith(descriptionFormat: format));
  }

  void updatePriority(IssuePriorityTypeEnum value) {
    emit(state.copyWith(priority: value));
  }

  void updateState(IssueStateEnum value) {
    emit(state.copyWith(state: value));
  }

  void updateIssueType(IssueTypeEnum value) {
    emit(state.copyWith(issueType: value));
  }

  void updateAssignee(ProjectMemberEntity? value) {
    if (value == null) {
      emit(state.copyWith(assignee: null));
      return;
    }

    if (!_projectMembers.any((s) => s.id == value.id)) {
      _projectMembers.add(value);
    }
    emit(state.copyWith(assignee: value));
  }

  void clearAssignee() {
    emit(state.copyWith(clearAssignee: true));
  }

  void updateSubsystem(SubsystemEntity value) {
    if (!_subsystems.any((s) => s.id == value.id)) {
      _subsystems = List<SubsystemEntity>.from(_subsystems)..add(value);
    }
    emit(state.copyWith(subsystem: value));
  }

  void updateFixVersions(String value) {
    emit(state.copyWith(fixVersions: value));
  }

  void updateBuild(Build? value) {
    emit(state.copyWith(build: value));
  }

  void addBuild(Build build) {
    emit(state.copyWith(build: build));
  }

  void updateEstimation(Duration? value) {
    emit(state.copyWith(estimation: value, clearEstimation: value == null));
  }

  void updateSpentTime(Duration? value) {
    emit(state.copyWith(spentTime: value, clearSpentTime: value == null));
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void updateVisibility(Map<String, List<String>> value) {
    emit(state.copyWith(visibility: value));
  }

  void updateTags(List<Tag> tags) {
    for (var tag in tags) {
      final index = _availableSprints.indexWhere((s) => s.id == tag.id);
      if (index > -1) {
        _tags[index] = tag;
      } else {
        _tags.add(tag);
      }
    }
    emit(state.copyWith());
  }

  void addTag(Tag tag) {
    if (!tags.any((t) => t.id == tag.id)) {
      emit(state.copyWith());
    }
  }

  void removeTag(String tagId) {
    _tags.removeWhere((t) => t.id == tagId);
    emit(state.copyWith());
  }

  void addLink(IssueLink link) {
    if (!links.any((l) => l.id == link.id)) {
      _links.add(link);
    }
    emit(state.copyWith());
  }

  void removeLink(String linkId) {
    _links.removeWhere((l) => l.id == linkId);
    emit(state.copyWith());
  }

  void updateSprints(List<Sprint> sprints) {
    for (var sprint in sprints) {
      final index = _availableSprints.indexWhere((s) => s.id == sprint.id);
      if (index > -1) {
        _availableSprints[index] = sprint;
      } else {
        _availableSprints.add(sprint);
      }
    }
    emit(state.copyWith());
  }

  void addSprint(Sprint sprint) {
    if (!_availableSprints.any((s) => s.id == sprint.id)) {
      _availableSprints.add(sprint);
      emit(state.copyWith());
    }
  }

  void removeSprint(String sprintId) {
    _availableSprints.removeWhere((s) => s.id == sprintId);

    emit(state.copyWith());
  }

  void addAttachment(IssueAttachment sprint) {
    if (!_availableSprints.any((s) => s.id == sprint.id)) {
      _attachments.add(sprint);
    }
    emit(state.copyWith());
  }

  void updateAttachmentProgress(String attachmentId, double progress) {
    attachments.map((a) {
      if (a.id == attachmentId) {
        return a.copyWith(
          uploadProgress: progress,
          status: progress >= 1.0
              ? AttachmentStatus.uploaded
              : AttachmentStatus.uploading,
        );
      }
      return a;
    }).toList();
    emit(state.copyWith());
  }

  void removeAttachment(String attachmentId) {
    _attachments.removeWhere((a) => a.id == attachmentId);
    emit(state.copyWith());
  }

  bool _validate() {
    final errors = <String, String>{};
    if (state.summary.trim().isEmpty) {
      errors['summary'] = 'Summary is required';
    } else if (state.summary.length > 255) {
      errors['summary'] = 'Summary must be 255 characters or less';
    }
    for (final attachment in attachments) {
      if (attachment.fileSize > 25 * 1024 * 1024) {
        errors['attachment_${attachment.id}'] = 'File exceeds 25 MB limit';
      }
    }
    if (attachments.length > 10) {
      errors['attachments'] = 'Maximum 10 attachments allowed';
    }
    emit(state.copyWith(validationErrors: errors));
    return errors.isEmpty;
  }

  Future<void> submit() async {
    if (!_validate()) return;
    if (!state.canSubmit) return;

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final userSession = get_it<UserSession>();
    final now = DateTime.now();

    final serialNumber = state.project?.startingNumber ?? 1;

    final issue = Issue(
      projectId: state.project!.id,
      id: state.issueId ?? '',
      issueKey: '${state.project?.projectKey ?? ''}-$serialNumber',
      issueNumber: serialNumber,
      summary: state.summary.trim(),
      description: state.description,
      priority: state.priority,
      state: state.state,
      issueType: state.issueType,
      assigneeId: state.assignee?.userId,
      reporterId: userSession.currentUser!.id,
      buildId: state.build?.id,
      subsystemId: state.subsystem?.id,
      fixVersions: state.fixVersions,
      build: state.build,
      tags: tags,
      createdAt: now,
      updatedAt: now,
      estimation: state.estimation,
      spentTime: state.spentTime,
      isStarred: state.isFavorite,
      visibility: state.visibility,
    );

    if (state.issueId != null) {
      final result = await updateIssue(params: IssueParams(issue: issue));
      result.fold(
        (failure) => emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        ),
        (_) => emit(state.copyWith(isSubmitting: false)),
      );
    } else {
      final result = await createIssue(params: IssueParams(issue: issue));
      result.fold(
        (failure) => emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        ),
        (issue) async {
          await _advanceProjectStartingNumber(serialNumber);
          emit(state.copyWith(isSubmitting: false, issueId: issue.id));
        },
      );
    }
  }

  Future<void> _advanceProjectStartingNumber(int serialNumber) async {
    final project = state.project;
    if (project == null) return;

    final nextValue = serialNumber + 1;
    final result = await updateProjectStartingNumberUseCase(
      params: UpdateProjectStartingNumberParams(
        projectId: project.id,
        startingNumber: nextValue,
      ),
    );
    if (result.isRight()) {
      emit(
        state.copyWith(project: project.copyWith(startingNumber: nextValue)),
      );
    }
  }

  Future<void> delete(Issue issue) async {
    if (state.issueId == null) return;

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));
    final result = await deleteIssue(params: IssueParams(issue: issue));
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(isSubmitting: false)),
    );
  }

  Future<void> uploadFile(File file) async {
    if (state.issueId == null) return;

    final fileName = file.path.split('/').last;
    final fileSize = await file.length();
    final attachment = IssueAttachment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      fileSize: fileSize,
      mimeType: _getMimeType(fileName),
      status: AttachmentStatus.pending,
    );
    addAttachment(attachment);

    final result = await uploadAttachment(
      params: AttachmentParams(
        issueId: state.issueId!,
        filePath: file.path,
        fileName: fileName,
        onProgress: (progress) =>
            updateAttachmentProgress(attachment.id, progress),
      ),
    );

    result.fold(
      (failure) {
        _attachments = attachments.map((a) {
          if (a.id == attachment.id) {
            return a.copyWith(status: AttachmentStatus.error);
          }
          return a;
        }).toList();
        emit(state.copyWith());
      },
      (storagePath) {
        _attachments = attachments.map((a) {
          if (a.id == attachment.id) {
            return a.copyWith(
              storagePath: storagePath,
              status: AttachmentStatus.uploaded,
              uploadProgress: 1.0,
            );
          }
          return a;
        }).toList();
        emit(state.copyWith());
      },
    );
  }

  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'log':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'zip':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }

  void updateProject(ProjectEntity project) async {
    await _initWithProjectChildren(project.id);
    emit(
      state.copyWith(
        project: project,
        subsystem: null,
        assignee: null,
        build: null,
      ),
    );
  }
}
