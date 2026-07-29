import 'package:issues_tracking/core/entities/entity.dart';

class ProjectMember extends Entity {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;

  const ProjectMember({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  @override
  ProjectMember copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return ProjectMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl];
}
