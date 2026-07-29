

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppNavigation extends StatefulShellBranch {
  AppNavigation({required super.routes});


  /// انتقال Fade بمدة 200ms (مطابق للـ AnimatedSwitcher الأصلي)
 static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

}