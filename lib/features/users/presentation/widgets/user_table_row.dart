import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

class UserTableRow extends StatefulWidget {
  final UserEntity user;
  final bool isSelected;
  final VoidCallback onTap;

  const UserTableRow({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<UserTableRow> createState() => _UserTableRowState();
}

class _UserTableRowState extends State<UserTableRow> {
  bool _isHovered = false;
  final List<Color> _avatarColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF9C27B0),
    const Color(0xFF00BCD4),
    const Color(0xFFFF5722),
    const Color(0xFFE91E63),
    const Color(0xFF3F51B5),
  ];

  Color _getAvatarColor(String initials) {
    final index = initials.hashCode.abs() % _avatarColors.length;
    return _avatarColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = widget.user;

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
              Checkbox(
                value: false,
                onChanged: null,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: AppSpacing.small),
              CircleAvatar(
                radius: 16,
                backgroundColor: _getAvatarColor(user.initials),
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.displayName,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (user.isBanned) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'banned',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      user.email,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  user.username,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  user.registrationDate != null
                      ? _formatDate(user.registrationDate!)
                      : '-',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: user.groups.isNotEmpty
                    ? Text(
                        user.groups.length > 1
                            ? '${user.groups.first}... +${user.groups.length - 1}'
                            : user.groups.first,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.primary,
                        ),
                      )
                    : null,
              ),
              SizedBox(
                width: 150,
                child: user.projects.isNotEmpty
                    ? Text(
                        user.projects.length > 1
                            ? '${user.projects.first}... +${user.projects.length - 1}'
                            : user.projects.first,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.primary,
                        ),
                      )
                    : null,
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_horiz, size: 18),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'ban', child: Text('Ban')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
