import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/publish_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late PublishArticle useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = PublishArticle(mockRepository);
  });

  test('publishes article successfully', () async {
    when(() => mockRepository.publishArticle('1'))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(
      params: const PublishArticleParams(articleId: '1'),
    );

    expect(result, isA<Right<dynamic, void>>());
  });

  test('returns failure on error', () async {
    when(() => mockRepository.publishArticle('1'))
        .thenAnswer((_) async => const Left(ServerFailure('Publish failed')));

    final result = await useCase(
      params: const PublishArticleParams(articleId: '1'),
    );

    expect(result.isLeft(), true);
  });
}
