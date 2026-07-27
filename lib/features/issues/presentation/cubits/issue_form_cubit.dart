import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

import 'issue_form_state.dart';

class IssueFormCubit extends Cubit<IssueFormState> {
  final IssuesRepository repository;

  IssueFormCubit({required this.repository}) : super(const IssueFormState());

  void initWithProject(String projectKey) {
    emit(state.copyWith(projectKey: projectKey));
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
        isEditing: true,
        issueId: issue.id,
        projectKey: issue.issueKey,
      ),
    );
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

  void updateAssignee(String? userId, String? userName) {
    emit(state.copyWith(assigneeId: userId, assigneeName: userName));
  }

  void clearAssignee() {
    emit(state.copyWith(clearAssignee: true));
  }

  void updateSubsystem(String value) {
    emit(state.copyWith(subsystem: value));
  }

  void updateFixVersions(String value) {
    emit(state.copyWith(fixVersions: value));
  }

  void updateFixedInBuild(String value) {
    emit(state.copyWith(fixedInBuild: value));
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

    if (state.isEditing && state.issueId != null) {
      final result = await repository.updateIssue(
        issueId: state.issueId!,
        title: state.summary.trim(),
        description: state.description,
        priority: state.priority,
        state: state.state,
        issueType: state.issueType,
        assigneeId: state.assigneeId,
        estimation: state.estimation,
        spentTime: state.spentTime,
        visibility: state.visibility,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        ),
        (_) => emit(state.copyWith(isSubmitting: false)),
      );
    } else {
      final result = await repository.createIssue(
        projectKey: state.projectKey ?? '',
        title: state.summary.trim(),
        description: state.description,
        priority: state.priority,
        state: state.state,
        issueType: state.issueType,
        assigneeId: state.assigneeId,
        estimation: state.estimation,
        visibility: state.visibility,
      );
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
