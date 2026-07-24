import 'package:flutter/material.dart';
import 'app_fonts.dart';
import 'app_font_sizes.dart';

sealed class AppTextTheme {
  const AppTextTheme._();

  static const TextTheme light = TextTheme(
    displayLarge: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.displayLarge, fontWeight: FontWeight.w400, letterSpacing: -0.25),
    displayMedium: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.displayMedium, fontWeight: FontWeight.w400, letterSpacing: 0.0),
    displaySmall: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.displaySmall, fontWeight: FontWeight.w400, letterSpacing: 0.0),
    
    headlineLarge: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.headlineLarge, fontWeight: FontWeight.w400, letterSpacing: 0.0),
    headlineMedium: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.headlineMedium, fontWeight: FontWeight.w400, letterSpacing: 0.0),
    headlineSmall: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.headlineSmall, fontWeight: FontWeight.w400, letterSpacing: 0.0),
    
    titleLarge: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.titleLarge, fontWeight: FontWeight.w500, letterSpacing: 0.0),
    titleMedium: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.titleMedium, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.titleSmall, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    
    bodyLarge: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.bodyLarge, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.bodyMedium, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.bodySmall, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    
    labelLarge: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.labelLarge, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelMedium: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.labelMedium, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    labelSmall: TextStyle(fontFamily: AppFonts.primary, fontSize: AppFontSizes.labelSmall, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );

  static const TextTheme dark = light; // Same styles, colors will be adapted by ColorScheme
}
