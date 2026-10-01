import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/groups_repository.dart';
import 'package:issues_tracking/core/entities/project_data.dart';
import 'package:issues_tracking/core/entities/user_data.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsApi _api;

  GroupsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> addGroupMembers(
    String groupId,
    List<String> userIds,
  ) async {
    final result = await _api.addMembers(groupId, userIds);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_memberFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<GroupProjectEntity>>> addGroupProjects(
    String groupId,
    List<String> projectIds,
  ) async {
    final result = await _api.addProjects(groupId, projectIds);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_projectFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, GroupRoleAssignmentEntity>> assignRole(
    GroupRoleAssignmentEntity assignment,
  ) async {
    final result = await _api.assignRole(_roleToJson(assignment));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_roleFromJson(result.data));
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) async {
    final result = await _api.createGroup(_groupToJson(group));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_groupFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String id) async {
    final result = await _api.deleteGroup(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String id) async {
    final result = await _api.getGroup(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_groupFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> getGroupMembers(
    String groupId,
  ) async {
    final result = await _api.getMembers(groupId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_memberFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<GroupRoleAssignmentEntity>>> getGroupRoles(
    String groupId,
  ) async {
    final result = await _api.getRoles(groupId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_roleFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups({String? userId}) async {
    final result = await _api.getGroups(userID: userId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_groupFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> removeGroupMembers(
    String groupId,
    List<String> userIds,
  ) async {
    final result = await _api.removeMembers(groupId, userIds);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> removeGroupRole(
    String groupId,
    String projectId,
  ) async {
    final result = await _api.removeRole(
      groupID: groupId,
      projectID: projectId,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group) async {
    final result = await _api.updateGroup(group.id, _groupToJson(group));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_groupFromJson(result.data));
  }
}

GroupEntity _groupFromJson(JsonObject json) => GroupEntity(
  id: _string(json, 'id'),
  name: _string(json, 'name'),
  description: _nullableString(json, 'description'),
  logo: _nullableString(json, 'logo'),
  autoJoin: json['autoJoin'] == true || json['auto_join'] == true,
  autoJoinDomains: _stringList(
    json['autoJoinDomains'] ?? json['auto_join_domains'],
  ),
  twoFactorAuth: _string(json, 'twoFactorAuth', fallback: 'optional'),
  visibleTo: _stringList(json['visibleTo'] ?? json['visible_to']),
  updatableBy: _string(json, 'updatableBy', fallback: 'all_users'),
  groupType: _string(json, 'groupType', fallback: 'users'),
  createdAt: _date(json['createdAt'] ?? json['created_at']),
  updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
  avatarUrl: _nullableString(json, 'avatarUrl'),
);

JsonObject _groupToJson(GroupEntity group) => {
  'name': group.name,
  'description': group.description,
  'logo': group.logo,
  'autoJoin': group.autoJoin,
  'autoJoinDomains': group.autoJoinDomains,
  'twoFactorAuth': group.twoFactorAuth,
  'visibleTo': group.visibleTo,
  'updatableBy': group.updatableBy,
  'groupType': group.groupType,
};

GroupMemberEntity _memberFromJson(JsonObject json) {
  final rawUser = json['user'];
  final user = rawUser is Map ? Map<String, dynamic>.from(rawUser) : null;
  return GroupMemberEntity(
    id: _string(json, 'id'),
    userId: _string(json, 'userId', fallback: _string(user ?? {}, 'id')),
    groupId: _string(json, 'groupId'),
    user: user == null
        ? null
        : UserData(
            id: _string(user, 'id'),
            userName: _string(
              user,
              'username',
              fallback: _string(user, 'userName'),
            ),
            email: _string(user, 'email'),
            avatarUrl: _nullableString(user, 'avatarUrl'),
          ),
  );
}

GroupProjectEntity _projectFromJson(JsonObject json) {
  final rawProject = json['project'];
  final project = rawProject is Map
      ? Map<String, dynamic>.from(rawProject)
      : null;
  return GroupProjectEntity(
    id: _string(json, 'id'),
    groupId: _string(json, 'groupId'),
    projectId: _string(
      json,
      'projectId',
      fallback: _string(project ?? {}, 'id'),
    ),
    project: project == null
        ? null
        : ProjectData(
            id: _string(project, 'id'),
            projectId: _string(project, 'shortName'),
            projectName: _string(project, 'name'),
          ),
  );
}

GroupRoleAssignmentEntity _roleFromJson(JsonObject json) {
  final rawProject = json['project'];
  final project = rawProject is Map
      ? Map<String, dynamic>.from(rawProject)
      : null;
  return GroupRoleAssignmentEntity(
    id: _string(json, 'id'),
    groupId: _string(json, 'groupId'),
    roleName: _string(json, 'roleName'),
    projectId: _nullableString(json, 'projectId'),
    project: project == null
        ? null
        : ProjectData(
            id: _string(project, 'id'),
            projectId: _string(project, 'shortName'),
            projectName: _string(project, 'name'),
          ),
  );
}

JsonObject _roleToJson(GroupRoleAssignmentEntity assignment) => {
  'id': assignment.id,
  'groupId': assignment.groupId,
  'roleName': assignment.roleName,
  'projectId': assignment.projectId,
};

String _string(JsonObject json, String key, {String fallback = ''}) =>
    (json[key] ?? fallback).toString();

String? _nullableString(JsonObject json, String key) {
  final value = json[key];
  return value == null || value.toString().isEmpty ? null : value.toString();
}

List<String> _stringList(Object? value) => value is List
    ? value.map((item) => item.toString()).toList(growable: false)
    : const [];

DateTime? _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return DateTime.tryParse(value);
  return null;
}
