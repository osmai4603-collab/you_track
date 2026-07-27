import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';

abstract class ArticleCommentEvent extends Equatable {
  const ArticleCommentEvent();
  @override
  List<Object?> get props => [];
}

class LoadComments extends ArticleCommentEvent {
  final String articleId;
  const LoadComments(this.articleId);
  @override
  List<Object?> get props => [articleId];
}

class AddNewComment extends ArticleCommentEvent {
  final ArticleComment comment;
  const AddNewComment(this.comment);
  @override
  List<Object?> get props => [comment];
}

class ResolveCommentEvent extends ArticleCommentEvent {
  final String commentId;
  final String resolvedBy;
  const ResolveCommentEvent({
    required this.commentId,
    required this.resolvedBy,
  });
  @override
  List<Object?> get props => [commentId, resolvedBy];
}

class DeleteCommentEvent extends ArticleCommentEvent {
  final String commentId;
  const DeleteCommentEvent(this.commentId);
  @override
  List<Object?> get props => [commentId];
}
