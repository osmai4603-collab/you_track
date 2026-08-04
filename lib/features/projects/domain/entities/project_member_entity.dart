import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

import '../../../../core/entities/entity.dart';

class ProjectMemberEntity extends Entity {
  final String id;
  final String projectId;
  final List<String> roles;
  final bool isOwner;
  final String userId;
  final UserEntity? userData;

  String get name => userData?.username ?? '';
  String get userKey => userData?.userKey ?? '';
  String get email => userData?.email ?? '';
  String? get avatarUrl => userData?.avatarUrl;

  const ProjectMemberEntity({
    required this.id,
    required this.projectId,

    required this.roles,
    this.isOwner = false,
    required this.userId,
    this.userData,
  });

  @override
  ProjectMemberEntity copyWith({
    String? id,
    String? projectKey,
    List<String>? roles,
    bool? isOwner,
    String? userId,
    UserEntity? userData,
  }) {
    return ProjectMemberEntity(
      id: id ?? this.id,
      projectId: projectKey ?? this.projectId,
      roles: roles ?? this.roles,
      isOwner: isOwner ?? this.isOwner,
      userId: userId ?? this.userId,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [id, projectId, roles, isOwner, userId, userData];
}
