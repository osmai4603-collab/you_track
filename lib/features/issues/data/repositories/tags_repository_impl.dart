import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import '../../domain/entities/tag.dart';
import '../../domain/entities/project_member.dart';
import '../../domain/repositories/tags_repository.dart';
import '../datasources/tag_remote_datasource.dart';

class TagsRepositoryImpl implements TagsRepository {
  final TagRemoteDatasource dataSource;

  TagsRepositoryImpl(this.dataSource);

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
    required List<TagSubscriptionEvent> subscriptions,
  }) async {
    try {
      final tag = await dataSource.createTag(
        name: name,
        projectId: projectId,
        ownerId: ownerId,
        shared: shared,
        removeOnResolution: removeOnResolution,
        favorite: favorite,
        permissions: permissions.map((key, value) => MapEntry(key, value.name)),
        specificUserIds: specificUserIds,
        subscriptionEvents: subscriptions.map((e) => e.name).toList(),
      );
      return Right(tag);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> associateTagWithIssue({
    required String issueId,
    required String tagId,
  }) async {
    try {
      await dataSource.associateTagWithIssue(issueId: issueId, tagId: tagId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectMember>>> getProjectMembers({
    required String projectId,
  }) async {
    try {
      final membersData = await dataSource.getProjectMembers(projectId: projectId);
      final members = membersData.map((e) {
        final userData = e['users'] as Map<String, dynamic>?;
        return ProjectMember(
          id: e['user_id']?.toString() ?? e['id']?.toString() ?? '',
          name: userData?['full_name']?.toString() ?? e['name']?.toString() ?? 'Unknown',
          email: userData?['email']?.toString() ?? e['email']?.toString(),
          avatarUrl: userData?['avatar_url']?.toString() ?? e['avatar_url']?.toString(),
        );
      }).toList();
      return Right(members);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isTagNameUnique({
    required String name,
    required String projectId,
  }) async {
    try {
      final isUnique = await dataSource.isTagNameUnique(name: name, projectId: projectId);
      return Right(isUnique);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
