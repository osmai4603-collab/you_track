import '../../../../core/entities/entity.dart';

class ProjectMemberEntity extends Entity {
  final String id;
  final String projectId;
  final String name;
  final String email;
  final List<String> roles;
  final String? avatarUrl;
  final bool isOwner;

  const ProjectMemberEntity({
    required this.id,
    required this.projectId,
    required this.name,
    required this.email,
    required this.roles,
    this.avatarUrl,
    this.isOwner = false,
  });

  @override
  ProjectMemberEntity copyWith({
    String? id,
    String? projectId,
    String? name,
    String? email,
    List<String>? roles,
    String? avatarUrl,
    bool? isOwner,
  }) {
    return ProjectMemberEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  @override
  List<Object?> get props => [id, projectId, name, email, roles, avatarUrl, isOwner];
}
