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
    final isDarkMode = sharedPreferences.getBool('isDarkMode') ?? true;
    final languageCode = sharedPreferences.getString('languageCode') ?? 'en';
    return AppSettingsEntity(isDarkMode: isDarkMode, languageCode: languageCode);
  }

  @override
  Future<void> saveAppSettings(AppSettingsEntity settings) async {
    await sharedPreferences.setBool('isDarkMode', settings.isDarkMode);
    await sharedPreferences.setString('languageCode', settings.languageCode);
  }
}
