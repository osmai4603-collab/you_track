import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class GetArticleTree
    extends UseCasePermission<List<Article>, GetArticleTreeParams> {
  @override
  Permission get requiredPermission => Permission.articleReadArticle;

  final ArticleRepository repository;
  const GetArticleTree(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    required GetArticleTreeParams params,
  }) async {
    return await repository.getArticleTree(params.projectId);
  }
}

class GetArticleTreeParams extends Params {
  final String projectId;
  const GetArticleTreeParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
