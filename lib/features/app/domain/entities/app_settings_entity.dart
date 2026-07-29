import 'package:flutter/material.dart';
import 'package:issues_tracking/core/entities/entity.dart';

class AppSettingsEntity extends Entity {
  final ThemeMode themeMode;
  final String languageCode;

  const AppSettingsEntity({
    required this.themeMode,
    required this.languageCode,
  });

  @override
  AppSettingsEntity copyWith({ThemeMode? themeMode, String? languageCode}) {
    return AppSettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode];
}
