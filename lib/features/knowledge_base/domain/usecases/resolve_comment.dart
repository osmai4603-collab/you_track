import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';

class ResolveComment extends UseCase<void, ResolveCommentParams> {
  @override
  Permission get requiredPermission => Permission.commentUpdateArticleComment;

  final ArticleCommentRepository repository;
  const ResolveComment(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required ResolveCommentParams params,
  }) async {
    return await repository.resolveComment(params.commentId, params.resolvedBy);
  }
}

class ResolveCommentParams extends Params {
  final String commentId;
  final String resolvedBy;
  const ResolveCommentParams({
    required this.commentId,
    required this.resolvedBy,
  });

  @override
  List<Object?> get props => [commentId, resolvedBy];
}
