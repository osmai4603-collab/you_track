import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';

abstract class IssuesRepository {
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter);
  Future<Either<Failure, Issue>> getIssueById(String id);
  Future<Either<Failure, List<String>>> getAllTags();

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
  });

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
  });

  Future<Either<Failure, void>> deleteIssue(String issueId);

  Future<Either<Failure, String>> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  });

  Future<Either<Failure, void>> deleteAttachment({
    required String issueId,
    required String storagePath,
  });

  Future<Either<Failure, List<IssueAttachment>>> getAttachments(String issueId);
}
