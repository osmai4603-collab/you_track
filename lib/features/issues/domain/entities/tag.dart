import 'package:issues_tracking/core/entities/entity.dart';
import 'tag_permission.dart';
import 'tag_subscription.dart';

class Tag extends Entity {
  final String id;
  final String name;
  final String ownerId;
  final String projectId;
  final bool shared;
  final bool removeOnResolution;
  final bool favorite;
  final DateTime createdAt;
  final String createdBy;
  final List<TagPermission> permissions;
  final List<TagSubscription> subscriptions;

  const Tag({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.projectId,
    this.shared = true,
    this.removeOnResolution = true,
    this.favorite = false,
    required this.createdAt,
    required this.createdBy,
    this.permissions = const [],
    this.subscriptions = const [],
  });

  @override
  Tag copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? projectId,
    bool? shared,
    bool? removeOnResolution,
    bool? favorite,
    DateTime? createdAt,
    String? createdBy,
    List<TagPermission>? permissions,
    List<TagSubscription>? subscriptions,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      projectId: projectId ?? this.projectId,
      shared: shared ?? this.shared,
      removeOnResolution: removeOnResolution ?? this.removeOnResolution,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      permissions: permissions ?? this.permissions,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        ownerId,
        projectId,
        shared,
        removeOnResolution,
        favorite,
        createdAt,
        createdBy,
        permissions,
        subscriptions,
      ];
}
