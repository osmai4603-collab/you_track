import 'package:flutter/material.dart';

class SlidingPanel extends StatelessWidget {
  final bool isOpen;
  final Widget child;
  final double panelWidth;
  final Duration animationDuration;

  const SlidingPanel({
    super.key,
    required this.isOpen,
    required this.child,
    this.panelWidth = 400.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.easeInOut,
      right: isOpen ? 0 : -panelWidth,
      top: 0,
      bottom: 0,
      width: panelWidth,
      child: child,
    );
  }
}