import 'package:issues_tracking/core/entities/entity.dart';

class AppSettingsEntity extends Entity {
  final bool isDarkMode;
  final String languageCode;

  const AppSettingsEntity({
    required this.isDarkMode,
    required this.languageCode,
  });

  @override
  AppSettingsEntity copyWith({bool? isDarkMode, String? languageCode}) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, languageCode];
}
