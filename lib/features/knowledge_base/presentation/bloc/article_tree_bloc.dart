import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_tree.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/reorder_articles.dart';

import 'article_tree_event.dart';
import 'article_tree_state.dart';

class ArticleTreeBloc extends Bloc<ArticleTreeEvent, ArticleTreeState> {
  final GetArticleTree getArticleTree;
  final DeleteArticle deleteArticle;
  final ReorderArticles reorderArticles;

  ArticleTreeBloc({
    required this.getArticleTree,
    required this.deleteArticle,
    required this.reorderArticles,
  }) : super(ArticleTreeInitial()) {
    on<LoadArticleTree>(_onLoadArticleTree);
    on<SelectArticle>(_onSelectArticle);
    on<ExpandNode>(_onExpandNode);
    on<CollapseNode>(_onCollapseNode);
    on<DeleteArticleFromTree>(_onDeleteArticleFromTree);
    on<ReorderArticlesInTree>(_onReorderArticles);
  }

  Map<String, List<Article>> _buildTree(List<Article> articles) {
    final Map<String, List<Article>> tree = {};
    for (final article in articles) {
      final parentId = article.parentId ?? 'root';
      tree.putIfAbsent(parentId, () => []).add(article);
    }
    for (final entry in tree.entries) {
      entry.value.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
    return tree;
  }

  Future<void> _onLoadArticleTree(
    LoadArticleTree event,
    Emitter<ArticleTreeState> emit,
  ) async {
    emit(ArticleTreeLoading());
    final result = await getArticleTree(
      params: GetArticleTreeParams(projectId: event.projectId),
    );
    result.fold(
      (failure) => emit(ArticleTreeError(failure.message)),
      (articles) => emit(ArticleTreeLoaded(
        articles: articles,
        tree: _buildTree(articles),
        projectId: event.projectId,
      )),
    );
  }

  void _onSelectArticle(
    SelectArticle event,
    Emitter<ArticleTreeState> emit,
  ) {
    if (state is ArticleTreeLoaded) {
      final current = state as ArticleTreeLoaded;
      emit(current.copyWith(selectedArticleId: event.articleId));
    }
  }

  void _onExpandNode(
    ExpandNode event,
    Emitter<ArticleTreeState> emit,
  ) {
    if (state is ArticleTreeLoaded) {
      final current = state as ArticleTreeLoaded;
      final newExpanded = Set<String>.from(current.expandedNodeIds)
        ..add(event.articleId);
      emit(current.copyWith(expandedNodeIds: newExpanded));
    }
  }

  void _onCollapseNode(
    CollapseNode event,
    Emitter<ArticleTreeState> emit,
  ) {
    if (state is ArticleTreeLoaded) {
      final current = state as ArticleTreeLoaded;
      final newExpanded = Set<String>.from(current.expandedNodeIds)
        ..remove(event.articleId);
      emit(current.copyWith(expandedNodeIds: newExpanded));
    }
  }

  void _onDeleteArticleFromTree(
    DeleteArticleFromTree event,
    Emitter<ArticleTreeState> emit,
  ) async {
    if (state is ArticleTreeLoaded) {
      final current = state as ArticleTreeLoaded;

      final articleToDelete = current.articles
          .where((a) => a.id == event.articleId)
          .firstOrNull;
      if (articleToDelete == null) return;

      final updatedArticles = current.articles.map((article) {
        if (article.parentId == event.articleId) {
          return article.copyWith(
            parentId: articleToDelete.parentId,
            clearParentId: articleToDelete.parentId == null,
          );
        }
        return article;
      }).where((a) => a.id != event.articleId).toList();

      final newSelectedId = current.selectedArticleId == event.articleId
          ? null
          : current.selectedArticleId;

      final newExpanded = Set<String>.from(current.expandedNodeIds)
        ..remove(event.articleId);

      await deleteArticle(
        params: DeleteArticleParams(articleId: event.articleId),
      );

      emit(ArticleTreeLoaded(
        articles: updatedArticles,
        tree: _buildTree(updatedArticles),
        selectedArticleId: newSelectedId,
        expandedNodeIds: newExpanded,
        projectId: current.projectId,
      ));
    }
  }

  void _onReorderArticles(
    ReorderArticlesInTree event,
    Emitter<ArticleTreeState> emit,
  ) async {
    if (state is ArticleTreeLoaded) {
      final current = state as ArticleTreeLoaded;

      final updatedArticles = current.articles.map((article) {
        final index = event.articleIds.indexOf(article.id);
        if (index >= 0) {
          return article.copyWith(sortOrder: index);
        }
        return article;
      }).toList();

      final reordered = event.articleIds
          .map((id) => updatedArticles.firstWhere((a) => a.id == id))
          .toList();

      await reorderArticles(
        params: ReorderArticlesParams(articles: reordered),
      );

      emit(ArticleTreeLoaded(
        articles: updatedArticles,
        tree: _buildTree(updatedArticles),
        selectedArticleId: current.selectedArticleId,
        expandedNodeIds: current.expandedNodeIds,
        projectId: current.projectId,
      ));
    }
  }
}
