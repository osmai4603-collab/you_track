import '../../../../core/entities/entity.dart';

class ProjectEntity extends Entity {
  final String id;
  final String name;
  final String projectKey;
  final String? description;
  final bool isArchived;
  final bool isTemplate;
  final String? templateId;
  final String owner;
  final DateTime createdAt;
  final bool isFavorite;
  final List<String> memberInitials;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.projectKey,
    this.description,
    this.isArchived = false,
    this.isTemplate = false,
    this.templateId,
    required this.owner,
    required this.createdAt,
    this.isFavorite = false,
    this.memberInitials = const [],
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
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      projectKey: issueKey ?? this.projectKey,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      isTemplate: isTemplate ?? this.isTemplate,
      templateId: templateId ?? this.templateId,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      memberInitials: memberInitials ?? this.memberInitials,
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
    owner,
    createdAt,
    isFavorite,
    memberInitials,
  ];
}
