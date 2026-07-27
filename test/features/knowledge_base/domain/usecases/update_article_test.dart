import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/update_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late UpdateArticle useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = UpdateArticle(mockRepository);
  });

  final now = DateTime.now();
  final testArticle = Article(
    id: '1',
    projectId: 'proj-1',
    title: 'Updated Article',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  test('updates article and returns it', () async {
    when(() => mockRepository.updateArticle(testArticle))
        .thenAnswer((_) async => Right(testArticle));

    final result = await useCase(
      params: UpdateArticleParams(article: testArticle),
    );

    expect(result, isA<Right<dynamic, Article>>());
  });

  test('returns failure on error', () async {
    when(() => mockRepository.updateArticle(testArticle))
        .thenAnswer((_) async => const Left(ServerFailure('Update failed')));

    final result = await useCase(
      params: UpdateArticleParams(article: testArticle),
    );

    expect(result.isLeft(), true);
  });
}
