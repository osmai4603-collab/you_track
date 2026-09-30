import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/tag.dart';
import 'package:youtrack_frontend/features/users/domain/entities/notification_settings_entity.dart';
import 'package:youtrack_frontend/features/users/domain/entities/saved_search_entity.dart';
import 'package:youtrack_frontend/features/users/domain/entities/user_preferences_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SavedSearchEntity>> createSavedSearch(
    SavedSearchEntity search,
  ) {
    // TODO: implement createSavedSearch
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteSavedSearch(String searchId) {
    // TODO: implement deleteSavedSearch
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings(
    String userId,
  ) {
    // TODO: implement getNotificationSettings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SavedSearchEntity>>> getSavedSearches(
    String userId,
  ) {
    // TODO: implement getSavedSearches
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(
    String userId,
  ) {
    // TODO: implement getUserPreferences
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tag>>> getUserTags(String userId) {
    // TODO: implement getUserTags
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> revokeRefreshToken() {
    // TODO: implement revokeRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NotificationSettingsEntity>> saveNotificationSettings(
    NotificationSettingsEntity settings,
  ) {
    // TODO: implement saveNotificationSettings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> saveUserPreferences(
    UserPreferencesEntity preferences,
  ) {
    // TODO: implement saveUserPreferences
    throw UnimplementedError();
  }
}
