import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class CreateArticle extends UseCasePermission<Article, CreateArticleParams> {
  @override
  Permission get requiredPermission => Permission.articleCreateArticle;

  final ArticleRepository repository;
  const CreateArticle(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    required CreateArticleParams params,
  }) async {
    return await repository.createArticle(params.article);
  }
  
  @override
  Future<Either<Failure, Article>> execute({required CreateArticleParams params}) {
    return repository.createArticle(params.article);
  }
}

class CreateArticleParams extends Params {
  final Article article;
  const CreateArticleParams({required this.article});

  @override
  List<Object?> get props => [article];
}
