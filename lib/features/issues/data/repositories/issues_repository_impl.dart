import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/data/models/build_model.dart';
import 'package:issues_tracking/features/issues/data/models/issue_model.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
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
  Stream<Issue> streamIssues(IssueFilter filter) {
    return dataSource.streamIssues(filter);
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
  Future<Either<Failure, List<Tag>>> getAllTags() async {
    try {
      final tags = await dataSource.getAllTags();
      return Right(tags);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Sprint>>> getSprints(String projectId) async {
    try {
      final sprints = await dataSource.getSprints(projectId);
      return Right(sprints);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Build>>> getBuilds(String projectId) async {
    try {
      final builds = await dataSource.getBuilds(projectId);
      return Right(builds);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Build>> createBuild(Build build) async {
    try {
      final buildModel = BuildModel(
        id: build.id,
        name: build.name,
        date: build.date,
        projectId: build.projectId,
      );
      final created = await dataSource.createBuild(buildModel.toJson());
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> createIssue(Issue issue) async {
    try {
      final createdIssue = await dataSource.createIssue(
        IssueModel.fromEntity(issue),
      );
      return Right(createdIssue);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> updateIssue(Issue issue) async {
    try {
      final updatedIssue = await dataSource.updateIssue(
        IssueModel.fromEntity(issue),
      );
      return Right(updatedIssue);
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
          .map(
            (f) => IssueAttachment(
              id: f['path'] ?? '',
              fileName: f['name'] ?? '',
              fileSize: (f['size'] ?? 0) as int,
              mimeType: f['mimeType'] ?? 'application/octet-stream',
              storagePath: f['path'],
              status: AttachmentStatus.uploaded,
            ),
          )
          .toList();
      return Right(attachments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
