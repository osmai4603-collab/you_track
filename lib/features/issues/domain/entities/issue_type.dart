import 'package:flutter/material.dart';

enum IssueType {
  bug('Bug', Color(0xFFF44336), Icons.bug_report),
  task('Task', Color(0xFF2196F3), Icons.task),
  feature('Feature', Color(0xFF4CAF50), Icons.star),
  improvement('Improvement', Color(0xFFFF9800), Icons.auto_awesome),
  epic('Epic', Color(0xFF9C27B0), Icons.bolt);

  const IssueType(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}
