import 'package:flutter/material.dart';

sealed class AppRadius {
  const AppRadius._();

  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;

  static const BorderRadius extraSmallBorderRadius = BorderRadius.all(Radius.circular(extraSmall));
  static const BorderRadius smallBorderRadius = BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumBorderRadius = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeBorderRadius = BorderRadius.all(Radius.circular(large));
  static const BorderRadius extraLargeBorderRadius = BorderRadius.all(Radius.circular(extraLarge));
}
