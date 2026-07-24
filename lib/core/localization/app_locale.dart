import 'package:flutter/material.dart';

sealed class AppLocale {
  const AppLocale._();

  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  static const List<Locale> supportedLocales = [arabic, english];
}
