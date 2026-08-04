import 'package:issues_tracking/core/enums/project_template_enum.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import '../../../../core/entities/entity.dart';

class ProjectEntity extends Entity {
  final String id;
  final String name;
  final String projectKey;
  final String? description;
  final bool isArchived;
  final ProjectTemplateType templateType;
  final String ownerId;
  final DateTime createdAt;
  final bool isFavorite;
  final List<ProjectMemberEntity> members;
  final String? visibility;
  final List<String> recommendedVisibility;
  final bool hasTimeTracking;
  final int? estimation;
  final int? spentTime;
  final int? startingNumber;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.projectKey,
    this.description,
    this.isArchived = false,
    required this.templateType,
    required this.ownerId,
    required this.createdAt,
    this.isFavorite = false,
    this.members = const [],
    this.visibility,
    this.recommendedVisibility = const [],
    this.hasTimeTracking = false,
    this.estimation,
    this.spentTime,
    this.startingNumber,
  });

  @override
  ProjectEntity copyWith({
    String? id,
    String? name,
    String? projectKey,
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
    bool? hasTimeTracking,
    int? estimation,
    int? spentTime,
    int? startingNumber,
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      projectKey: projectKey ?? this.projectKey,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      templateType: templateType ?? this.templateType,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      members: members ?? this.members,
      visibility: visibility ?? this.visibility,
      recommendedVisibility:
          recommendedVisibility ?? this.recommendedVisibility,
      hasTimeTracking: hasTimeTracking ?? this.hasTimeTracking,
      estimation: estimation ?? this.estimation,
      spentTime: spentTime ?? this.spentTime,
      startingNumber: startingNumber ?? this.startingNumber,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    projectKey,
    description,
    isArchived,
    templateType,
    ownerId,
    createdAt,
    isFavorite,
    members,
    visibility,
    recommendedVisibility,
    hasTimeTracking,
    estimation,
    spentTime,
    startingNumber,
  ];
}
