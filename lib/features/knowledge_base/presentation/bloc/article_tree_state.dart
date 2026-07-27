import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';

abstract class ArticleTreeState extends Equatable {
  const ArticleTreeState();

  @override
  List<Object?> get props => [];
}

class ArticleTreeInitial extends ArticleTreeState {}

class ArticleTreeLoading extends ArticleTreeState {}

class ArticleTreeLoaded extends ArticleTreeState {
  final List<Article> articles;
  final Map<String, List<Article>> tree;
  final String? selectedArticleId;
  final Set<String> expandedNodeIds;
  final String projectId;

  const ArticleTreeLoaded({
    required this.articles,
    required this.tree,
    this.selectedArticleId,
    this.expandedNodeIds = const {},
    required this.projectId,
  });

  ArticleTreeLoaded copyWith({
    List<Article>? articles,
    Map<String, List<Article>>? tree,
    String? selectedArticleId,
    bool clearSelectedArticle = false,
    Set<String>? expandedNodeIds,
    String? projectId,
  }) {
    return ArticleTreeLoaded(
      articles: articles ?? this.articles,
      tree: tree ?? this.tree,
      selectedArticleId: clearSelectedArticle
          ? null
          : (selectedArticleId ?? this.selectedArticleId),
      expandedNodeIds: expandedNodeIds ?? this.expandedNodeIds,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        tree,
        selectedArticleId,
        expandedNodeIds,
        projectId,
      ];
}

class ArticleTreeError extends ArticleTreeState {
  final String message;
  const ArticleTreeError(this.message);

  @override
  List<Object?> get props => [message];
}
