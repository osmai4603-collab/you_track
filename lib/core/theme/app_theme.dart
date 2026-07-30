import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';

sealed class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildThemeData(
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
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      hoverColor: colorScheme.secondary.withValues(alpha: 0.05),
      splashColor: colorScheme.primary.withValues(alpha: 0.15),

      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        space: 0,
        thickness: 0.75,
      ),

      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
        ),

        contentPadding: AppSpacing.paddingAllExtraSmall,
        dense: true,
        minTileHeight: 30,
      ),
      iconTheme: IconThemeData(size: 16, color: colorScheme.onSurfaceVariant),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: 16,
          shape: _defaultShape,
          fixedSize: Size.square(28),
          maximumSize: Size.square(28),
          minimumSize: Size.square(28),
          padding: .all(4),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLow,
        menuPadding: AppSpacing.paddingAllExtraSmall,
        textStyle: textTheme.labelSmall,
        mouseCursor: WidgetStatePropertyAll(MouseCursor.defer),
      ),

      chipTheme: ChipThemeData(
        shape: _defaultShape,
        labelStyle: textTheme.labelSmall,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: _defaultShape,
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelSmall?.copyWith(fontWeight: .bold),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: _defaultShape,
          foregroundColor: colorScheme.onSurfaceVariant,
          backgroundColor: colorScheme.surface,
          selectedBackgroundColor: colorScheme.primary.withValues(alpha: 0.10),
          selectedForegroundColor: colorScheme.onSurface,
          textStyle: textTheme.labelSmall?.copyWith(fontWeight: .bold),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: _defaultShape,
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelSmall?.copyWith(fontWeight: .bold),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: _defaultShape,
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          textStyle: textTheme.labelSmall?.copyWith(fontWeight: .bold),
          fixedSize: Size.fromHeight(28),
          //minimumSize: Size.fromHeight(28),
          // maximumSize: Size.fromHeight(28),
          padding: .symmetric(horizontal: 12, vertical: 4),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: _defaultShape,
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelSmall?.copyWith(fontWeight: .bold),
        ),
      ),

      inputDecorationTheme: _fieldDecoration(
        textTheme: textTheme,
        colorScheme: colorScheme,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
      ),
    );
  }

  static final _defaultShape = RoundedRectangleBorder(
    borderRadius: .circular(AppRadius.extraSmall),
  );

  static InputDecorationThemeData _fieldDecoration({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return InputDecorationThemeData(
      labelStyle: null,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
      ),
      isDense: true,
      // filled: true,
      // fillColor: colorScheme.surfaceContainerLowest,
      border: OutlineInputBorder(borderRadius: .circular(AppRadius.extraSmall)),
      enabledBorder: OutlineInputBorder(
        borderRadius: .circular(AppRadius.extraSmall),
        borderSide: BorderSide(color: colorScheme.outline),
      ),

      contentPadding: .all(8),
    );
  }
}
