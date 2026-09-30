import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:youtrack_frontend/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:youtrack_frontend/features/version_control/domain/entities/vcs_pull_request_entity.dart';
import 'package:youtrack_frontend/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/version_control_repository.dart';

class VersionControlRepositoryImpl implements VersionControlRepository {
  @override
  Future<Either<Failure, VcsCommitEntity>> createCommit(
    VcsCommitEntity commit,
  ) {
    // TODO: implement createCommit
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> createIntegration(
    VcsIntegrationEntity integration,
  ) {
    // TODO: implement createIntegration
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsPullRequestEntity>> createPullRequest(
    VcsPullRequestEntity pullRequest,
  ) {
    // TODO: implement createPullRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsUserMappingEntity>> createUserMapping(
    VcsUserMappingEntity mapping,
  ) {
    // TODO: implement createUserMapping
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteIntegration(String integrationId) {
    // TODO: implement deleteIntegration
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteUserMapping(String mappingId) {
    // TODO: implement deleteUserMapping
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<VcsCommitEntity>>> getCommits(
    String integrationId, {
    String? taskId,
  }) {
    // TODO: implement getCommits
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> getIntegrationById(
    String integrationId,
  ) {
    // TODO: implement getIntegrationById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<VcsIntegrationEntity>>> getIntegrations(
    String projectId,
  ) {
    // TODO: implement getIntegrations
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<VcsPullRequestEntity>>> getPullRequests(
    String integrationId, {
    String? taskId,
  }) {
    // TODO: implement getPullRequests
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<VcsUserMappingEntity>>> getUserMappings(
    String integrationId,
  ) {
    // TODO: implement getUserMappings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> testConnection(
    String integrationId,
  ) {
    // TODO: implement testConnection
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> updateIntegration(
    VcsIntegrationEntity integration,
  ) {
    // TODO: implement updateIntegration
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, VcsPullRequestEntity>> updatePullRequest(
    VcsPullRequestEntity pullRequest,
  ) {
    // TODO: implement updatePullRequest
    throw UnimplementedError();
  }
}
