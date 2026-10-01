import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/user_profile_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileApi _api;

  UserProfileRepositoryImpl(this._api);

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final result = await _api.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, SavedSearchEntity>> createSavedSearch(
    SavedSearchEntity search,
  ) async {
    final result = await _api.createSavedSearch(_savedSearchToJson(search));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_savedSearchFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteSavedSearch(String searchId) async {
    final result = await _api.deleteSavedSearch(searchId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings(
    String userId,
  ) async {
    final result = await _api.getNotificationSettings(userId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_notificationSettingsFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<SavedSearchEntity>>> getSavedSearches(
    String userId,
  ) async {
    final result = await _api.getSavedSearches(userId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_savedSearchFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(
    String userId,
  ) async {
    final result = await _api.getPreferences(userId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_preferencesFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<Tag>>> getUserTags(String userId) async {
    final result = await _api.getUserTags(userId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_tagFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> revokeRefreshToken() async {
    final result = await _api.revokeRefreshToken();
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, NotificationSettingsEntity>> saveNotificationSettings(
    NotificationSettingsEntity settings,
  ) async {
    final result = await _api.saveNotificationSettings(
      settings.userId,
      _notificationSettingsToJson(settings),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_notificationSettingsFromJson(result.data));
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> saveUserPreferences(
    UserPreferencesEntity preferences,
  ) async {
    final result = await _api.savePreferences(
      preferences.userId,
      _preferencesToJson(preferences),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_preferencesFromJson(result.data));
  }
}

UserPreferencesEntity _preferencesFromJson(JsonObject json) =>
    UserPreferencesEntity(
      id: _text(json, 'id'),
      userId: _text(json, 'userId', 'user_id'),
      theme: _text(json, 'theme', null, 'dark'),
      linksPanelPosition: _text(
        json,
        'linksPanelPosition',
        'links_panel_position',
        'below_description',
      ),
      showRecentIssues: _bool(
        json,
        'showRecentIssues',
        'show_recent_issues',
        true,
      ),
    );

JsonObject _preferencesToJson(UserPreferencesEntity preferences) => {
  'theme': preferences.theme,
  'linksPanelPosition': preferences.linksPanelPosition,
  'showRecentIssues': preferences.showRecentIssues,
};

NotificationSettingsEntity _notificationSettingsFromJson(
  JsonObject json,
) => NotificationSettingsEntity(
  id: _text(json, 'id'),
  userId: _text(json, 'userId', 'user_id'),
  emailEnabled: _bool(json, 'emailEnabled', 'email_enabled', true),
  emailFormat: _text(json, 'emailFormat', 'email_format', 'html'),
  telegramEnabled: _bool(json, 'telegramEnabled', 'telegram_enabled'),
  telegramConnected: _bool(json, 'telegramConnected', 'telegram_connected'),
  notifyChangesByMe: _bool(json, 'notifyChangesByMe', 'notify_changes_by_me'),
  notifyMentions: _bool(json, 'notifyMentions', 'notify_mentions'),
  notifyDuplicateChanges: _bool(
    json,
    'notifyDuplicateChanges',
    'notify_duplicate_changes',
  ),
  notifyEmailCreated: _bool(json, 'notifyEmailCreated', 'notify_email_created'),
  notifyVcsUpdates: _bool(json, 'notifyVcsUpdates', 'notify_vcs_updates'),
  notifyVcsFailedCommands: _bool(
    json,
    'notifyVcsFailedCommands',
    'notify_vcs_failed_commands',
  ),
  starOnComment: _bool(json, 'starOnComment', 'star_on_comment', true),
  starOnCreate: _bool(json, 'starOnCreate', 'star_on_create', true),
  starOnUpdate: _bool(json, 'starOnUpdate', 'star_on_update', true),
  starOnAssigned: _bool(json, 'starOnAssigned', 'star_on_assigned', true),
  starOnVote: _bool(json, 'starOnVote', 'star_on_vote', true),
);

JsonObject _notificationSettingsToJson(NotificationSettingsEntity settings) => {
  'emailEnabled': settings.emailEnabled,
  'emailFormat': settings.emailFormat,
  'telegramEnabled': settings.telegramEnabled,
  'telegramConnected': settings.telegramConnected,
  'notifyChangesByMe': settings.notifyChangesByMe,
  'notifyMentions': settings.notifyMentions,
  'notifyDuplicateChanges': settings.notifyDuplicateChanges,
  'notifyEmailCreated': settings.notifyEmailCreated,
  'notifyVcsUpdates': settings.notifyVcsUpdates,
  'notifyVcsFailedCommands': settings.notifyVcsFailedCommands,
  'starOnComment': settings.starOnComment,
  'starOnCreate': settings.starOnCreate,
  'starOnUpdate': settings.starOnUpdate,
  'starOnAssigned': settings.starOnAssigned,
  'starOnVote': settings.starOnVote,
};

SavedSearchEntity _savedSearchFromJson(JsonObject json) => SavedSearchEntity(
  id: _text(json, 'id'),
  userId: _text(json, 'userId', 'user_id'),
  name: _text(json, 'name'),
  query: _text(json, 'query'),
  isFavorite: _bool(json, 'isFavorite', 'is_favorite'),
  createdAt: _date(json['createdAt'] ?? json['created_at']),
);

JsonObject _savedSearchToJson(SavedSearchEntity search) => {
  'userId': search.userId,
  'name': search.name,
  'query': search.query,
  'isFavorite': search.isFavorite,
};

Tag _tagFromJson(JsonObject json) => Tag(
  id: _text(json, 'id'),
  name: _text(json, 'name'),
  ownerId: _text(json, 'ownerId', 'owner_id'),
  projectId: _text(json, 'projectId', 'project_id'),
  shared: _bool(json, 'shared', null, true),
  removeOnResolution: _bool(
    json,
    'removeOnResolution',
    'remove_on_resolution',
    true,
  ),
  favorite: _bool(json, 'favorite'),
  createdAt:
      _date(json['createdAt'] ?? json['created_at']) ??
      DateTime.fromMillisecondsSinceEpoch(0),
  createdBy: _text(json, 'createdBy', 'created_by'),
);

String _text(
  JsonObject json,
  String key, [
  String? alias,
  String fallback = '',
]) =>
    (json[key] ?? (alias == null ? null : json[alias]) ?? fallback).toString();

bool _bool(
  JsonObject json,
  String key, [
  String? alias,
  bool fallback = false,
]) {
  final value = json[key] ?? (alias == null ? null : json[alias]);
  if (value is bool) return value;
  if (value == null) return fallback;
  return value.toString().toLowerCase() == 'true';
}

DateTime? _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '');
}
