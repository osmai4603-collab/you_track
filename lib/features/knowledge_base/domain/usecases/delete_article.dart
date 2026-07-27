import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class DeleteArticle extends UseCase<void, DeleteArticleParams> {
  final ArticleRepository repository;
  const DeleteArticle(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required DeleteArticleParams params,
  }) async {
    return await repository.deleteArticle(params.articleId);
  }
}

class DeleteArticleParams extends Params {
  final String articleId;
  const DeleteArticleParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
