import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:issues_tracking/features/groups/data/models/group_model.dart';
import 'package:issues_tracking/features/groups/data/models/group_role_assignment_model.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource dataSource;

  GroupsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups() async {
    try {
      final groups = await dataSource.getGroups();
      return Right(groups);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String id) async {
    try {
      final group = await dataSource.getGroupById(id);
      return Right(group);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) async {
    try {
      final model = GroupModel.fromEntity(group);
      final created = await dataSource.createGroup(model);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group) async {
    try {
      final model = GroupModel.fromEntity(group);
      final updated = await dataSource.updateGroup(model.id, model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String id) async {
    try {
      await dataSource.deleteGroup(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupRoleAssignmentEntity>> assignRole(
    GroupRoleAssignmentEntity assignment,
  ) async {
    try {
      final model = GroupRoleAssignmentModel.fromEntity(assignment);
      final created = await dataSource.assignRole(model);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupRoleAssignmentEntity>>> getGroupRoles(
    String groupId,
  ) async {
    try {
      final roles = await dataSource.getGroupRoles(groupId);
      return Right(roles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> getGroupMembers(
    String groupId,
  ) async {
    try {
      final members = await dataSource.getGroupMembers(groupId);
      return Right(members);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> addGroupMembers(
    String groupId,
    List<String> userIds,
  ) async {
    try {
      final members = await dataSource.addGroupMembers(groupId, userIds);
      return Right(members);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupProjectEntity>>> addGroupProjects(
    String groupId,
    List<String> projectIds,
  ) async {
    try {
      final projects = await dataSource.addGroupProjects(groupId, projectIds);
      return Right(projects);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
