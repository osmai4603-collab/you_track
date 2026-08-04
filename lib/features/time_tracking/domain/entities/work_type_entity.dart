import '../../../../core/entities/entity.dart';

class WorkTypeEntity extends Entity {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkTypeEntity({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    this.isActive = true,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  WorkTypeEntity copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkTypeEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    name,
    description,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
  ];
}
