import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';

abstract class GroupsRepository {
  Future<Either<Failure, List<GroupEntity>>> getGroups();
  Future<Either<Failure, GroupEntity>> getGroupById(String id);
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group);
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group);
  Future<Either<Failure, void>> deleteGroup(String id);

  Future<Either<Failure, GroupRoleAssignmentEntity>> assignRole(GroupRoleAssignmentEntity assignment);
  Future<Either<Failure, List<GroupRoleAssignmentEntity>>> getGroupRoles(String groupId);

  Future<Either<Failure, List<GroupMemberEntity>>> getGroupMembers(String groupId);
  Future<Either<Failure, List<GroupMemberEntity>>> addGroupMembers(String groupId, List<String> userIds);
  Future<Either<Failure, void>> removeGroupMembers(String groupId, List<String> userIds);

  Future<Either<Failure, List<GroupProjectEntity>>> addGroupProjects(String groupId, List<String> projectIds);
}
