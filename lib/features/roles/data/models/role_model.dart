import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';

class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.name,
    required super.permissions,
    super.createdAt,
    super.updatedAt,
  });

  factory RoleModel.fromEntity(RoleEntity entity) {
    return RoleModel(
      id: entity.id,
      name: entity.name,
      permissions: entity.permissions,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions': permissions,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
