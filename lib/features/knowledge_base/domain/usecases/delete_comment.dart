import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';

class DeleteComment extends UseCasePermission<void, DeleteCommentParams> {
  final ArticleCommentRepository repository;
  const DeleteComment(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required DeleteCommentParams params,
  }) async {
    return await repository.deleteComment(params.commentId);
  }
}

class DeleteCommentParams extends Params {
  final String commentId;
  const DeleteCommentParams({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}
