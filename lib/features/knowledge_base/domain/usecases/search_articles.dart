import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class SearchArticles extends UseCasePermission<List<Article>, SearchArticlesParams> {
  @override
  Permission get requiredPermission => Permission.articleReadArticle;

  final ArticleRepository repository;
  const SearchArticles(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    required SearchArticlesParams params,
  }) async {
    return await repository.searchArticles(params.projectId, params.query);
  }
}

class SearchArticlesParams extends Params {
  final String projectId;
  final String query;
  const SearchArticlesParams({required this.projectId, required this.query});

  @override
  List<Object?> get props => [projectId, query];
}
