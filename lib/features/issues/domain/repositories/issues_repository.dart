import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';

abstract class IssuesRepository {
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter);
  Stream<Issue> streamIssues(IssueFilter filter);
  Future<Either<Failure, Issue>> getIssueById(String id);
  Future<Either<Failure, List<Tag>>> getAllTags();
  Future<Either<Failure, List<Sprint>>> getSprints(String projectId);
  Future<Either<Failure, List<Build>>> getBuilds(String projectId);
  Future<Either<Failure, Build>> createBuild(Build build);

  Future<Either<Failure, Issue>> createIssue(Issue issue);

  Future<Either<Failure, Issue>> updateIssue(Issue issue);

  Future<Either<Failure, void>> updateIssueStarred(
    String issueId,
    bool isStarred,
  );

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
