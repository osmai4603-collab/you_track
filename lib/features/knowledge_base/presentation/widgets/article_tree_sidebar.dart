import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_state.dart';

class ArticleTreeSidebar extends StatelessWidget {
  const ArticleTreeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleTreeBloc, ArticleTreeState>(
      builder: (context, state) {
        if (state is ArticleTreeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ArticleTreeError) {
          return Center(child: SelectableText(state.message));
        }
        if (state is ArticleTreeLoaded) {
          final rootArticles = state.tree['root'] ?? [];
          if (rootArticles.isEmpty) {
            return const Center(
              child: Text('No articles yet'),
            );
          }
          return ReorderableListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final reordered = List<Article>.from(rootArticles);
              final item = reordered.removeAt(oldIndex);
              reordered.insert(newIndex, item);
              context.read<ArticleTreeBloc>().add(
                    ReorderArticlesInTree(
                      projectId: state.projectId,
                      parentParentId: 'root',
                      articleIds: reordered.map((a) => a.id).toList(),
                    ),
                  );
            },
            children: rootArticles.map((article) {
              return _buildNode(context, article, state, 0);
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNode(
    BuildContext context,
    Article article,
    ArticleTreeLoaded state,
    int depth,
  ) {
    final children = state.tree[article.id] ?? [];
    final hasChildren = children.isNotEmpty;
    final isExpanded = state.expandedNodeIds.contains(article.id);
    final isSelected = state.selectedArticleId == article.id;

    return Dismissible(
      key: ValueKey(article.id),
      direction: hasChildren ? DismissDirection.none : DismissDirection.horizontal,
      confirmDismiss: (_) async {
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        key: ValueKey('column_${article.id}'),
        children: [
          InkWell(
            onTap: () {
              context.read<ArticleTreeBloc>().add(SelectArticle(article.id));
            },
            onLongPress: () => _showContextMenu(context, article),
            child: Container(
              padding: EdgeInsets.only(
                left: 16.0 + depth * 20.0,
                right: 8.0,
                top: 6.0,
                bottom: 6.0,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : null,
              child: Row(
                children: [
                  if (hasChildren)
                    GestureDetector(
                      onTap: () {
                        if (isExpanded) {
                          context
                              .read<ArticleTreeBloc>()
                              .add(CollapseNode(article.id));
                        } else {
                          context
                              .read<ArticleTreeBloc>()
                              .add(ExpandNode(article.id));
                        }
                      },
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 20,
                      ),
                    )
                  else
                    const SizedBox(width: 20),
                  const SizedBox(width: 4),
                  Icon(
                    hasChildren ? Icons.folder_outlined : Icons.article_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      article.title.isEmpty ? 'Untitled' : article.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tooltip(
                    message: 'New sub-article',
                    child: InkWell(
                      onTap: () => _createSubArticle(context, article, state),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasChildren && isExpanded)
            ...children.map((child) => _buildNode(context, child, state, depth + 1)),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context, Article article) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('New sub-article'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  final state = context.read<ArticleTreeBloc>().state;
                  if (state is ArticleTreeLoaded) {
                    _createSubArticle(context, article, state);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(context, article);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Article article) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Article'),
          content: const Text(
            'This will re-parent children to parent. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context
                    .read<ArticleTreeBloc>()
                    .add(DeleteArticleFromTree(article.id));
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _createSubArticle(
    BuildContext context,
    Article parentArticle,
    ArticleTreeLoaded state,
  ) {
    context.push(
      AppRouteKeys.projectKnowledgeBasePath(state.projectId) + '/new',
      extra: {
        'projectId': state.projectId,
        'parentId': parentArticle.id,
      },
    );
  }
}
