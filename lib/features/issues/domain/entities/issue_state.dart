import 'package:flutter/material.dart';

enum IssueTrackState {
  open('Open', Color(0xFFDFE1E5), Colors.transparent),
  inProgress('In Progress', Color(0xFF307FFF), Color(0x1A307FFF)),
  fixed('Fixed', Color(0xFF59A869), Color(0x1A59A869)),
  wontFix("Won't Fix", Color(0xFF868A91), Color(0x1A868A91)),
  verified('Verified', Color(0xFF59A869), Color(0x2659A869)),
  duplicate('Duplicate', Color(0xFF868A91), Colors.transparent);

  const IssueTrackState(this.label, this.textColor, this.backgroundColor);

  final String label;
  final Color textColor;
  final Color backgroundColor;
}
