import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';

class RoleTableRow extends StatefulWidget {
  final RoleEntity role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleTableRow({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<RoleTableRow> createState() => _RoleTableRowState();
}

class _RoleTableRowState extends State<RoleTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final role = widget.role;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.extraSmall,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colors.primaryContainer.withValues(alpha: 0.2)
                : _isHovered
                    ? colors.onSurface.withValues(alpha: 0.04)
                    : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    Icons.shield,
                    size: 16,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                flex: 3,
                child: Text(
                  role.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  role.permissions.join(', '),
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
