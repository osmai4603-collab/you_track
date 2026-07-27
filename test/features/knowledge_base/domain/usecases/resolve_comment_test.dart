import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/resolve_comment.dart';

class MockArticleCommentRepository extends Mock
    implements ArticleCommentRepository {}

void main() {
  late ResolveComment useCase;
  late MockArticleCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleCommentRepository();
    useCase = ResolveComment(mockRepository);
  });

  test('resolves comment successfully', () async {
    when(() => mockRepository.resolveComment('c1', 'u1'))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(
      params: const ResolveCommentParams(commentId: 'c1', resolvedBy: 'u1'),
    );

    expect(result, isA<Right<dynamic, void>>());
  });

  test('returns failure on error', () async {
    when(() => mockRepository.resolveComment('c1', 'u1'))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    final result = await useCase(
      params: const ResolveCommentParams(commentId: 'c1', resolvedBy: 'u1'),
    );

    expect(result.isLeft(), true);
  });
}
