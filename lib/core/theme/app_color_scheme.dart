import 'package:flutter/material.dart';
import 'app_colors.dart';

sealed class AppColorScheme {
  static final light = ColorScheme(
    brightness: Brightness.light,

    // Brand
    primary: AppColors.light.brand.color600,
    onPrimary: AppColors.light.neutral.color50,
    primaryContainer: AppColors.light.brand.color100,
    onPrimaryContainer: AppColors.light.brand.color900,

    // Info / Secondary
    secondary: AppColors.light.info.color500,
    onSecondary: AppColors.light.neutral.color50,
    secondaryContainer: AppColors.light.info.color100,
    onSecondaryContainer: AppColors.light.info.color900,

    // Success / Tertiary
    tertiary: AppColors.light.success.color500,
    onTertiary: AppColors.light.neutral.color50,
    tertiaryContainer: AppColors.light.success.color100,
    onTertiaryContainer: AppColors.light.success.color900,

    // Error
    error: AppColors.light.error.color600,
    onError: AppColors.light.neutral.color50,
    errorContainer: AppColors.light.error.color100,
    onErrorContainer: AppColors.light.error.color900,

    // Neutral & Surfaces
    surface: AppColors.light.neutral.color100,
    surfaceContainerLowest: AppColors.light.neutral.color50,
    surfaceContainerLow: AppColors.light.neutral.color100,
    surfaceContainer: AppColors.light.neutral.color200,
    surfaceContainerHigh: AppColors.light.neutral.color300,
    surfaceContainerHighest: AppColors.light.neutral.color400,
    onSurface: AppColors.light.neutral.color900,

    onSurfaceVariant: AppColors.light.neutral.color700,
    outline: AppColors.light.neutral.color400,
    outlineVariant: AppColors.light.neutral.color200,
    shadow: AppColors.light.neutral.color900,
    scrim: AppColors.light.neutral.color900,
    inverseSurface: AppColors.light.neutral.color800,
    onInverseSurface: AppColors.light.neutral.color50,
    inversePrimary: AppColors.light.brand.color200,
  );

  static final dark = ColorScheme(
    brightness: Brightness.dark,

    // Brand
    primary: AppColors.dark.brand.color400,
    onPrimary: AppColors.dark.neutral.color900,
    primaryContainer: AppColors.dark.brand.color700,
    onPrimaryContainer: AppColors.dark.brand.color100,

    // Info / Secondary
    secondary: AppColors.dark.info.color500,
    onSecondary: AppColors.dark.neutral.color900,
    secondaryContainer: AppColors.dark.info.color700,
    onSecondaryContainer: AppColors.dark.info.color100,

    // Success / Tertiary
    tertiary: AppColors.dark.success.color500,
    onTertiary: AppColors.dark.neutral.color900,
    tertiaryContainer: AppColors.dark.success.color700,
    onTertiaryContainer: AppColors.dark.success.color100,

    // Error
    error: AppColors.dark.error.color500,
    onError: AppColors.dark.neutral.color900,
    errorContainer: AppColors.dark.error.color700,
    onErrorContainer: AppColors.dark.error.color100,

    // Neutral & Surfaces
    surface: AppColors.dark.neutral.color50, // Note: Color50 in dark is #121212
    surfaceContainerLowest: Colors.black,
    surfaceContainerLow: AppColors.dark.neutral.color100,
    surfaceContainer: AppColors.dark.neutral.color200,
    surfaceContainerHigh: AppColors.dark.neutral.color300,
    surfaceContainerHighest: AppColors.dark.neutral.color400,
    onSurface: AppColors.dark.neutral.color900,
    onSurfaceVariant: AppColors.dark.neutral.color700,
    outline: AppColors.dark.neutral.color400,
    outlineVariant: AppColors.dark.neutral.color200,
    shadow: AppColors.dark.neutral.color50,
    scrim: AppColors.dark.neutral.color50,
    inverseSurface: AppColors.dark.neutral.color800,
    onInverseSurface: AppColors.dark.neutral.color900,
    inversePrimary: AppColors.dark.brand.color700,
  );

  static ColorScheme of(BuildContext context) => Theme.of(context).colorScheme;
}
