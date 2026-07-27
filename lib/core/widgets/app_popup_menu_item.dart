import 'package:flutter/material.dart';

class AppPopupMenuItem<T> extends PopupMenuItem<T> {
  const AppPopupMenuItem({
    super.key,
    super.value,
    super.enabled,
    super.onTap,
    super.textStyle,
    super.mouseCursor,
    super.height = 35,
    super.padding = const EdgeInsets.all(4.0),
    required Widget super.child,
  });
}
