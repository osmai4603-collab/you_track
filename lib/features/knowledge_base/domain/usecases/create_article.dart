import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class CreateArticle extends UseCasePermission<Article, CreateArticleParams> {
  final ArticleRepository repository;
  const CreateArticle(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    required CreateArticleParams params,
  }) async {
    return await repository.createArticle(params.article);
  }
}

class CreateArticleParams extends Params {
  final Article article;
  const CreateArticleParams({required this.article});

  @override
  List<Object?> get props => [article];
}
