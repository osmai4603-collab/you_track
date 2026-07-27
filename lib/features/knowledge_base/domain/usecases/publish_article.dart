import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class PublishArticle extends UseCase<void, PublishArticleParams> {
  final ArticleRepository repository;
  const PublishArticle(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required PublishArticleParams params,
  }) async {
    return await repository.publishArticle(params.articleId);
  }
}

class PublishArticleParams extends Params {
  final String articleId;
  const PublishArticleParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
