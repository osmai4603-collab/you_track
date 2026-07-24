import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/app/domain/usecases/get_app_settings.dart';
import 'package:issues_tracking/features/app/domain/usecases/save_app_settings.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final GetAppSettings getAppSettings;
  final SaveAppSettings saveAppSettings;

  AppCubit({required this.getAppSettings, required this.saveAppSettings})
    : super(AppInitial());

  Future<void> init() async {
    final result = await getAppSettings(params: const NoParams());

    result.fold((failure) => emit(AppSettingsError(failure.message)), (
      settings,
    ) {
      emit(
        AppSettingsLoaded(
          settings: settings,
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(settings.languageCode),
        ),
      );
    });
  }

  Future<void> toggleTheme() async {
    if (state is AppSettingsLoaded) {
      final currentState = state as AppSettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        isDarkMode: !currentState.settings.isDarkMode,
      );

      final result = await saveAppSettings(
        params: SaveAppSettingsParams(newSettings),
      );

      result.fold(
        (failure) => emit(AppSettingsError(failure.message)),
        (_) => emit(
          AppSettingsLoaded(
            settings: newSettings,
            themeMode: newSettings.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            locale: currentState.locale,
          ),
        ),
      );
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state is AppSettingsLoaded) {
      final currentState = state as AppSettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        languageCode: languageCode,
      );

      final result = await saveAppSettings(
        params: SaveAppSettingsParams(newSettings),
      );

      result.fold(
        (failure) => emit(AppSettingsError(failure.message)),
        (_) => emit(
          AppSettingsLoaded(
            settings: newSettings,
            themeMode: currentState.themeMode,
            locale: Locale(languageCode),
          ),
        ),
      );
    }
  }
}
