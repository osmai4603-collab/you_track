import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_subsystems_use_case.dart';

import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_members_use_case.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_builds_use_case.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_sprints_use_case.dart';
import '../../../../core/usecase/usecase.dart';

import 'issue_form_state.dart';

class IssueFormCubit extends Cubit<IssueFormState> {
  final IssuesRepository repository;
  final GetProjectsUseCase getProjectsUseCase;
  final GetProjectMembersUseCase getProjectMembersUseCase;
  final GetBuildsUseCase getBuildsUseCase;
  final GetSprintsUseCase getSprintsUseCase;
  final GetSubsystemsUseCase getSubsystemsUseCase;

  IssueFormCubit({
    required this.repository,
    required this.getProjectsUseCase,
    required this.getProjectMembersUseCase,
    required this.getBuildsUseCase,
    required this.getSprintsUseCase,
    required this.getSubsystemsUseCase,
  }) : super(const IssueFormState());

  void initWithProject(String projectKey) {
    emit(state.copyWith(projectKey: projectKey));
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final result = await getProjectsUseCase(params: NoParams());
    result.fold(
      (failure) => null, // Silently ignore or handle error if needed
      (projects) {
        emit(state.copyWith(availableProjects: projects));
        _loadProjectDependenciesFor(state.projectKey, projects);
      },
    );
  }

  Future<void> _loadProjectDependenciesFor(
    String? projectKey,
    List<ProjectEntity> projects,
  ) async {
    if (projectKey == null || projects.isEmpty) return;
    try {
      final project = projects.firstWhere((p) => p.projectId == projectKey);

      final membersResult = await getProjectMembersUseCase(
        params: GetProjectMembersParams(projectId: project.id),
      );
      membersResult.fold(
        (failure) => null,
        (members) => emit(state.copyWith(projectMembers: members)),
      );

      final sprintsResult = await getSprintsUseCase(
        params: GetSprintsParams(projectId: project.id),
      );
      sprintsResult.fold(
        (failure) => null,
        (sprints) => emit(state.copyWith(availableSprints: sprints)),
      );

      final buildsResult = await getBuildsUseCase(
        params: GetBuildsParams(projectId: project.id),
      );
      buildsResult.fold(
        (failure) => null,
        (builds) => emit(state.copyWith(availableBuilds: builds)),
      );

      final subsystemsResult = await getSubsystemsUseCase(
        params: GetSubsystemsParams(projectId: project.id),
      );
      subsystemsResult.fold(
        (failure) => null,
        (subsystems) => emit(state.copyWith(availableSubsystems: subsystems)),
      );
    } catch (e) {
      // Ignore if project not found
    }
  }

  Future<void> loadIssue(String issueId) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    final result = await repository.getIssueById(issueId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (issue) {
        initWithIssue(issue);
        emit(state.copyWith(isLoading: false));
        _loadProjects();
      },
    );
  }

  void initWithIssue(Issue issue) {
    emit(
      IssueFormState(
        summary: issue.summary,
        description: issue.description,
        priority: issue.priority,
        state: issue.state,
        issueType: issue.issueType,
        assigneeId: issue.assigneeId,
        assigneeName: issue.assigneeName,
        estimation: issue.estimation,
        spentTime: issue.spentTime,
        visibility: issue.visibility,
        tags: issue.tags,
        sprints: issue.sprints,
        links: issue.links,
        build: issue.build,
        isEditing: true,
        issueId: issue.id,
        projectKey: issue.issueKey,
      ),
    );
  }

  void updateSummary(String value) {
    emit(state.copyWith(summary: value));
  }

  void updateProjectKey(String value) {
    emit(state.copyWith(projectKey: value, clearAssignee: true));
    _loadProjectDependenciesFor(value, state.availableProjects);
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

  void updateAssignee(String? userId, String? userName) {
    emit(state.copyWith(assigneeId: userId, assigneeName: userName));
  }

  void clearAssignee() {
    emit(state.copyWith(clearAssignee: true));
  }

  void updateSubsystem(SubsystemEntity? value) {
    emit(state.copyWith(subsystem: value));
  }

  void updateFixVersions(String value) {
    emit(state.copyWith(fixVersions: value));
  }

  void updateBuild(Build? value) {
    emit(state.copyWith(build: value));
  }

  void addBuild(Build build) {
    emit(
      state.copyWith(
        build: build,
        availableBuilds: [...state.availableBuilds, build],
      ),
    );
  }

  void updateEstimation(Duration? value) {
    emit(state.copyWith(estimation: value, clearEstimation: value == null));
  }

  void updateSpentTime(Duration? value) {
    emit(state.copyWith(spentTime: value, clearSpentTime: value == null));
  }

  void updateVisibility(List<String> value) {
    emit(state.copyWith(visibility: value));
  }

  void updateTags(List<Tag> value) {
    emit(state.copyWith(tags: value));
  }

  void addTag(Tag tag) {
    if (!state.tags.any((t) => t.id == tag.id)) {
      emit(state.copyWith(tags: [...state.tags, tag]));
    }
  }

  void removeTag(String tagId) {
    emit(state.copyWith(tags: state.tags.where((t) => t.id != tagId).toList()));
  }

  void addLink(IssueLink link) {
    if (!state.links.any((l) => l.id == link.id)) {
      emit(state.copyWith(links: [...state.links, link]));
    }
  }

  void removeLink(String linkId) {
    emit(
      state.copyWith(links: state.links.where((l) => l.id != linkId).toList()),
    );
  }

  void updateSprints(List<Sprint> value) {
    emit(state.copyWith(sprints: value));
  }

  void addSprint(Sprint sprint) {
    if (!state.sprints.any((s) => s.id == sprint.id)) {
      emit(state.copyWith(sprints: [...state.sprints, sprint]));
    }
  }

  void removeSprint(String sprintId) {
    emit(
      state.copyWith(
        sprints: state.sprints.where((s) => s.id != sprintId).toList(),
      ),
    );
  }

  void addAttachment(IssueAttachment attachment) {
    emit(state.copyWith(attachments: [...state.attachments, attachment]));
  }

  void updateAttachmentProgress(String attachmentId, double progress) {
    final updated = state.attachments.map((a) {
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
    emit(state.copyWith(attachments: updated));
  }

  void removeAttachment(String attachmentId) {
    final updated = state.attachments
        .where((a) => a.id != attachmentId)
        .toList();
    emit(state.copyWith(attachments: updated));
  }

  bool _validate() {
    final errors = <String, String>{};
    if (state.summary.trim().isEmpty) {
      errors['summary'] = 'Summary is required';
    } else if (state.summary.length > 255) {
      errors['summary'] = 'Summary must be 255 characters or less';
    }
    for (final attachment in state.attachments) {
      if (attachment.fileSize > 25 * 1024 * 1024) {
        errors['attachment_${attachment.id}'] = 'File exceeds 25 MB limit';
      }
    }
    if (state.attachments.length > 10) {
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

    final issue = Issue(
      id: state.issueId ?? '',
      issueKey: state.projectKey ?? '',
      issueNumber: 0,
      summary: state.summary.trim(),
      description: state.description,
      priority: state.priority,
      state: state.state,
      issueType: state.issueType,
      assigneeId: state.assigneeId,
      assigneeName: state.assigneeName,
      reporterId: userSession.currentUser?.id ?? 'anonymous',
      reporterName: userSession.currentUser?.email ?? 'Anonymous',
      subsystemId: state.subsystem?.id,
      fixVersions: state.fixVersions,
      build: state.build,
      tags: state.tags,
      createdAt: now,
      updatedAt: now,
      estimation: state.estimation,
      spentTime: state.spentTime,
      visibility: state.visibility,
      sprints: state.sprints,
      links: state.links,
    );

    if (state.isEditing && state.issueId != null) {
      final result = await repository.updateIssue(issue);
      result.fold(
        (failure) => emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        ),
        (_) => emit(state.copyWith(isSubmitting: false)),
      );
    } else {
      final result = await repository.createIssue(issue);
      result.fold(
        (failure) => emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        ),
        (issue) => emit(state.copyWith(isSubmitting: false, issueId: issue.id)),
      );
    }
  }

  Future<void> delete() async {
    if (state.issueId == null) return;

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));
    final result = await repository.deleteIssue(state.issueId!);
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

    final result = await repository.uploadAttachment(
      issueId: state.issueId!,
      filePath: file.path,
      fileName: fileName,
      onProgress: (progress) =>
          updateAttachmentProgress(attachment.id, progress),
    );

    result.fold(
      (failure) {
        final updated = state.attachments.map((a) {
          if (a.id == attachment.id) {
            return a.copyWith(status: AttachmentStatus.error);
          }
          return a;
        }).toList();
        emit(state.copyWith(attachments: updated));
      },
      (storagePath) {
        final updated = state.attachments.map((a) {
          if (a.id == attachment.id) {
            return a.copyWith(
              storagePath: storagePath,
              status: AttachmentStatus.uploaded,
              uploadProgress: 1.0,
            );
          }
          return a;
        }).toList();
        emit(state.copyWith(attachments: updated));
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
}
