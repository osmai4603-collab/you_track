import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/reorder_articles.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late ReorderArticles useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = ReorderArticles(mockRepository);
  });

  final now = DateTime.now();
  final articles = [
    Article(
      id: '1',
      projectId: 'proj-1',
      title: 'Article 1',
      sortOrder: 0,
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
    Article(
      id: '2',
      projectId: 'proj-1',
      title: 'Article 2',
      sortOrder: 1,
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  test('reorders articles successfully', () async {
    when(() => mockRepository.reorderArticles(articles))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(
      params: ReorderArticlesParams(articles: articles),
    );

    expect(result, isA<Right<dynamic, void>>());
  });

  test('returns failure on error', () async {
    when(() => mockRepository.reorderArticles(articles))
        .thenAnswer((_) async => const Left(ServerFailure('Reorder failed')));

    final result = await useCase(
      params: ReorderArticlesParams(articles: articles),
    );

    expect(result.isLeft(), true);
  });
}
