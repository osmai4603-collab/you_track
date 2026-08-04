import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/data/models/tag_model.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/users/data/datasources/user_profile_remote_data_source.dart';
import 'package:issues_tracking/features/users/data/models/notification_settings_model.dart';
import 'package:issues_tracking/features/users/data/models/saved_search_model.dart';
import 'package:issues_tracking/features/users/data/models/user_preferences_model.dart';
import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource dataSource;

  UserProfileRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(
    String userId,
  ) async {
    try {
      final result = await dataSource.getUserPreferences(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> saveUserPreferences(
    UserPreferencesEntity preferences,
  ) async {
    try {
      final model = UserPreferencesModel.fromEntity(preferences);
      final result = await dataSource.saveUserPreferences(model.toUpsertJson());
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings(
    String userId,
  ) async {
    try {
      final result = await dataSource.getNotificationSettings(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettingsEntity>> saveNotificationSettings(
    NotificationSettingsEntity settings,
  ) async {
    try {
      final model = NotificationSettingsModel.fromEntity(settings);
      final result = await dataSource.saveNotificationSettings(
        model.toUpsertJson(),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedSearchEntity>>> getSavedSearches(
    String userId,
  ) async {
    try {
      final result = await dataSource.getSavedSearches(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedSearchEntity>> createSavedSearch(
    SavedSearchEntity search,
  ) async {
    try {
      final model = SavedSearchModel.fromEntity(search);
      final result = await dataSource.createSavedSearch(model.toCreateJson());
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedSearch(String searchId) async {
    try {
      await dataSource.deleteSavedSearch(searchId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getUserTags(String userId) async {
    try {
      final result = await dataSource.getUserTags(userId);
      final tags = result
          .map((json) => TagModel.fromJson(json))
          .toList();
      return Right(tags);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await dataSource.changePassword(newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeRefreshToken() async {
    try {
      await dataSource.revokeRefreshToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}