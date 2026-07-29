import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import '../../../../core/entities/entity.dart';

class ProjectEntity extends Entity {
  final String id;
  final String name;
  final String projectKey;
  final String? description;
  final bool isArchived;
  final bool isTemplate;
  final String? templateId;
  final String ownerId;
  final DateTime createdAt;
  final bool isFavorite;
  final List<ProjectMemberEntity> members;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.projectKey,
    this.description,
    this.isArchived = false,
    this.isTemplate = false,
    this.templateId,
    required this.ownerId,
    required this.createdAt,
    this.isFavorite = false,
    this.members = const [],
  });

  @override
  ProjectEntity copyWith({
    String? id,
    String? name,
    String? issueKey,
    String? description,
    bool? isArchived,
    bool? isTemplate,
    String? templateId,
    String? owner,
    DateTime? createdAt,
    bool? isFavorite,
    List<String>? memberInitials,
    List<ProjectMemberEntity>? members,
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      projectKey: issueKey ?? this.projectKey,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      isTemplate: isTemplate ?? this.isTemplate,
      templateId: templateId ?? this.templateId,
      ownerId: owner ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    projectKey,
    description,
    isArchived,
    isTemplate,
    templateId,
    ownerId,
    createdAt,
    isFavorite,
    members,
  ];
}
