import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/usecases/create_group.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_groups.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GetGroups getGroups;
  final CreateGroup createGroup;

  GroupsBloc({required this.getGroups, required this.createGroup})
      : super(GroupsInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<SelectGroup>(_onSelectGroup);
    on<CreateGroupEvent>(_onCreateGroup);
  }

  Future<void> _onLoadGroups(
    LoadGroups event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading());
    final result = await getGroups(params: const NoParams());
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (groups) => emit(GroupsLoaded(groups: groups)),
    );
  }

  Future<void> _onSelectGroup(
    SelectGroup event,
    Emitter<GroupsState> emit,
  ) async {
    if (state is GroupsLoaded) {
      final current = state as GroupsLoaded;
      emit(current.copyWith(
        selectedGroupId: event.groupId,
        clearSelected: event.groupId == null,
      ));
    }
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await createGroup(
      params: CreateGroupParams(
        name: event.name,
        description: event.description,
      ),
    );
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (_) => add(const LoadGroups()),
    );
  }
}
