import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_notification_settings.dart';
import 'package:issues_tracking/features/users/domain/usecases/save_notification_settings.dart';

// ── State ──
enum NotificationSettingsStatus { initial, loading, loaded, saving, error }

class NotificationSettingsState extends Equatable {
  final NotificationSettingsStatus status;
  final NotificationSettingsEntity? settings;
  final String? errorMessage;

  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.initial,
    this.settings,
    this.errorMessage,
  });

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    NotificationSettingsEntity? settings,
    String? errorMessage,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, settings, errorMessage];
}

// ── Cubit ──
class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final GetNotificationSettingsUseCase _getSettings;
  final SaveNotificationSettingsUseCase _saveSettings;

  NotificationSettingsCubit({
    required GetNotificationSettingsUseCase getSettings,
    required SaveNotificationSettingsUseCase saveSettings,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        super(const NotificationSettingsState());

  Future<void> loadSettings(String userId) async {
    emit(state.copyWith(status: NotificationSettingsStatus.loading));
    final result = await _getSettings(
      params: GetNotificationSettingsParams(userId: userId),
    );
    result.fold(
      (f) => emit(
        state.copyWith(
          status: NotificationSettingsStatus.error,
          errorMessage: f.message,
        ),
      ),
      (s) => emit(
        state.copyWith(status: NotificationSettingsStatus.loaded, settings: s),
      ),
    );
  }

  Future<void> toggleEmailEnabled(bool value) => _updateAndSave(
        (s) => s.copyWith(emailEnabled: value),
      );

  Future<void> updateEmailFormat(String value) => _updateAndSave(
        (s) => s.copyWith(emailFormat: value),
      );

  Future<void> toggleTelegramEnabled(bool value) => _updateAndSave(
        (s) => s.copyWith(telegramEnabled: value),
      );

  Future<void> toggleTelegramConnected(bool value) => _updateAndSave(
        (s) => s.copyWith(telegramConnected: value),
      );

  /// دالة عامة لكل أحداث الإشعارات
  Future<void> toggleNotifyEvent(String eventName, bool value) {
    final updated = state.settings?.copyWith(
      notifyChangesByMe:
          eventName == 'notifyChangesByMe' ? value : null,
      notifyMentions: eventName == 'notifyMentions'
          ? value
          : null,
      notifyDuplicateChanges: eventName == 'notifyDuplicateChanges'
          ? value
          : null,
      notifyEmailCreated: eventName == 'notifyEmailCreated'
          ? value
          : null,
      notifyVcsUpdates: eventName == 'notifyVcsUpdates' ? value : null,
      notifyVcsFailedCommands: eventName == 'notifyVcsFailedCommands'
          ? value
          : null,
    );
    if (updated == null) return Future.value();
    return _updateAndSave((_) => updated);
  }

  /// دالة عامة لكل أحداث Star
  Future<void> toggleStarEvent(String eventName, bool value) {
    final updated = state.settings?.copyWith(
      starOnComment: eventName == 'starOnComment' ? value : null,
      starOnCreate: eventName == 'starOnCreate' ? value : null,
      starOnUpdate: eventName == 'starOnUpdate' ? value : null,
      starOnAssigned: eventName == 'starOnAssigned' ? value : null,
      starOnVote: eventName == 'starOnVote' ? value : null,
    );
    if (updated == null) return Future.value();
    return _updateAndSave((_) => updated);
  }

  Future<void> _updateAndSave(
    NotificationSettingsEntity Function(NotificationSettingsEntity) update,
  ) async {
    final current = state.settings;
    if (current == null) return;

    final updated = update(current);
    emit(
      state.copyWith(
        settings: updated,
        status: NotificationSettingsStatus.saving,
      ),
    );

    final result = await _saveSettings(
      params: SaveNotificationSettingsParams(settings: updated),
    );
    result.fold(
      (f) => emit(
        state.copyWith(
          status: NotificationSettingsStatus.error,
          errorMessage: f.message,
        ),
      ),
      (s) => emit(
        state.copyWith(status: NotificationSettingsStatus.loaded, settings: s),
      ),
    );
  }
}