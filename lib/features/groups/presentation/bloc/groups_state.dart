import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object?> get props => [];
}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<GroupEntity> groups;
  final String? selectedGroupId;

  const GroupsLoaded({
    required this.groups,
    this.selectedGroupId,
  });

  GroupsLoaded copyWith({
    List<GroupEntity>? groups,
    String? selectedGroupId,
    bool clearSelected = false,
  }) {
    return GroupsLoaded(
      groups: groups ?? this.groups,
      selectedGroupId: clearSelected ? null : (selectedGroupId ?? this.selectedGroupId),
    );
  }

  @override
  List<Object?> get props => [groups, selectedGroupId];
}

class GroupsError extends GroupsState {
  final String message;
  const GroupsError(this.message);

  @override
  List<Object?> get props => [message];
}
