import 'package:issues_tracking/core/entities/entity.dart';

class RoleEntity extends Entity {
  final String name;
  final String? description;
  final List<String> permissions;

  const RoleEntity({required this.name, this.description, required this.permissions});

  @override
  RoleEntity copyWith({String? name, String? description, List<String>? permissions}) {
    return RoleEntity(
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [name, description, permissions];
}
