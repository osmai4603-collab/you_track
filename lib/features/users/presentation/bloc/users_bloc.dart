import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/usecases/create_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;
  final CreateUser createUser;

  UsersBloc({required this.getUsers, required this.createUser})
      : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SelectUser>(_onSelectUser);
    on<CreateUserEvent>(_onCreateUser);
    on<InviteUsersEvent>(_onInviteUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getUsers(params: const NoParams());
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }

  Future<void> _onSelectUser(
    SelectUser event,
    Emitter<UsersState> emit,
  ) async {
    if (state is UsersLoaded) {
      final current = state as UsersLoaded;
      emit(current.copyWith(
        selectedUserId: event.userId,
        clearSelected: event.userId == null,
      ));
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await createUser(
      params: CreateUserParams(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }

  Future<void> _onInviteUsers(
    InviteUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    for (final email in event.emails) {
      await createUser(
        params: CreateUserParams(
          displayName: email.split('@').first,
          email: email,
          password: '',
        ),
      );
    }
    add(const LoadUsers());
  }
}
