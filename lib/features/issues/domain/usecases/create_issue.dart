import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

final class CreateIssue extends UseCase<Issue, IssueParams> {
  final IssuesRepository repository;

  CreateIssue(this.repository);

  @override
  Future<Either<Failure, Issue>> call({required IssueParams params}) async {
    return await repository.createIssue(params.issue);
  }

  @override
  Permission get requiredPermission => Permission.createIssue;
}

final class IssueParams extends Params {
  final Issue issue;

  const IssueParams({required this.issue});

  @override
  List<Object?> get props => [issue];
}

final class UpdateIssue extends UseCase<Issue, IssueParams> {
  final IssuesRepository repository;

  UpdateIssue(this.repository);

  @override
  Future<Either<Failure, Issue>> call({required IssueParams params}) async {
    return await repository.updateIssue(params.issue);
  }

  @override
  Permission get requiredPermission => Permission.updateIssue;
}

final class DeleteIssue extends UseCase<void, IssueParams> {
  final IssuesRepository repository;

  DeleteIssue(this.repository);

  @override
  Future<Either<Failure, void>> call({required IssueParams params}) async {
    return await repository.deleteIssue(params.issue.id);
  }

  @override
  Permission get requiredPermission => Permission.deleteIssue;
}

final class AttachmentParams extends Params {
  final String issueId;
  final String filePath;
  final String fileName;
  final void Function(double progress) onProgress;

  const AttachmentParams({
    required this.issueId,
    required this.filePath,
    required this.fileName,
    required this.onProgress,
  });

  @override
  List<Object?> get props => [issueId, filePath, fileName, onProgress];
}

final class UploadAttachment extends UseCase<String, AttachmentParams> {
  final IssuesRepository repository;

  UploadAttachment(this.repository);

  @override
  Future<Either<Failure, String>> call({
    required AttachmentParams params,
  }) async {
    return await repository.uploadAttachment(
      issueId: params.issueId,
      filePath: params.filePath,
      fileName: params.fileName,
      onProgress: params.onProgress,
    );
  }

  @override
  Permission get requiredPermission => Permission.addAttachment;
}
