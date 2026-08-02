import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';

class AddComment
    extends UseCasePermission<ArticleComment, AddCommentParams> {
  final ArticleCommentRepository repository;
  const AddComment(this.repository);

  @override
  Future<Either<Failure, ArticleComment>> call({
    required AddCommentParams params,
  }) async {
    return await repository.addComment(params.comment);
  }

  @override
  Permission get requiredPermission => Permission.commentCreateArticleComment;
  
  @override
  Future<Either<Failure, ArticleComment>> execute({required AddCommentParams params}) {
    return repository.addComment(params.comment);
  }
}

class AddCommentParams extends Params {
  final ArticleComment comment;
  const AddCommentParams({required this.comment});

  @override
  List<Object?> get props => [comment];
}
