import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_comments_for_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/add_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/resolve_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_comment.dart';

import 'article_comment_event.dart';
import 'article_comment_state.dart';

class ArticleCommentBloc extends Bloc<ArticleCommentEvent, ArticleCommentState> {
  final GetCommentsForArticle getComments;
  final AddComment addComment;
  final ResolveComment resolveComment;
  final DeleteComment deleteComment;

  ArticleCommentBloc({
    required this.getComments,
    required this.addComment,
    required this.resolveComment,
    required this.deleteComment,
  }) : super(ArticleCommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddNewComment>(_onAddNewComment);
    on<ResolveCommentEvent>(_onResolveComment);
    on<DeleteCommentEvent>(_onDeleteComment);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<ArticleCommentState> emit,
  ) async {
    emit(ArticleCommentLoading());
    final result = await getComments(
      params: GetCommentsForArticleParams(articleId: event.articleId),
    );
    result.fold(
      (failure) => emit(ArticleCommentError(failure.message)),
      (comments) => emit(ArticleCommentLoaded(comments)),
    );
  }

  Future<void> _onAddNewComment(
    AddNewComment event,
    Emitter<ArticleCommentState> emit,
  ) async {
    final result = await addComment(
      params: AddCommentParams(comment: event.comment),
    );
    result.fold(
      (failure) => emit(ArticleCommentError(failure.message)),
      (_) {
        if (state is ArticleCommentLoaded) {
          final current = (state as ArticleCommentLoaded).comments;
          emit(ArticleCommentLoaded([...current, event.comment]));
        }
      },
    );
  }

  Future<void> _onResolveComment(
    ResolveCommentEvent event,
    Emitter<ArticleCommentState> emit,
  ) async {
    final result = await resolveComment(
      params: ResolveCommentParams(
        commentId: event.commentId,
        resolvedBy: event.resolvedBy,
      ),
    );
    result.fold(
      (failure) => emit(ArticleCommentError(failure.message)),
      (_) {
        if (state is ArticleCommentLoaded) {
          final updated = (state as ArticleCommentLoaded).comments.map((c) {
            if (c.id == event.commentId) {
              return c.copyWith(
                isResolved: true,
                resolvedBy: event.resolvedBy,
                resolvedAt: DateTime.now(),
              );
            }
            return c;
          }).toList();
          emit(ArticleCommentLoaded(updated));
        }
      },
    );
  }

  Future<void> _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<ArticleCommentState> emit,
  ) async {
    final result = await deleteComment(
      params: DeleteCommentParams(commentId: event.commentId),
    );
    result.fold(
      (failure) => emit(ArticleCommentError(failure.message)),
      (_) {
        if (state is ArticleCommentLoaded) {
          final updated = (state as ArticleCommentLoaded)
              .comments
              .where((c) => c.id != event.commentId)
              .toList();
          emit(ArticleCommentLoaded(updated));
        }
      },
    );
  }
}
