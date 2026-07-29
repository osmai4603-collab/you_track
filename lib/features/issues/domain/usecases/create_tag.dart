import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import '../entities/tag.dart';
import '../repositories/tags_repository.dart';

class CreateTag implements UseCase<Tag, CreateTagParams> {
  final TagsRepository repository;

  CreateTag(this.repository);

  @override
  Future<Either<Failure, Tag>> call({required CreateTagParams params}) {
    return repository.createTag(
      name: params.name,
      projectId: params.projectId,
      ownerId: params.ownerId,
      shared: params.shared,
      removeOnResolution: params.removeOnResolution,
      favorite: params.favorite,
      permissions: params.permissions,
      specificUserIds: params.specificUserIds,
      subscriptions: params.subscriptions,
    );
  }
}

class CreateTagParams extends Params {
  final String name;
  final String projectId;
  final String ownerId;
  final bool shared;
  final bool removeOnResolution;
  final bool favorite;
  final Map<String, TagPermissionScope> permissions;
  final List<String>? specificUserIds;
  final List<TagSubscriptionEvent> subscriptions;

  const CreateTagParams({
    required this.name,
    required this.projectId,
    required this.ownerId,
    required this.shared,
    required this.removeOnResolution,
    required this.favorite,
    required this.permissions,
    this.specificUserIds,
    required this.subscriptions,
  });

  @override
  List<Object?> get props => [
        name,
        projectId,
        ownerId,
        shared,
        removeOnResolution,
        favorite,
        permissions,
        specificUserIds,
        subscriptions,
      ];
}
