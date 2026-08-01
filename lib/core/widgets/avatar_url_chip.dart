import 'package:flutter/material.dart';

class AvatarUrlChip extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final IconData defaultIcon;
  final Color? backColor;

  const AvatarUrlChip({
    super.key,
    this.avatarUrl,
    this.size = 32,
    this.backColor,
    this.defaultIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backColor ?? colors.primaryContainer,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  defaultIcon,
                  size: size * 0.75,
                  color: colors.onPrimaryContainer,
                ),
              ),
            )
          : Icon(
              defaultIcon,

              size: size * 0.75,
              color: colors.onPrimaryContainer,
            ),
    );
  }
}
