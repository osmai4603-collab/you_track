import 'package:flutter/material.dart';

class ArticleInlineCommentAnchor extends StatelessWidget {
  final String text;
  final bool hasComment;
  final VoidCallback? onTap;

  const ArticleInlineCommentAnchor({
    super.key,
    required this.text,
    this.hasComment = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: hasComment
            ? BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.6),
                  width: 1,
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  backgroundColor: hasComment
                      ? Colors.amber.withValues(alpha: 0.15)
                      : null,
                ),
              ),
            ),
            if (hasComment) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.comment,
                size: 14,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
