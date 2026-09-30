import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/core/enums/tag_permission_scope_enum.dart';
import 'package:youtrack_frontend/core/enums/tag_subscription_event_enum.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/issue_link.dart';
import 'package:youtrack_frontend/features/groups/domain/entities/group_entity.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/project_member.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/tag.dart';

abstract class TagsRepository {
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
  });

  Future<Either<Failure, void>> associateTagWithIssue({
    required String issueId,
    required String tagId,
  });

  Future<Either<Failure, List<ProjectMember>>> getProjectMembers({
    required String projectId,
  });

  Future<Either<Failure, List<GroupEntity>>> getProjectGroups({
    required String projectId,
  });

  Future<Either<Failure, bool>> isTagNameUnique({
    required String name,
    required String projectId,
  });

  Future<Either<Failure, List<Tag>>> getTagsByIssueId({
    required String issueId,
  });
  Future<Either<Failure, List<IssueLink>>> getLinksByIssueId({
    required String issueId,
  });
}
