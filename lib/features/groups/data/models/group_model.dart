import 'dart:convert';

import 'package:issues_tracking/core/entities/project_data.dart';
import 'package:issues_tracking/core/entities/user_data.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

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
    super.members,
    super.roles,
    super.projects,
    super.avatarUrl,
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
      members: entity.members,
      roles: entity.roles,
      projects: entity.projects,
      avatarUrl: entity.avatarUrl,
    );
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Group', data: json);
    List<GroupMemberEntity> members = const [];
    if (json['group_members'] != null) {
      members = (json['group_members'] as List<dynamic>).map((e) {
        UserData? user;
        if (e['users'] != null) {
          final u = e['users'];
          user = UserData(
            id: (u['id'] ?? '').toString(),
            userName: (u['user_name'] ?? '').toString(),
            email: (u['email'] ?? '').toString(),
            avatarUrl: u['avatar_url']?.toString(),
          );
        }
        return GroupMemberEntity(
          id: (e['id'] ?? '').toString(),
          userId: (e['user_id'] ?? '').toString(),
          groupId: (e['group_id'] ?? '').toString(),
          user: user,
        );
      }).toList();
    }

    List<GroupRoleAssignmentEntity> roles = const [];
    if (json['group_roles'] != null) {
      roles = (json['group_roles'] as List<dynamic>).map((e) {
        ProjectData? project;
        if (e['projects'] != null) {
          final p = e['projects'];
          project = ProjectData(
            id: (p['id'] ?? '').toString(),
            projectName: (p['name'] ?? '').toString(),
            projectId: (p['project_id'] ?? (p['key'] ?? '')).toString(),
          );
        }
        return GroupRoleAssignmentEntity(
          id: (e['id'] ?? '').toString(),
          groupId: (e['group_id'] ?? '').toString(),
          roleName: (e['role_name'] ?? '').toString(),
          projectId: e['project_id']?.toString(),
          project: project,
        );
      }).toList();
    }

    List<GroupProjectEntity> projects = const [];
    if (json['group_projects'] != null) {
      projects = (json['group_projects'] as List<dynamic>).map((e) {
        ProjectData? project;
        if (e['projects'] != null) {
          final p = e['projects'];
          project = ProjectData(
            id: (p['id'] ?? '').toString(),
            projectName: (p['name'] ?? '').toString(),
            projectId: (p['project_id'] ?? (p['key'] ?? '')).toString(),
          );
        }
        return GroupProjectEntity(
          id: (e['id'] ?? '').toString(),
          groupId: (e['group_id'] ?? '').toString(),
          projectId: (e['project_id'] ?? '').toString(),
          project: project,
        );
      }).toList();
    }

    return GroupModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      logo: json['logo']?.toString(),
      autoJoin: json['auto_join'] == true,
      autoJoinDomains: json['auto_join_domains'] != null
          ? (json['auto_join_domains'] is List
                ? (json['auto_join_domains'] as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                : (jsonDecode(json['auto_join_domains'].toString())
                          as List<dynamic>)
                      .map((e) => e.toString())
                      .toList())
          : [],
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
      members: members,
      roles: roles,
      avatarUrl: json['avatar_url'],
      projects: projects,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'auto_join': autoJoin,
      'auto_join_domains': autoJoinDomains,
      'two_factor_auth': twoFactorAuth,
      'visible_to': visibleTo,
      'updatable_by': updatableBy,
      'group_type': groupType,
      'avatar_url': avatarUrl,
    };

    if (createdAt != null) {
      data['created_at'] = createdAt?.toIso8601String();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt?.toIso8601String();
    }
    return data;
  }
}
