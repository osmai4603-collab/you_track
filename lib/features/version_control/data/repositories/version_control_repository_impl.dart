import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/version_control/data/datasources/version_control_remote_data_source.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_integration_model.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_user_mapping_model.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_commit_model.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_pull_request_model.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_pull_request_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class VersionControlRepositoryImpl implements VersionControlRepository {
  final VersionControlRemoteDataSource remoteDataSource;

  VersionControlRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VcsIntegrationEntity>>> getIntegrations(
      String projectId) async {
    try {
      final integrations = await remoteDataSource.getIntegrations(projectId);
      return Right(integrations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> getIntegrationById(
      String integrationId) async {
    try {
      final integration =
          await remoteDataSource.getIntegrationById(integrationId);
      return Right(integration);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> createIntegration(
      VcsIntegrationEntity integration) async {
    try {
      final model = VcsIntegrationModel.fromEntity(integration);
      final result = await remoteDataSource.createIntegration(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> updateIntegration(
      VcsIntegrationEntity integration) async {
    try {
      final model = VcsIntegrationModel.fromEntity(integration);
      final result = await remoteDataSource.updateIntegration(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIntegration(String integrationId) async {
    try {
      await remoteDataSource.deleteIntegration(integrationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> testConnection(
      String integrationId) async {
    try {
      final integration =
          await remoteDataSource.getIntegrationById(integrationId);
      return Right(integration);
    } catch (e) {
      return Left(ServerFailure('Connection failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<VcsUserMappingEntity>>> getUserMappings(
      String integrationId) async {
    try {
      final mappings = await remoteDataSource.getUserMappings(integrationId);
      return Right(mappings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsUserMappingEntity>> createUserMapping(
      VcsUserMappingEntity mapping) async {
    try {
      final model = VcsUserMappingModel.fromEntity(mapping);
      final result = await remoteDataSource.createUserMapping(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserMapping(String mappingId) async {
    try {
      await remoteDataSource.deleteUserMapping(mappingId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VcsCommitEntity>>> getCommits(
      String integrationId,
      {String? taskId}) async {
    try {
      final commits =
          await remoteDataSource.getCommits(integrationId, taskId: taskId);
      return Right(commits);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsCommitEntity>> createCommit(
      VcsCommitEntity commit) async {
    try {
      final model = VcsCommitModel.fromEntity(commit);
      final result = await remoteDataSource.createCommit(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VcsPullRequestEntity>>> getPullRequests(
      String integrationId,
      {String? taskId}) async {
    try {
      final prs =
          await remoteDataSource.getPullRequests(integrationId, taskId: taskId);
      return Right(prs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsPullRequestEntity>> createPullRequest(
      VcsPullRequestEntity pullRequest) async {
    try {
      final model = VcsPullRequestModel.fromEntity(pullRequest);
      final result = await remoteDataSource.createPullRequest(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VcsPullRequestEntity>> updatePullRequest(
      VcsPullRequestEntity pullRequest) async {
    try {
      final model = VcsPullRequestModel.fromEntity(pullRequest);
      final result = await remoteDataSource.updatePullRequest(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
