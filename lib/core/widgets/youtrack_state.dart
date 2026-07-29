import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

abstract class YouTrackState<Stateful extends StatefulWidget>
    extends State<Stateful> {
  AppLocalizations? _localizations;
  AppLocalizations get localization =>
      _localizations ??= AppLocalizations.of(context)!;

  TextTheme? _textTheme;
  TextTheme get textTheme => _textTheme ??= TextTheme.of(context);

  ColorScheme? _colors;
  ColorScheme get colors => _colors ??= ColorScheme.of(context);
}
