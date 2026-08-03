import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class UpdateArticle extends UseCase<Article, UpdateArticleParams> {
  @override
  Permission get requiredPermission => Permission.articleUpdateArticle;

  @override
  String? getProjectId(UpdateArticleParams params) => params.article.projectId;

  final ArticleRepository repository;
  const UpdateArticle(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    required UpdateArticleParams params,
  }) async {
    return await repository.updateArticle(params.article);
  }
}

class UpdateArticleParams extends Params {
  final Article article;
  const UpdateArticleParams({required this.article});

  @override
  List<Object?> get props => [article];
}
