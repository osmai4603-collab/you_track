import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';

abstract class AppSettingsLocalDataSource {
  Future<AppSettingsEntity> getAppSettings();
  Future<void> saveAppSettings(AppSettingsEntity settings);
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  AppSettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<AppSettingsEntity> getAppSettings() async {
    final themeModeString = sharedPreferences.getString('themeMode') ?? 'dark';
    final languageCode = sharedPreferences.getString('languageCode') ?? 'en';
    return AppSettingsEntity(
      themeMode: _parseThemeMode(themeModeString),
      languageCode: languageCode,
    );
  }

  @override
  Future<void> saveAppSettings(AppSettingsEntity settings) async {
    await sharedPreferences.setString(
      'themeMode',
      _themeModeToString(settings.themeMode),
    );
    await sharedPreferences.setString('languageCode', settings.languageCode);
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _parseThemeMode(String value) {
    switch (value) {
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
