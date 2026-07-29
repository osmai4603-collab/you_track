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
