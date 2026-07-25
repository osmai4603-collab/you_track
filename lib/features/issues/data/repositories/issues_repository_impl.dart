import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
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
}
