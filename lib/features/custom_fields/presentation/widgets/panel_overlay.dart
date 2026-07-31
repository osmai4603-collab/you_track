import 'package:flutter/material.dart';

class PanelOverlay extends StatelessWidget {
  final bool isVisible;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const PanelOverlay({
    super.key,
    required this.isVisible,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: animationDuration,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.black54,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
