import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';

class GetCommentsForArticle
    extends
        UseCasePermission<List<ArticleComment>, GetCommentsForArticleParams> {
  @override
  Permission get requiredPermission => Permission.commentReadArticleComment;

  final ArticleCommentRepository repository;
  const GetCommentsForArticle(this.repository);

  @override
  Future<Either<Failure, List<ArticleComment>>> call({
    required GetCommentsForArticleParams params,
  }) async {
    return await repository.getComments(params.articleId);
  }

  @override
  Future<Either<Failure, List<ArticleComment>>> execute({required GetCommentsForArticleParams params}) {
    return repository.getComments(params.articleId);
  }
}

class GetCommentsForArticleParams extends Params {
  final String articleId;
  const GetCommentsForArticleParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
