import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import '../../domain/entities/project_member.dart';
import '../../domain/entities/tag.dart';

enum NewTagStatus { initial, loading, submitting, success, failure }

class NewTagState extends Equatable {
  final String name;
  final String? nameError;
  final String? ownerId;
  final List<ProjectMember> members;
  final List<GroupEntity> projectGroups;
  final NewTagStatus status;
  final String? errorMessage;

  // Options
  final bool shared;
  final bool removeOnResolution;
  final bool favorite;

  // Permissions
  final Map<String, TagPermissionScope> permissions;
  final List<String> specificUserIds;
  final List<String> specificGroupIds;

  // Subscriptions
  final List<TagSubscriptionEvent> subscriptions;

  final Tag? createdTag;

  const NewTagState({
    this.name = '',
    this.nameError,
    this.ownerId,
    this.members = const [],
    this.projectGroups = const [],
    this.status = NewTagStatus.initial,
    this.errorMessage,
    this.shared = true,
    this.removeOnResolution = true,
    this.favorite = false,
    this.permissions = const {
      'view': TagPermissionScope.allMembers,
      'use': TagPermissionScope.allMembers,
      'edit': TagPermissionScope.owner,
    },
    this.specificUserIds = const [],
    this.specificGroupIds = const [],
    this.subscriptions = const [],
    this.createdTag,
  });

  NewTagState copyWith({
    String? name,
    String? nameError,
    bool clearNameError = false,
    String? ownerId,
    List<ProjectMember>? members,
    List<GroupEntity>? projectGroups,
    NewTagStatus? status,
    String? errorMessage,
    bool? shared,
    bool? removeOnResolution,
    bool? favorite,
    Map<String, TagPermissionScope>? permissions,
    List<String>? specificUserIds,
    List<String>? specificGroupIds,
    List<TagSubscriptionEvent>? subscriptions,
    Tag? createdTag,
  }) {
    return NewTagState(
      name: name ?? this.name,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      projectGroups: projectGroups ?? this.projectGroups,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shared: shared ?? this.shared,
      removeOnResolution: removeOnResolution ?? this.removeOnResolution,
      favorite: favorite ?? this.favorite,
      permissions: permissions ?? this.permissions,
      specificUserIds: specificUserIds ?? this.specificUserIds,
      specificGroupIds: specificGroupIds ?? this.specificGroupIds,
      subscriptions: subscriptions ?? this.subscriptions,
      createdTag: createdTag ?? this.createdTag,
    );
  }

  @override
  List<Object?> get props => [
        name,
        nameError,
        ownerId,
        members,
        projectGroups,
        status,
        errorMessage,
        shared,
        removeOnResolution,
        favorite,
        permissions,
        specificUserIds,
        specificGroupIds,
        subscriptions,
        createdTag,
      ];
}
