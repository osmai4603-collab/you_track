import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/groups/domain/entities/group_entity.dart';
import 'package:youtrack_frontend/features/groups/domain/entities/group_member_entity.dart';
import 'package:youtrack_frontend/features/groups/domain/entities/group_project_entity.dart';
import 'package:youtrack_frontend/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/groups_repository.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  @override
  Future<Either<Failure, List<GroupMemberEntity>>> addGroupMembers(
    String groupId,
    List<String> userIds,
  ) {
    // TODO: implement addGroupMembers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GroupProjectEntity>>> addGroupProjects(
    String groupId,
    List<String> projectIds,
  ) {
    // TODO: implement addGroupProjects
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GroupRoleAssignmentEntity>> assignRole(
    GroupRoleAssignmentEntity assignment,
  ) {
    // TODO: implement assignRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) {
    // TODO: implement createGroup
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String id) {
    // TODO: implement deleteGroup
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String id) {
    // TODO: implement getGroupById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> getGroupMembers(
    String groupId,
  ) {
    // TODO: implement getGroupMembers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GroupRoleAssignmentEntity>>> getGroupRoles(
    String groupId,
  ) {
    // TODO: implement getGroupRoles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups({String? userId}) {
    // TODO: implement getGroups
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeGroupMembers(
    String groupId,
    List<String> userIds,
  ) {
    // TODO: implement removeGroupMembers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeGroupRole(
    String groupId,
    String projectId,
  ) {
    // TODO: implement removeGroupRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group) {
    // TODO: implement updateGroup
    throw UnimplementedError();
  }
}
