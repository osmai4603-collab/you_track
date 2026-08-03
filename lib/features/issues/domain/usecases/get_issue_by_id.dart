import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

class GetIssueById extends UseCase<Issue, GetIssueByIdParams> {
  final IssuesRepository repository;

  GetIssueById(this.repository);

  @override
  Future<Either<Failure, Issue>> call({
    required GetIssueByIdParams params,
  }) async {
    return await repository.getIssueById(params.id);
  }

  @override
  Permission get requiredPermission => Permission.issueReadIssue;

  @override
  String? getProjectId(GetIssueByIdParams params) => params.projectId;
}

class GetIssueByIdParams extends Params {
  final String id;
  final String? projectId;

  const GetIssueByIdParams({required this.id, this.projectId});

  @override
  List<Object?> get props => [id, projectId];
}
