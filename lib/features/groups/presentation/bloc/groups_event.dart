import 'package:equatable/equatable.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroups extends GroupsEvent {
  const LoadGroups();
}

class SelectGroup extends GroupsEvent {
  final String? groupId;
  const SelectGroup(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class CreateGroupEvent extends GroupsEvent {
  final String name;
  final String? description;

  const CreateGroupEvent({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class AssignRoleEvent extends GroupsEvent {
  final String groupId;
  final String roleName;
  final String? projectId;
  final bool isGlobal;

  const AssignRoleEvent({
    required this.groupId,
    required this.roleName,
    this.projectId,
    this.isGlobal = false,
  });

  @override
  List<Object?> get props => [groupId, roleName, projectId, isGlobal];
}

class AddGroupMembersEvent extends GroupsEvent {
  final String groupId;
  final List<String> userIds;

  const AddGroupMembersEvent({
    required this.groupId,
    required this.userIds,
  });

  @override
  List<Object?> get props => [groupId, userIds];
}

class AddGroupProjectsEvent extends GroupsEvent {
  final String groupId;
  final List<String> projectIds;

  const AddGroupProjectsEvent({
    required this.groupId,
    required this.projectIds,
  });

  @override
  List<Object?> get props => [groupId, projectIds];
}

class UpdateGroupSettingsEvent extends GroupsEvent {
  final String groupId;
  final String? name;
  final String? description;
  final bool? autoJoin;
  final List<String>? autoJoinDomains;
  final String? twoFactorAuth;
  final String? groupType;
  final String? logo;

  const UpdateGroupSettingsEvent({
    required this.groupId,
    this.name,
    this.description,
    this.autoJoin,
    this.autoJoinDomains,
    this.twoFactorAuth,
    this.groupType,
    this.logo,
  });

  @override
  List<Object?> get props => [
        groupId,
        name,
        description,
        autoJoin,
        autoJoinDomains,
        twoFactorAuth,
        groupType,
        logo,
      ];
}

class RemoveGroupRoleEvent extends GroupsEvent {
  final String groupId;
  final String projectId;

  const RemoveGroupRoleEvent({
    required this.groupId,
    required this.projectId,
  });

  @override
  List<Object> get props => [groupId, projectId];
}
