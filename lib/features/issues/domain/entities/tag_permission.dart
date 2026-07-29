import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_permission_type_enum.dart';

class TagPermission extends Entity {
  final String id;
  final String tagId;
  final TagPermissionType permissionType;
  final TagPermissionScope scope;
  final List<String> userIds;

  const TagPermission({
    required this.id,
    required this.tagId,
    required this.permissionType,
    required this.scope,
    this.userIds = const [],
  });

  @override
  TagPermission copyWith({
    String? id,
    String? tagId,
    TagPermissionType? permissionType,
    TagPermissionScope? scope,
    List<String>? userIds,
  }) {
    return TagPermission(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      permissionType: permissionType ?? this.permissionType,
      scope: scope ?? this.scope,
      userIds: userIds ?? this.userIds,
    );
  }

  @override
  List<Object?> get props => [id, tagId, permissionType, scope, userIds];
}
