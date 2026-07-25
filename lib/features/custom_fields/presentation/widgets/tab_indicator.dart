import 'package:flutter/material.dart';

class TabIndicator extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const TabIndicator({
    super.key,
    required this.isActive,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: isActive ? activeColor : inactiveColor,
    );
  }
}