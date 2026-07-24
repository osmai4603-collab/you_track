import 'package:flutter/material.dart';

class AppPopupMenuItem<T> extends PopupMenuItem<T> {
  const AppPopupMenuItem({
    super.key,
    super.value,
    super.enabled,
    super.onTap,
    super.textStyle,
    super.mouseCursor,
    required Widget super.child,
  }) : super(height: 35, padding: const EdgeInsets.all(4.0));
}
