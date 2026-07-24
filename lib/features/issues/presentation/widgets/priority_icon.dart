import 'package:flutter/material.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_priority.dart';

class PriorityIcon extends StatelessWidget {
  final IssuePriority priority;
  final double size;

  const PriorityIcon({
    super.key,
    required this.priority,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      priority.icon,
      size: size,
      color: priority.color,
    );
  }
}
