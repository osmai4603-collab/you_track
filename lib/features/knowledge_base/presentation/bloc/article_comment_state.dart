import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';

abstract class ArticleCommentState extends Equatable {
  const ArticleCommentState();
  @override
  List<Object?> get props => [];
}

class ArticleCommentInitial extends ArticleCommentState {}

class ArticleCommentLoading extends ArticleCommentState {}

class ArticleCommentLoaded extends ArticleCommentState {
  final List<ArticleComment> comments;

  const ArticleCommentLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class ArticleCommentError extends ArticleCommentState {
  final String message;
  const ArticleCommentError(this.message);

  @override
  List<Object?> get props => [message];
}
