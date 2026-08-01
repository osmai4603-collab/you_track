import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';

class PermissionGuard extends StatelessWidget {
  final Permission permission;
  final String? projectId;
  final Widget child;
  final String? tooltipMessage;

  const PermissionGuard({
    super.key,
    required this.permission,
    this.projectId,
    required this.child,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    final userSession = context.watch<UserSession>();
    final hasAccess = userSession.hasPermission(
      permission,
      projectId: projectId,
    );

    if (hasAccess) return child;

    final l10n = AppLocalizations.of(context)!;

    return Tooltip(
      message: tooltipMessage ?? l10n.permissionDeniedTooltip,
      child: IgnorePointer(child: Opacity(opacity: 0.4, child: child)),
    );
  }
}
