import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class ReorderArticles extends UseCasePermission<void, ReorderArticlesParams> {
  final ArticleRepository repository;
  const ReorderArticles(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required ReorderArticlesParams params,
  }) async {
    return await repository.reorderArticles(params.articles);
  }
}

class ReorderArticlesParams extends Params {
  final List<Article> articles;
  const ReorderArticlesParams({required this.articles});

  @override
  List<Object?> get props => [articles];
}
