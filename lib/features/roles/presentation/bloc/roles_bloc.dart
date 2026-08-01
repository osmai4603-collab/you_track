import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/roles/domain/usecases/create_role.dart';
import 'package:issues_tracking/features/roles/domain/usecases/delete_role.dart';
import 'package:issues_tracking/features/roles/domain/usecases/get_roles.dart';
import 'package:issues_tracking/features/roles/domain/usecases/update_role.dart';
import 'package:issues_tracking/core/utils/permission_refresh_mixin.dart';
import 'roles_event.dart';
import 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> with PermissionRefreshMixin {
  final GetRoles getRoles;
  final CreateRole createRole;
  final UpdateRole updateRole;
  final DeleteRole deleteRole;

  RolesBloc({
    required this.getRoles,
    required this.createRole,
    required this.updateRole,
    required this.deleteRole,
  }) : super(RolesInitial()) {
    on<LoadRoles>(_onLoadRoles);
    on<CreateRoleEvent>(_onCreateRole);
    on<UpdateRoleEvent>(_onUpdateRole);
    on<DeleteRoleEvent>(_onDeleteRole);
    on<SelectRole>(_onSelectRole);
  }

  Future<void> _onLoadRoles(
    LoadRoles event,
    Emitter<RolesState> emit,
  ) async {
    emit(RolesLoading());
    final result = await getRoles(params: const NoParams());
    result.fold(
      (failure) => emit(RolesError(failure.message)),
      (roles) => emit(RolesLoaded(roles: roles)),
    );
  }

  Future<void> _onCreateRole(
    CreateRoleEvent event,
    Emitter<RolesState> emit,
  ) async {
    final result = await createRole(
      params: CreateRoleParams(
        name: event.name,
        description: event.description,
        permissions: event.permissions,
      ),
    );
    result.fold(
      (failure) => emit(RolesError(failure.message)),
      (_) async {
        await refreshUserPermissions();
        add(const LoadRoles());
      },
    );
  }

  Future<void> _onUpdateRole(
    UpdateRoleEvent event,
    Emitter<RolesState> emit,
  ) async {
    final result = await updateRole(
      params: UpdateRoleParams(
        name: event.name,
        description: event.description,
        permissions: event.permissions,
      ),
    );
    result.fold(
      (failure) => emit(RolesError(failure.message)),
      (_) async {
        await refreshUserPermissions();
        add(const LoadRoles());
      },
    );
  }

  Future<void> _onDeleteRole(
    DeleteRoleEvent event,
    Emitter<RolesState> emit,
  ) async {
    final result = await deleteRole(
      params: DeleteRoleParams(id: event.id),
    );
    result.fold(
      (failure) => emit(RolesError(failure.message)),
      (_) async {
        await refreshUserPermissions();
        add(const LoadRoles());
      },
    );
  }

  void _onSelectRole(
    SelectRole event,
    Emitter<RolesState> emit,
  ) {
    if (state is RolesLoaded) {
      final current = state as RolesLoaded;
      emit(current.copyWith(
        selectedRoleId: event.roleId,
        clearSelected: event.roleId == null,
      ));
    }
  }
}
