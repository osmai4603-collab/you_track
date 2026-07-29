import 'package:issues_tracking/core/entities/entity.dart';

class RoleEntity extends Entity {
  final String id;
  final String name;
  final List<String> permissions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.permissions,
    this.createdAt,
    this.updatedAt,
  });

  @override
  RoleEntity copyWith({
    String? id,
    String? name,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, permissions, createdAt, updatedAt];
}
