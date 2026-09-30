import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/enums/tag_permission_scope_enum.dart';
import 'package:youtrack_frontend/core/enums/tag_subscription_event_enum.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/groups/domain/entities/group_entity.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/issue_link.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/project_member.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/tag.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/tags_repository.dart';

class TagsRepositoryImpl implements TagsRepository {
  @override
  Future<Either<Failure, void>> associateTagWithIssue({
    required String issueId,
    required String tagId,
  }) {
    // TODO: implement associateTagWithIssue
    throw UnimplementedError();
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
  }) {
    // TODO: implement createTag
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<IssueLink>>> getLinksByIssueId({
    required String issueId,
  }) {
    // TODO: implement getLinksByIssueId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getProjectGroups({
    required String projectId,
  }) {
    // TODO: implement getProjectGroups
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProjectMember>>> getProjectMembers({
    required String projectId,
  }) {
    // TODO: implement getProjectMembers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tag>>> getTagsByIssueId({
    required String issueId,
  }) {
    // TODO: implement getTagsByIssueId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isTagNameUnique({
    required String name,
    required String projectId,
  }) {
    // TODO: implement isTagNameUnique
    throw UnimplementedError();
  }
}
