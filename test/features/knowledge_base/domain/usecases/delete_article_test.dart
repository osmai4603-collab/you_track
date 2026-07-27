import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late DeleteArticle useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = DeleteArticle(mockRepository);
  });

  test('deletes article successfully', () async {
    when(() => mockRepository.deleteArticle('1'))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(
      params: const DeleteArticleParams(articleId: '1'),
    );

    expect(result, isA<Right<dynamic, void>>());
  });

  test('returns failure on error', () async {
    when(() => mockRepository.deleteArticle('1'))
        .thenAnswer((_) async => const Left(ServerFailure('Delete failed')));

    final result = await useCase(
      params: const DeleteArticleParams(articleId: '1'),
    );

    expect(result.isLeft(), true);
  });
}
