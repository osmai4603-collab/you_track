import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';
import 'package:issues_tracking/features/issues/domain/entities/project_member.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/core/repositories/abstractions/tags_repository.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag_permission.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag_subscription.dart';
import 'package:issues_tracking/core/enums/tag_permission_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_link_type.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class TagsRepositoryImpl implements TagsRepository {
  final TagsApi _api;

  TagsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, void>> associateTagWithIssue({
    required String issueId,
    required String tagId,
  }) async {
    final result = await _api.associateWithIssue(
      issueID: issueId,
      tagID: tagId,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, Tag>> createTag({
    required String name,
    required String projectId,
    required String ownerId,
    required bool shared,
    required bool removeOnResolution,
    required bool favorite,
    required Map<String, TagPermissionScope> permissions,
    List<String>? specificUserIds,
    List<String>? specificGroupIds,
    required List<TagSubscriptionEvent> subscriptions,
  }) async {
    final result = await _api.createTag({
      'name': name,
      'projectId': projectId,
      'ownerId': ownerId,
      'shared': shared,
      'removeOnResolution': removeOnResolution,
      'favorite': favorite,
      'permissions': permissions.entries
          .map((entry) => {'type': entry.key, 'scope': entry.value.name})
          .toList(growable: false),
      'specificUserIds': specificUserIds ?? const <String>[],
      'specificGroupIds': specificGroupIds ?? const <String>[],
      'subscriptions': subscriptions.map((event) => event.name).toList(),
    });
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_tagFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<IssueLink>>> getLinksByIssueId({
    required String issueId,
  }) async {
    final result = await _api.getLinksByIssue(issueId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_issueLinkFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getProjectGroups({
    required String projectId,
  }) async {
    final result = await _api.getProjectGroups(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_groupFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<ProjectMember>>> getProjectMembers({
    required String projectId,
  }) async {
    final result = await _api.getProjectMembers(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_memberFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<Tag>>> getTagsByIssueId({
    required String issueId,
  }) async {
    final result = await _api.getTagsByIssue(issueId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_tagFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, bool>> isTagNameUnique({
    required String name,
    required String projectId,
  }) async {
    final result = await _api.isNameUnique(projectID: projectId, name: name);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data);
  }
}

Tag _tagFromJson(Map<String, dynamic> json) {
  final rawPermissions = json['permissions'];
  final permissions = rawPermissions is List
      ? rawPermissions
            .whereType<Map>()
            .map((raw) {
              final permission = Map<String, dynamic>.from(raw);
              final users = permission['userIds'] ?? permission['user_ids'];
              return TagPermission(
                id: _string(permission, const ['id']),
                tagId: _string(permission, const ['tagId', 'tag_id']),
                permissionType: TagPermissionType.of(
                  _string(permission, const ['type', 'permissionType']),
                ),
                scope: TagPermissionScope.of(
                  _string(permission, const ['scope']),
                ),
                userIds: users is List
                    ? users.map((value) => value.toString()).toList()
                    : const [],
              );
            })
            .toList(growable: false)
      : const <TagPermission>[];

  final rawSubscriptions = json['subscriptions'];
  final subscriptions = rawSubscriptions is List
      ? rawSubscriptions
            .whereType<Map>()
            .map((raw) {
              final subscription = Map<String, dynamic>.from(raw);
              return TagSubscription(
                id: _string(subscription, const ['id']),
                tagId: _string(subscription, const ['tagId', 'tag_id']),
                eventType: TagSubscriptionEvent.of(
                  _string(subscription, const [
                    'eventType',
                    'event_type',
                    'event',
                  ]),
                ),
              );
            })
            .toList(growable: false)
      : const <TagSubscription>[];

  return Tag(
    id: _string(json, const ['id']),
    name: _string(json, const ['name']),
    ownerId: _string(json, const ['ownerId', 'owner_id']),
    projectId: _string(json, const ['projectId', 'project_id']),
    shared: _bool(json, const ['shared']),
    removeOnResolution: _bool(json, const [
      'removeOnResolution',
      'remove_on_resolution',
    ]),
    favorite: _bool(json, const ['favorite']),
    createdAt: _date(json, const ['createdAt', 'created_at']),
    createdBy: _string(json, const ['createdBy', 'created_by']),
    permissions: permissions,
    subscriptions: subscriptions,
  );
}

IssueLink _issueLinkFromJson(Map<String, dynamic> json) {
  final rawType = _string(json, const ['linkType', 'link_type', 'type']);
  IssueLinkType type;
  try {
    type = IssueLinkType.of(rawType);
  } on ArgumentError {
    type = IssueLinkType.relatesTo;
  } on UnimplementedError {
    type = IssueLinkType.relatesTo;
  }
  return IssueLink(
    id: _string(json, const ['id']),
    issueId: _string(json, const ['issueId', 'issue_id']),
    linkType: type,
    issueLinkedId: _string(json, const [
      'issueLinkedId',
      'issue_linked_id',
      'linkedIssueId',
    ]),
  );
}

GroupEntity _groupFromJson(Map<String, dynamic> json) => GroupEntity(
  id: _string(json, const ['id']),
  name: _string(json, const ['name']),
  description: _nullableString(json, const ['description']),
  avatarUrl: _nullableString(json, const ['avatarUrl', 'avatar_url']),
);

ProjectMember _memberFromJson(Map<String, dynamic> json) => ProjectMember(
  id: _string(json, const ['id', 'userId', 'user_id']),
  name: _string(json, const ['name', 'fullName', 'full_name', 'username']),
  email: _nullableString(json, const ['email']),
  avatarUrl: _nullableString(json, const ['avatarUrl', 'avatar_url']),
);

String _string(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null) return value.toString();
  }
  return '';
}

String? _nullableString(Map<String, dynamic> json, List<String> keys) {
  final value = _string(json, keys);
  return value.isEmpty ? null : value;
}

bool _bool(Map<String, dynamic> json, List<String> keys) {
  final value = json[keys.firstWhere(json.containsKey, orElse: () => '')];
  if (value is bool) return value;
  return value?.toString().toLowerCase() == 'true';
}

DateTime _date(Map<String, dynamic> json, List<String> keys) {
  final value = json[keys.firstWhere(json.containsKey, orElse: () => '')];
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
