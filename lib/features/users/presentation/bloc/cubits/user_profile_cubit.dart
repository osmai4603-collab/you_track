import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';
import 'package:issues_tracking/features/users/domain/usecases/update_user.dart';

// ── State ──
enum UserProfileStatus { initial, loading, loaded, saving, saved, error }

class UserProfileState extends Equatable {
  final UserProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final bool hasUnsavedChanges;

  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.hasUnsavedChanges = false,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool? hasUnsavedChanges,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, hasUnsavedChanges];
}

// ── Cubit ──
class UserProfileCubit extends Cubit<UserProfileState> {
  final UsersRepository _usersRepository;
  final UpdateUser _updateUser;

  // Controllers يتم إدارتها هنا بدلاً من داخل build()
  late final TextEditingController fullNameController;
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController vcsUsernamesController;
  String timezone = 'UTC';

  UserProfileCubit({
    required UsersRepository usersRepository,
    required UpdateUser updateUser,
  })  : _usersRepository = usersRepository,
        _updateUser = updateUser,
        super(const UserProfileState()) {
    fullNameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    vcsUsernamesController = TextEditingController();
  }

  /// جلب بيانات المستخدم من DB
  Future<void> loadUser(String userId) async {
    emit(state.copyWith(status: UserProfileStatus.loading));

    final result = await _usersRepository.getUserById(userId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserProfileStatus.error,
        errorMessage: failure.message,
      )),
      (user) {
        // تعبئة الـ Controllers بالبيانات من DB
        fullNameController.text = user.fullName;
        usernameController.text = user.username;
        emailController.text = user.email;

        emit(state.copyWith(
          status: UserProfileStatus.loaded,
          user: user,
        ));
      },
    );
  }

  /// حفظ التعديلات في DB
  Future<void> saveChanges() async {
    if (state.user == null) return;

    emit(state.copyWith(status: UserProfileStatus.saving));

    final updatedUser = state.user!.copyWith(
      displayName: fullNameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
    );

    final result = await _updateUser(
      params: UpdateUserParams(user: updatedUser),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: UserProfileStatus.error,
        errorMessage: failure.message,
      )),
      (updated) => emit(state.copyWith(
        status: UserProfileStatus.saved,
        user: updated,
        hasUnsavedChanges: false,
      )),
    );
  }

  /// تمييز وجود تغييرات غير محفوظة
  void markAsChanged() {
    if (!state.hasUnsavedChanges) {
      emit(state.copyWith(hasUnsavedChanges: true));
    }
  }

  void setTimezone(String value) {
    timezone = value;
  }

  void clearSavedStatus() {
    if (state.status == UserProfileStatus.saved) {
      emit(state.copyWith(status: UserProfileStatus.loaded));
    }
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    vcsUsernamesController.dispose();
    return super.close();
  }
}