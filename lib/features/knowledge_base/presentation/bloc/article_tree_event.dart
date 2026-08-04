import 'package:equatable/equatable.dart';

abstract class ArticleTreeEvent extends Equatable {
  const ArticleTreeEvent();

  @override
  List<Object?> get props => [];
}

class LoadArticleTree extends ArticleTreeEvent {
  final String? projectId;
  const LoadArticleTree(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class SelectArticle extends ArticleTreeEvent {
  final String articleId;
  const SelectArticle(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class ExpandNode extends ArticleTreeEvent {
  final String articleId;
  const ExpandNode(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class CollapseNode extends ArticleTreeEvent {
  final String articleId;
  const CollapseNode(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class DeleteArticleFromTree extends ArticleTreeEvent {
  final String articleId;
  const DeleteArticleFromTree(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class ReorderArticlesInTree extends ArticleTreeEvent {
  final String? projectId;
  final String parentParentId;
  final List<String> articleIds;
  const ReorderArticlesInTree({
    required this.projectId,
    required this.parentParentId,
    required this.articleIds,
  });

  @override
  List<Object?> get props => [projectId, parentParentId, articleIds];
}
