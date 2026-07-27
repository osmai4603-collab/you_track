import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_event.dart';

class ArticleCommentThread extends StatefulWidget {
  final String articleId;
  final List<ArticleComment> comments;
  final String currentUserId;

  const ArticleCommentThread({
    super.key,
    required this.articleId,
    required this.comments,
    required this.currentUserId,
  });

  @override
  State<ArticleCommentThread> createState() => _ArticleCommentThreadState();
}

class _ArticleCommentThreadState extends State<ArticleCommentThread> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final comment = ArticleComment(
      id: now.millisecondsSinceEpoch.toString(),
      articleId: widget.articleId,
      authorId: widget.currentUserId,
      commentText: text,
      anchorText: '',
      anchorStart: 0,
      anchorEnd: 0,
      createdAt: now,
    );

    context.read<ArticleCommentBloc>().add(AddNewComment(comment));
    _controller.clear();
  }

  void _resolveComment(ArticleComment comment) {
    context.read<ArticleCommentBloc>().add(
          ResolveCommentEvent(
            commentId: comment.id,
            resolvedBy: widget.currentUserId,
          ),
        );
  }

  void _deleteComment(ArticleComment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      context
          .read<ArticleCommentBloc>()
          .add(DeleteCommentEvent(comment.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sorted = [...widget.comments]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sorted.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No comments yet.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ...sorted.map((comment) => _buildCommentCard(comment, colorScheme)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                widget.currentUserId.isNotEmpty
                    ? widget.currentUserId[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
                onSubmitted: (_) => _addComment(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addComment,
              icon: const Icon(Icons.send, size: 20),
              tooltip: 'Send comment',
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentCard(ArticleComment comment, ColorScheme colorScheme) {
    final isResolved = comment.isResolved;
    final opacity = isResolved ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colorScheme.secondaryContainer,
                    child: Text(
                      comment.authorId.isNotEmpty
                          ? comment.authorId[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.authorId.length > 12
                              ? '${comment.authorId.substring(0, 12)}...'
                              : comment.authorId,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatTimestamp(comment.createdAt),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (comment.authorId == widget.currentUserId)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'resolve') _resolveComment(comment);
                        if (value == 'delete') _deleteComment(comment);
                      },
                      itemBuilder: (context) => [
                        if (!isResolved)
                          const PopupMenuItem(
                            value: 'resolve',
                            child: Text('Resolve'),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      icon: Icon(
                        Icons.more_vert,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                comment.commentText,
                style: TextStyle(
                  decoration:
                      isResolved ? TextDecoration.lineThrough : null,
                  color: colorScheme.onSurface,
                ),
              ),
              if (isResolved)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Resolved',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}
