import 'package:flutter/material.dart';

sealed class AppSpacing {
  const AppSpacing._();

  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;

  static const EdgeInsets paddingAllExtraSmall = EdgeInsets.all(extraSmall);
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(small);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(large);
  static const EdgeInsets paddingAllExtraLarge = EdgeInsets.all(extraLarge);
}
