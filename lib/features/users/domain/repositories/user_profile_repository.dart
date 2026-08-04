import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';

abstract class UserProfileRepository {
  // ── تفضيلات الواجهة ──
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(String userId);
  Future<Either<Failure, UserPreferencesEntity>> saveUserPreferences(UserPreferencesEntity preferences);

  // ── إعدادات الإشعارات ──
  Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings(String userId);
  Future<Either<Failure, NotificationSettingsEntity>> saveNotificationSettings(NotificationSettingsEntity settings);

  // ── البحث المحفوظ ──
  Future<Either<Failure, List<SavedSearchEntity>>> getSavedSearches(String userId);
  Future<Either<Failure, SavedSearchEntity>> createSavedSearch(SavedSearchEntity search);
  Future<Either<Failure, void>> deleteSavedSearch(String searchId);

  // ── Tags الخاصة بالمستخدم ──
  Future<Either<Failure, List<Tag>>> getUserTags(String userId);

  // ── أمان الحساب ──
  Future<Either<Failure, void>> changePassword(String currentPassword, String newPassword);
  Future<Either<Failure, void>> revokeRefreshToken();
}