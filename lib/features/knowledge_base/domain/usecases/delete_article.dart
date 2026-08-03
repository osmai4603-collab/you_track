import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';

class DeleteArticle extends UseCase<void, DeleteArticleParams> {
  @override
  Permission get requiredPermission => Permission.articleDeleteArticle;

  final ArticleRepository repository;
  const DeleteArticle(this.repository);

  @override
  call({required DeleteArticleParams params}) {
    return repository.deleteArticle(params.articleId);
  }
}

class DeleteArticleParams extends Params {
  final String articleId;
  const DeleteArticleParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
