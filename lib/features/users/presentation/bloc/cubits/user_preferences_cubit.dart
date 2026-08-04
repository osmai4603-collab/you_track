import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_user_preferences.dart';
import 'package:issues_tracking/features/users/domain/usecases/save_user_preferences.dart';

// ── State ──
enum PreferencesStatus { initial, loading, loaded, saving, error }

class UserPreferencesState extends Equatable {
  final PreferencesStatus status;
  final UserPreferencesEntity? preferences;
  final String? errorMessage;

  const UserPreferencesState({
    this.status = PreferencesStatus.initial,
    this.preferences,
    this.errorMessage,
  });

  UserPreferencesState copyWith({
    PreferencesStatus? status,
    UserPreferencesEntity? preferences,
    String? errorMessage,
  }) {
    return UserPreferencesState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, preferences, errorMessage];
}

// ── Cubit ──
class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  final GetUserPreferencesUseCase _getPreferences;
  final SaveUserPreferencesUseCase _savePreferences;

  UserPreferencesCubit({
    required GetUserPreferencesUseCase getPreferences,
    required SaveUserPreferencesUseCase savePreferences,
  })  : _getPreferences = getPreferences,
        _savePreferences = savePreferences,
        super(const UserPreferencesState());

  Future<void> loadPreferences(String userId) async {
    emit(state.copyWith(status: PreferencesStatus.loading));
    final result = await _getPreferences(
      params: GetUserPreferencesParams(userId: userId),
    );
    result.fold(
      (f) => emit(
        state.copyWith(status: PreferencesStatus.error, errorMessage: f.message),
      ),
      (p) => emit(
        state.copyWith(status: PreferencesStatus.loaded, preferences: p),
      ),
    );
  }

  /// تغيير الثيم مع حفظ تلقائي
  Future<void> updateTheme(String theme) async {
    if (state.preferences == null) return;
    final updated = state.preferences!.copyWith(theme: theme);
    emit(state.copyWith(preferences: updated, status: PreferencesStatus.saving));
    await _save(updated);
  }

  /// تغيير موقع لوحة الروابط مع حفظ تلقائي
  Future<void> updateLinksPanelPosition(String position) async {
    if (state.preferences == null) return;
    final updated = state.preferences!.copyWith(linksPanelPosition: position);
    emit(state.copyWith(preferences: updated, status: PreferencesStatus.saving));
    await _save(updated);
  }

  /// تغيير إظهار العناصر الأخيرة مع حفظ تلقائي
  Future<void> updateShowRecent(bool value) async {
    if (state.preferences == null) return;
    final updated = state.preferences!.copyWith(showRecentIssues: value);
    emit(state.copyWith(preferences: updated, status: PreferencesStatus.saving));
    await _save(updated);
  }

  Future<void> _save(UserPreferencesEntity entity) async {
    final result = await _savePreferences(
      params: SaveUserPreferencesParams(preferences: entity),
    );
    result.fold(
      (f) => emit(
        state.copyWith(status: PreferencesStatus.error, errorMessage: f.message),
      ),
      (p) => emit(
        state.copyWith(status: PreferencesStatus.loaded, preferences: p),
      ),
    );
  }
}