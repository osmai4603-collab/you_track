import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_tree.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticleTree useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = GetArticleTree(mockRepository);
  });

  final now = DateTime.now();
  final testArticles = [
    Article(
      id: '1',
      projectId: 'proj-1',
      title: 'Article 1',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
    Article(
      id: '2',
      projectId: 'proj-1',
      parentId: '1',
      title: 'Article 2',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  test('returns list of articles from repository', () async {
    when(() => mockRepository.getArticleTree('proj-1'))
        .thenAnswer((_) async => Right(testArticles));

    final result = await useCase(
      params: const GetArticleTreeParams(projectId: 'proj-1'),
    );

    expect(result, isA<Right<dynamic, List<Article>>>());
    result.fold(
      (l) => fail('Expected Right'),
      (r) => expect(r.length, 2),
    );
  });

  test('returns failure from repository', () async {
    when(() => mockRepository.getArticleTree('proj-1'))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    final result = await useCase(
      params: const GetArticleTreeParams(projectId: 'proj-1'),
    );

    expect(result.isLeft(), true);
  });
}
