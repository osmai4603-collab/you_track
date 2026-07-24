import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';

sealed class AppTheme {
  const AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorScheme.light,
    textTheme: AppTextTheme.light,

    // Add additional component themes here if needed
  );

  static ThemeData get dark => _buildThemeData(
    colorScheme: AppColorScheme.dark,
    textTheme: AppTextTheme.dark,
    // Add additional component themes here if needed
  );

  static ThemeData _buildThemeData({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleSmall,
        contentPadding: AppSpacing.paddingAllSmall,
        dense: true,
      ),
      iconTheme: IconThemeData(size: 16, color: colorScheme.onSurfaceVariant),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(iconSize: 16, shape: _defaultShape),
      ),

      popupMenuTheme: PopupMenuThemeData(
        menuPadding: AppSpacing.paddingAllExtraSmall,
        textStyle: textTheme.labelSmall,
        mouseCursor: WidgetStatePropertyAll(MouseCursor.defer),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(),
      chipTheme: ChipThemeData(shape: _defaultShape),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: _defaultShape),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: _defaultShape),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: _defaultShape),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: _defaultShape),
      ),

      inputDecorationTheme: _fieldDecoration(
        textTheme: textTheme,
        colorScheme: colorScheme,
      ),
    );
  }

  static final _defaultShape = RoundedRectangleBorder(
    borderRadius: .circular(AppRadius.small),
  );

  static InputDecorationThemeData _fieldDecoration({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return InputDecorationThemeData(
      labelStyle: null,
      hintStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
      ),
      isDense: true,
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
    );
  }
}
