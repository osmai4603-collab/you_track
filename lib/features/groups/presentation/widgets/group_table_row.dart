import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

class GroupTableRow extends StatefulWidget {
  final GroupEntity group;
  final bool isSelected;
  final VoidCallback onTap;

  const GroupTableRow({
    super.key,
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<GroupTableRow> createState() => _GroupTableRowState();
}

class _GroupTableRowState extends State<GroupTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final group = widget.group;

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
                  child: group.logo != null
                      ? ClipOval(
                          child: Image.network(
                            group.logo!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.group,
                              size: 16,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.group,
                          size: 16,
                          color: colors.onPrimaryContainer,
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                flex: 2,
                child: Text(
                  group.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  group.groupType == 'teams' ? 'Team' : 'Users',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: group.autoJoin
                        ? Colors.green.withValues(alpha: 0.1)
                        : colors.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    group.autoJoin ? 'Enabled' : 'Disabled',
                    style: textTheme.labelSmall?.copyWith(
                      color: group.autoJoin ? Colors.green : colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  group.twoFactorAuth == 'required' ? 'Required' : 'Optional',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
