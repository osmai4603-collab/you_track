import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';

class GroupEntity extends Entity {
  final String id;
  final String name;
  final String? description;
  final String? logo;
  final bool autoJoin;
  final List<String> autoJoinDomains;
  final String twoFactorAuth;
  final List<String> visibleTo;
  final String updatableBy;
  final String groupType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<GroupMemberEntity> members;
  final List<GroupRoleAssignmentEntity> roles;
  final List<GroupProjectEntity> projects;
  final String? avatarUrl;

  const GroupEntity({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    this.autoJoin = false,
    this.autoJoinDomains = const [],
    this.twoFactorAuth = 'optional',
    this.visibleTo = const [],
    this.updatableBy = 'all_users',
    this.groupType = 'users',
    this.createdAt,
    this.updatedAt,
    this.members = const [],
    this.roles = const [],
    this.projects = const [],
    this.avatarUrl,
  });

  @override
  GroupEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    bool? autoJoin,
    List<String>? autoJoinDomains,
    String? twoFactorAuth,
    List<String>? visibleTo,
    String? updatableBy,
    String? groupType,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<GroupMemberEntity>? members,
    List<GroupRoleAssignmentEntity>? roles,
    List<GroupProjectEntity>? projects,
    String? avatarUrl,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      autoJoin: autoJoin ?? this.autoJoin,
      autoJoinDomains: autoJoinDomains ?? this.autoJoinDomains,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      visibleTo: visibleTo ?? this.visibleTo,
      updatableBy: updatableBy ?? this.updatableBy,
      groupType: groupType ?? this.groupType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      members: members ?? this.members,
      roles: roles ?? this.roles,
      projects: projects ?? this.projects,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    logo,
    autoJoin,
    autoJoinDomains,
    twoFactorAuth,
    visibleTo,
    updatableBy,
    groupType,
    createdAt,
    updatedAt,
    avatarUrl,
    members,
    roles,
    projects,
  ];
}
