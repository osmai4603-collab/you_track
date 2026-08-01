import 'package:issues_tracking/core/enums/project_template_enum.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import '../../../../core/entities/entity.dart';

class ProjectEntity extends Entity {
  final String id;
  final String name;
  final String projectId;
  final String? description;
  final bool isArchived;
  final ProjectTemplateType templateType;
  final String ownerId;
  final DateTime createdAt;
  final bool isFavorite;
  final List<ProjectMemberEntity> members;
  final String? visibility;
  final List<String> recommendedVisibility;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.projectId,
    this.description,
    this.isArchived = false,
    required this.templateType,
    required this.ownerId,
    required this.createdAt,
    this.isFavorite = false,
    this.members = const [],
    this.visibility,
    this.recommendedVisibility = const [],
  });

  @override
  ProjectEntity copyWith({
    String? id,
    String? name,
    String? issueKey,
    String? description,
    bool? isArchived,
    ProjectTemplateType? templateType,
    String? ownerId,
    DateTime? createdAt,
    bool? isFavorite,
    List<String>? memberInitials,
    List<ProjectMemberEntity>? members,
    String? visibility,
    List<String>? recommendedVisibility,
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: issueKey ?? this.projectId,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      templateType: templateType ?? this.templateType,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      members: members ?? this.members,
      visibility: visibility ?? this.visibility,
      recommendedVisibility: recommendedVisibility ?? this.recommendedVisibility,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    projectId,
    description,
    isArchived,
    templateType,
    ownerId,
    createdAt,
    isFavorite,
    members,
    visibility,
    recommendedVisibility,
  ];
}
