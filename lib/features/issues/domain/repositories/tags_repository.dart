import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/error/failures.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import '../entities/tag.dart';
import '../entities/project_member.dart';

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
    required List<TagSubscriptionEvent> subscriptions,
  });

  Future<Either<Failure, void>> associateTagWithIssue({
    required String issueId,
    required String tagId,
  });

  Future<Either<Failure, List<ProjectMember>>> getProjectMembers({
    required String projectId,
  });

  Future<Either<Failure, bool>> isTagNameUnique({
    required String name,
    required String projectId,
  });
}
