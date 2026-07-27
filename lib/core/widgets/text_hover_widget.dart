import 'package:flutter/material.dart';
import 'package:issues_tracking/core/widgets/hover_widget.dart';

class TextHoverWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle styleHover;
  final VoidCallback? onHover;
  final TextOverflow? overflow;

  const TextHoverWidget({
    super.key,
    required this.style,
    required this.text,
    required this.styleHover,
    this.onHover,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      builder: (_, isHovered) {
        return Text(
          text,
          style: isHovered ? styleHover : style,
          overflow: overflow,
        );
      },
      onHover: onHover,
    );
  }
}
