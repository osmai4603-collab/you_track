import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/login_use_case.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_user_permissions_use_case.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required this._loginUseCase}) : super(const LoginState());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;

    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginUseCase(email, password);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) async {
        final getPermissions = get_it<GetUserPermissionsUseCase>();
        final permissionsResult = await getPermissions(
          params: GetUserPermissionsParams(userId: user.id),
        );

        permissionsResult.fold((failure) {}, (permissions) {
          final userSession = get_it<UserSession>();
          userSession.setPermissions(permissions);
        });

        emit(state.copyWith(status: LoginStatus.success, user: user));
      },
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: LoginStatus.initial, errorMessage: null));
  }
}
