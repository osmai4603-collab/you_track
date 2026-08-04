import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/domain/usecases/change_password.dart';
import 'package:issues_tracking/features/users/domain/usecases/revoke_refresh_token.dart';

// ── State ──
enum AccountSecurityStatus { initial, loading, success, error }

class AccountSecurityState extends Equatable {
  final AccountSecurityStatus status;
  final String? message;
  final String? errorMessage;

  const AccountSecurityState({
    this.status = AccountSecurityStatus.initial,
    this.message,
    this.errorMessage,
  });

  AccountSecurityState copyWith({
    AccountSecurityStatus? status,
    String? message,
    String? errorMessage,
  }) {
    return AccountSecurityState(
      status: status ?? this.status,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage];
}

// ── Cubit ──
class AccountSecurityCubit extends Cubit<AccountSecurityState> {
  final ChangePasswordUseCase _changePassword;
  final RevokeRefreshTokenUseCase _revokeRefreshToken;

  AccountSecurityCubit({
    required ChangePasswordUseCase changePassword,
    required RevokeRefreshTokenUseCase revokeRefreshToken,
  })  : _changePassword = changePassword,
        _revokeRefreshToken = revokeRefreshToken,
        super(const AccountSecurityState());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(status: AccountSecurityStatus.loading));

    final result = await _changePassword(
      params: ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    result.fold(
      (f) => emit(
        state.copyWith(
          status: AccountSecurityStatus.error,
          errorMessage: f.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AccountSecurityStatus.success,
          message: 'Password changed successfully',
        ),
      ),
    );
  }

  Future<void> revokeRefreshToken() async {
    emit(state.copyWith(status: AccountSecurityStatus.loading));

    final result = await _revokeRefreshToken(
      params: const RevokeRefreshTokenParams(),
    );

    result.fold(
      (f) => emit(
        state.copyWith(
          status: AccountSecurityStatus.error,
          errorMessage: f.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AccountSecurityStatus.success,
          message: 'Active sessions revoked',
        ),
      ),
    );
  }

  void reset() {
    emit(const AccountSecurityState());
  }
}