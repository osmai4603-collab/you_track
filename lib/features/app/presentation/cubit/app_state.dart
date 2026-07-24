import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppSettingsLoaded extends AppState {
  final AppSettingsEntity settings;
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingsLoaded({
    required this.settings,
    required this.themeMode,
    required this.locale,
  });

  @override
  List<Object?> get props => [settings, themeMode, locale];
}

class AppSettingsError extends AppState {
  final String message;
  const AppSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
