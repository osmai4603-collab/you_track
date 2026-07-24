import 'package:flutter/material.dart';

enum IssuePriority {
  showStopper('Show-stopper', Color(0xFFFF0000), Icons.keyboard_double_arrow_up),
  critical('Critical', Color(0xFFF75464), Icons.keyboard_arrow_up),
  major('Major', Color(0xFFE8A838), Icons.keyboard_arrow_up),
  normal('Normal', Color(0xFF6C9BD2), Icons.remove),
  minor('Minor', Color(0xFF59A869), Icons.keyboard_arrow_down);

  const IssuePriority(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}
