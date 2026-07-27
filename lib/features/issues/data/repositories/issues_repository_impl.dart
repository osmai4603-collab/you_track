import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/data/datasources/issues_remote_data_source.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

class IssuesRepositoryImpl implements IssuesRepository {
  final IssuesRemoteDataSource dataSource;

  IssuesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter) async {
    try {
      final issues = await dataSource.getIssues(filter);
      return Right(issues);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> getIssueById(String id) async {
    try {
      final issue = await dataSource.getIssueById(id);
      return Right(issue);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllTags() async {
    try {
      final tags = await dataSource.getAllTags();
      return Right(tags);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> createIssue({
    required String projectKey,
    required String title,
    required String description,
    required IssuePriorityTypeEnum priority,
    required IssueStateEnum state,
    required IssueTypeEnum issueType,
    String? assigneeId,
    String? subsystem,
    String? fixVersions,
    String? fixedInBuild,
    Duration? estimation,
    List<String> visibility = const ['team'],
    String? parentId,
  }) async {
    try {
      final issueData = {
        'project_key': projectKey,
        'title': title,
        'description': description,
        'state': state.name,
        'priority': priority.name,
        'issue_type': issueType.name,
        'assignee_id': assigneeId,
        'reporter_id': '',
        'reporter_name': '',
        'tags': [],
        'visibility': visibility,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'estimation': estimation?.inMinutes,
        'parent_id': parentId,
      };
      final issue = await dataSource.createIssue(issueData);
      return Right(issue);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> updateIssue({
    required String issueId,
    String? title,
    String? description,
    IssuePriorityTypeEnum? priority,
    IssueStateEnum? state,
    IssueTypeEnum? issueType,
    String? assigneeId,
    bool clearAssignee = false,
    String? subsystem,
    String? fixVersions,
    String? fixedInBuild,
    Duration? estimation,
    Duration? spentTime,
    List<String>? visibility,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (priority != null) updates['priority'] = priority.name;
      if (state != null) updates['state'] = state.name;
      if (issueType != null) updates['issue_type'] = issueType.name;
      if (clearAssignee) {
        updates['assignee_id'] = null;
        updates['assignee_name'] = null;
        updates['assignee_avatar_url'] = null;
      } else if (assigneeId != null) {
        updates['assignee_id'] = assigneeId;
      }
      if (estimation != null) updates['estimation'] = estimation.inMinutes;
      if (spentTime != null) updates['spent_time'] = spentTime.inMinutes;
      if (visibility != null) updates['visibility'] = visibility;

      final issue = await dataSource.updateIssue(issueId, updates);
      return Right(issue);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIssue(String issueId) async {
    try {
      await dataSource.deleteIssue(issueId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final storagePath = await dataSource.uploadAttachment(
        issueId: issueId,
        filePath: filePath,
        fileName: fileName,
        onProgress: onProgress,
      );
      return Right(storagePath);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttachment({
    required String issueId,
    required String storagePath,
  }) async {
    try {
      await dataSource.deleteAttachment(storagePath);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IssueAttachment>>> getAttachments(
    String issueId,
  ) async {
    try {
      final files = await dataSource.getAttachments(issueId);
      final attachments = files
          .map((f) => IssueAttachment(
                id: f['path'] ?? '',
                fileName: f['name'] ?? '',
                fileSize: (f['size'] ?? 0) as int,
                mimeType: f['mimeType'] ?? 'application/octet-stream',
                storagePath: f['path'],
                status: AttachmentStatus.uploaded,
              ))
          .toList();
      return Right(attachments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
