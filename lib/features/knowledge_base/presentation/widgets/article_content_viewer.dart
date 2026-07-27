import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_comment_thread.dart';

class ArticleContentViewer extends StatefulWidget {
  final String content;
  final List<ArticleComment> comments;
  final String? articleId;
  final String? currentUserId;

  const ArticleContentViewer({
    super.key,
    required this.content,
    this.comments = const [],
    this.articleId,
    this.currentUserId,
  });

  @override
  State<ArticleContentViewer> createState() => _ArticleContentViewerState();
}

class _ArticleContentViewerState extends State<ArticleContentViewer> {
  String? _selectedText;
  OverlayEntry? _selectionOverlay;
  OverlayEntry? _threadOverlay;
  final GlobalKey _contentKey = GlobalKey();

  @override
  void dispose() {
    _removeSelectionOverlay();
    _removeThreadOverlay();
    super.dispose();
  }

  void _removeSelectionOverlay() {
    _selectionOverlay?.remove();
    _selectionOverlay = null;
  }

  void _removeThreadOverlay() {
    _threadOverlay?.remove();
    _threadOverlay = null;
  }

  void _onSelectionChanged(String? text) {
    if (text == null || text.isEmpty || text.length < 2) {
      _removeSelectionOverlay();
      return;
    }

    setState(() => _selectedText = text);
    _showAddCommentMenu();
  }

  void _showAddCommentMenu() {
    _removeSelectionOverlay();

    _selectionOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        right: 24,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              _removeSelectionOverlay();
              _showCommentThread();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_comment,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add Comment',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_selectionOverlay!);
  }

  void _showCommentThread() {
    _removeThreadOverlay();

    if (widget.articleId == null || widget.currentUserId == null) return;

    final anchorComments = widget.comments
        .where((c) =>
            c.anchorText == _selectedText ||
            (_selectedText != null &&
                widget.content.contains(_selectedText!)))
        .toList();

    _threadOverlay = OverlayEntry(
      builder: (context) => Positioned(
        right: 16,
        top: 80,
        bottom: 80,
        width: 340,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comments',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w600),
                          ),
                          if (_selectedText != null)
                            Text(
                              '"${_selectedText!.length > 40 ? '${_selectedText!.substring(0, 40)}...' : _selectedText}"',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _removeThreadOverlay();
                        setState(() => _selectedText = null);
                      },
                      icon: const Icon(Icons.close, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocProvider.value(
                  value: context.read<ArticleCommentBloc>(),
                  child: ArticleCommentThread(
                    articleId: widget.articleId!,
                    comments: anchorComments,
                    currentUserId: widget.currentUserId!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_threadOverlay!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content.isEmpty) {
      return Center(
        child: Text(
          'This article has no content yet.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    final hasInlineComments = widget.comments.isNotEmpty &&
        widget.articleId != null &&
        widget.currentUserId != null;

    return Stack(
      key: _contentKey,
      children: [
        SelectionArea(
          onSelectionChanged: hasInlineComments
              ? (selection) {
                  final text = selection?.plainText;
                  _onSelectionChanged(text);
                }
              : null,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: MarkdownBody(
              data: widget.content,
              selectable: true,
            ),
          ),
        ),
        if (hasInlineComments && _selectedText == null)
          Positioned(
            top: 8,
            right: 8,
            child: Tooltip(
              message: 'Select text to add a comment',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.rate_review_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
