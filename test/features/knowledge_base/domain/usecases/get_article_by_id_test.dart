import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_by_id.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticleById useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = GetArticleById(mockRepository);
  });

  final now = DateTime.now();
  final testArticle = Article(
    id: '1',
    projectId: 'proj-1',
    title: 'Test Article',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  test('returns article from repository', () async {
    when(() => mockRepository.getArticleById('1'))
        .thenAnswer((_) async => Right(testArticle));

    final result = await useCase(
      params: const GetArticleByIdParams(articleId: '1'),
    );

    expect(result, isA<Right<dynamic, Article>>());
    result.fold(
      (l) => fail('Expected Right'),
      (r) => expect(r.id, '1'),
    );
  });

  test('returns failure from repository', () async {
    when(() => mockRepository.getArticleById('1'))
        .thenAnswer((_) async => const Left(ServerFailure('Not found')));

    final result = await useCase(
      params: const GetArticleByIdParams(articleId: '1'),
    );

    expect(result.isLeft(), true);
  });
}
