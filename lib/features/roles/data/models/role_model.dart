import 'package:flutter/foundation.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class RoleModel extends RoleEntity {
  const RoleModel({required super.name, super.description, required super.permissions});

  factory RoleModel.fromJson(Map<String, dynamic> data) {
    printMap(title: 'Role', data: data);
    debugPrint('data: $data');
    return RoleModel(
      name: (data['name'] ?? '').toString(),
      description: data['description']?.toString(),
      permissions:
          (data['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'permissions': permissions};
  }
}
