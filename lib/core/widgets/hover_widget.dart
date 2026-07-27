import 'package:flutter/material.dart';

typedef WidgetHoverBuilder = Widget Function(BuildContext, bool);

class HoverWidget extends StatefulWidget {
  final WidgetHoverBuilder builder;
  final void Function()? onHover;
  const HoverWidget({super.key, required this.builder, this.onHover});

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: widget.builder(context, isHovered),
      onHover: (_) => widget.onHover,
    );
  }
}
