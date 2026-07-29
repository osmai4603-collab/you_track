import 'dart:convert';

import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    super.description,
    super.logo,
    super.autoJoin,
    super.autoJoinDomains,
    super.twoFactorAuth,
    super.visibleTo,
    super.updatableBy,
    super.groupType,
    super.createdAt,
    super.updatedAt,
  });

  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      logo: entity.logo,
      autoJoin: entity.autoJoin,
      autoJoinDomains: entity.autoJoinDomains,
      twoFactorAuth: entity.twoFactorAuth,
      visibleTo: entity.visibleTo,
      updatableBy: entity.updatableBy,
      groupType: entity.groupType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      logo: json['logo']?.toString(),
      autoJoin: json['auto_join'] == true,
      autoJoinDomains: (json['auto_join_domains'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      twoFactorAuth: (json['two_factor_auth'] ?? 'optional').toString(),
      visibleTo: json['visible_to'] != null
              ? (json['visible_to'] is List
                  ? (json['visible_to'] as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                  : (jsonDecode(json['visible_to'].toString()) as List<dynamic>)
                      .map((e) => e.toString())
                      .toList())
              : [],
      updatableBy: (json['updatable_by'] ?? 'all_users').toString(),
      groupType: (json['group_type'] ?? 'users').toString(),
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
      'description': description,
      'logo': logo,
      'auto_join': autoJoin,
      'auto_join_domains': autoJoinDomains,
      'two_factor_auth': twoFactorAuth,
      'visible_to': visibleTo, // serialized as JSONB by Supabase driver
      'updatable_by': updatableBy,
      'group_type': groupType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
