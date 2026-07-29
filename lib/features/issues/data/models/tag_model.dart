import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_permission_type_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import '../../domain/entities/tag.dart';
import '../../domain/entities/tag_permission.dart';
import '../../domain/entities/tag_subscription.dart';

class TagModel extends Tag {
  const TagModel({
    required super.id,
    required super.name,
    required super.ownerId,
    required super.projectId,
    super.shared,
    super.removeOnResolution,
    super.favorite,
    required super.createdAt,
    required super.createdBy,
    super.permissions,
    super.subscriptions,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      ownerId: json['owner_id'].toString(),
      projectId: json['project_id'].toString(),
      shared: json['shared'] ?? true,
      removeOnResolution: json['remove_on_resolution'] ?? true,
      favorite: json['favorite'] ?? false,
      createdAt: DateTime.parse(json['created_at'].toString()),
      createdBy: json['created_by'].toString(),
      permissions: (json['tag_permissions'] as List? ?? [])
          .map((e) => TagPermissionModel.fromJson(e))
          .toList(),
      subscriptions: (json['tag_subscriptions'] as List? ?? [])
          .map((e) => TagSubscriptionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'owner_id': ownerId,
      'project_id': projectId,
      'shared': shared,
      'remove_on_resolution': removeOnResolution,
      'favorite': favorite,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}

class TagPermissionModel extends TagPermission {
  const TagPermissionModel({
    required super.id,
    required super.tagId,
    required super.permissionType,
    required super.scope,
    super.userIds,
  });

  factory TagPermissionModel.fromJson(Map<String, dynamic> json) {
    return TagPermissionModel(
      id: json['id'].toString(),
      tagId: json['tag_id'].toString(),
      permissionType: TagPermissionType.of(json['permission_type'].toString()),
      scope: TagPermissionScope.of(json['scope'].toString()),
      userIds: (json['tag_permission_users'] as List? ?? [])
          .map((e) => e['user_id'].toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'tag_id': tagId,
      'permission_type': permissionType.name,
      'scope': scope.name,
    };
  }
}

class TagSubscriptionModel extends TagSubscription {
  const TagSubscriptionModel({
    required super.id,
    required super.tagId,
    required super.eventType,
  });

  factory TagSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return TagSubscriptionModel(
      id: json['id'].toString(),
      tagId: json['tag_id'].toString(),
      eventType: TagSubscriptionEvent.of(json['event_type'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'tag_id': tagId,
      'event_type': eventType.name,
    };
  }
}
