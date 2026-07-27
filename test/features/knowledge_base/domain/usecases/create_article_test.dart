import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/create_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late CreateArticle useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = CreateArticle(mockRepository);
  });

  final now = DateTime.now();
  final testArticle = Article(
    id: '',
    projectId: 'proj-1',
    title: 'New Article',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  final createdArticle = Article(
    id: 'new-1',
    projectId: 'proj-1',
    title: 'New Article',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  test('creates article and returns it', () async {
    when(() => mockRepository.createArticle(testArticle))
        .thenAnswer((_) async => Right(createdArticle));

    final result = await useCase(
      params: CreateArticleParams(article: testArticle),
    );

    expect(result, isA<Right<dynamic, Article>>());
    result.fold(
      (l) => fail('Expected Right'),
      (r) => expect(r.id, 'new-1'),
    );
  });

  test('returns failure on error', () async {
    when(() => mockRepository.createArticle(testArticle))
        .thenAnswer((_) async => const Left(ServerFailure('Create failed')));

    final result = await useCase(
      params: CreateArticleParams(article: testArticle),
    );

    expect(result.isLeft(), true);
  });
}
