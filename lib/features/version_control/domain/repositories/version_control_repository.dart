import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_pull_request_entity.dart';

abstract class VersionControlRepository {
  // Integrations
  Future<Either<Failure, List<VcsIntegrationEntity>>> getIntegrations(
      String projectId);

  Future<Either<Failure, VcsIntegrationEntity>> getIntegrationById(
      String integrationId);

  Future<Either<Failure, VcsIntegrationEntity>> createIntegration(
      VcsIntegrationEntity integration);

  Future<Either<Failure, VcsIntegrationEntity>> updateIntegration(
      VcsIntegrationEntity integration);

  Future<Either<Failure, void>> deleteIntegration(String integrationId);

  Future<Either<Failure, VcsIntegrationEntity>> testConnection(
      String integrationId);

  // User Mappings
  Future<Either<Failure, List<VcsUserMappingEntity>>> getUserMappings(
      String integrationId);

  Future<Either<Failure, VcsUserMappingEntity>> createUserMapping(
      VcsUserMappingEntity mapping);

  Future<Either<Failure, void>> deleteUserMapping(String mappingId);

  // Commits
  Future<Either<Failure, List<VcsCommitEntity>>> getCommits(
      String integrationId,
      {String? taskId});

  Future<Either<Failure, VcsCommitEntity>> createCommit(
      VcsCommitEntity commit);

  // Pull Requests
  Future<Either<Failure, List<VcsPullRequestEntity>>> getPullRequests(
      String integrationId,
      {String? taskId});

  Future<Either<Failure, VcsPullRequestEntity>> createPullRequest(
      VcsPullRequestEntity pullRequest);

  Future<Either<Failure, VcsPullRequestEntity>> updatePullRequest(
      VcsPullRequestEntity pullRequest);
}
