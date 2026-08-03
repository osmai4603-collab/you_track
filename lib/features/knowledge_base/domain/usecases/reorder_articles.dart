import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class ReorderArticles extends UseCase<void, ReorderArticlesParams> {
  @override
  Permission get requiredPermission => Permission.articleUpdateArticle;

  final ArticleRepository repository;
  const ReorderArticles(this.repository);

  @override
  Future<Either<Failure, void>> call({required ReorderArticlesParams params}) {
    return repository.reorderArticles(params.articles);
  }
}

class ReorderArticlesParams extends Params {
  final List<Article> articles;
  const ReorderArticlesParams({required this.articles});

  @override
  List<Object?> get props => [articles];
}
