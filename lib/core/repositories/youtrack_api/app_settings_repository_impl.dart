import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  static const String _themeModeKey = 'app_theme_mode';
  static const String _languageCodeKey = 'app_language_code';

  final SharedPreferences _pref;

  AppSettingsRepositoryImpl(this._pref);

  @override
  Future<Either<Failure, AppSettingsEntity>> getAppSettings() async {
    try {
      final themeName = _pref.getString(_themeModeKey);
      final languageCode = _pref.getString(_languageCodeKey) ?? 'en';

      final themeMode = _parseThemeMode(themeName);

      return Right(
        AppSettingsEntity(themeMode: themeMode, languageCode: languageCode),
      );
    } catch (e) {
      return Left(
        LocalDatabaseFailure('فشل في استرجاع إعدادات التطبيق: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveAppSettings(
    AppSettingsEntity settings,
  ) async {
    try {
      await _pref.setString(_themeModeKey, settings.themeMode.name);
      await _pref.setString(_languageCodeKey, settings.languageCode);

      return const Right(null);
    } catch (e) {
      return Left(
        LocalDatabaseFailure('فشل في حفظ إعدادات التطبيق: ${e.toString()}'),
      );
    }
  }

  ThemeMode _parseThemeMode(String? theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
}
