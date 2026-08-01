import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class GetArticleById extends UseCasePermission<Article, GetArticleByIdParams> {
  final ArticleRepository repository;
  const GetArticleById(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    required GetArticleByIdParams params,
  }) async {
    return await repository.getArticleById(params.articleId);
  }
}

class GetArticleByIdParams extends Params {
  final String articleId;
  const GetArticleByIdParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
