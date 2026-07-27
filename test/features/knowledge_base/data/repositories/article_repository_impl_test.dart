import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/models/article_model.dart';
import 'package:issues_tracking/features/knowledge_base/data/repositories/article_repository_impl.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';

class MockArticleRemoteDataSource extends Mock
    implements ArticleRemoteDataSource {}

class MockArticleLocalDataSource extends Mock
    implements ArticleLocalDataSource {}

void main() {
  late ArticleRepositoryImpl repository;
  late MockArticleRemoteDataSource mockRemoteDataSource;
  late MockArticleLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(ArticleModel(
      id: '',
      projectId: '',
      title: '',
      createdBy: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockRemoteDataSource = MockArticleRemoteDataSource();
    mockLocalDataSource = MockArticleLocalDataSource();
    repository = ArticleRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final now = DateTime.now();
  final testArticle = Article(
    id: '1',
    projectId: 'proj-1',
    title: 'Test Article',
    contentMarkdown: '# Hello',
    status: 'draft',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  final testArticleModel = ArticleModel(
    id: '1',
    projectId: 'proj-1',
    title: 'Test Article',
    contentMarkdown: '# Hello',
    status: 'draft',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  group('getArticleTree', () {
    test('returns list of articles on success', () async {
      when(() => mockRemoteDataSource.getArticleTree('proj-1'))
          .thenAnswer((_) async => [testArticleModel]);

      final result = await repository.getArticleTree('proj-1');

      expect(result, isA<Right<Failure, List<Article>>>());
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.length, 1),
      );
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.getArticleTree('proj-1'))
          .thenThrow(Exception('Server error'));

      final result = await repository.getArticleTree('proj-1');

      expect(result, isA<Left<Failure, List<Article>>>());
    });
  });

  group('getArticleById', () {
    test('returns article on success', () async {
      when(() => mockRemoteDataSource.getArticleById('1'))
          .thenAnswer((_) async => testArticleModel);

      final result = await repository.getArticleById('1');

      expect(result, isA<Right<Failure, Article>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.getArticleById('1'))
          .thenThrow(Exception('Not found'));

      final result = await repository.getArticleById('1');

      expect(result, isA<Left<Failure, Article>>());
    });
  });

  group('createArticle', () {
    test('returns created article on success', () async {
      when(() => mockRemoteDataSource.createArticle(any()))
          .thenAnswer((_) async => testArticleModel);

      final result = await repository.createArticle(testArticle);

      expect(result, isA<Right<Failure, Article>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.createArticle(any()))
          .thenThrow(Exception('Create failed'));

      final result = await repository.createArticle(testArticle);

      expect(result, isA<Left<Failure, Article>>());
    });
  });

  group('updateArticle', () {
    test('returns updated article on success', () async {
      when(() => mockRemoteDataSource.updateArticle(any()))
          .thenAnswer((_) async => testArticleModel);

      final result = await repository.updateArticle(testArticle);

      expect(result, isA<Right<Failure, Article>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.updateArticle(any()))
          .thenThrow(Exception('Update failed'));

      final result = await repository.updateArticle(testArticle);

      expect(result, isA<Left<Failure, Article>>());
    });
  });

  group('publishArticle', () {
    test('returns Right(null) on success', () async {
      when(() => mockRemoteDataSource.getArticleById('1'))
          .thenAnswer((_) async => testArticleModel);
      when(() => mockRemoteDataSource.updateArticle(any()))
          .thenAnswer((_) async => ArticleModel.fromEntity(testArticleModel.copyWith(status: 'published')));

      final result = await repository.publishArticle('1');

      expect(result, isA<Right<Failure, void>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.getArticleById('1'))
          .thenThrow(Exception('Publish failed'));

      final result = await repository.publishArticle('1');

      expect(result, isA<Left<Failure, void>>());
    });
  });

  group('deleteArticle', () {
    test('returns Right(null) on success', () async {
      when(() => mockRemoteDataSource.deleteArticle('1'))
          .thenAnswer((_) async {});

      final result = await repository.deleteArticle('1');

      expect(result, isA<Right<Failure, void>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.deleteArticle('1'))
          .thenThrow(Exception('Delete failed'));

      final result = await repository.deleteArticle('1');

      expect(result, isA<Left<Failure, void>>());
    });
  });

  group('reorderArticles', () {
    test('returns Right(null) on success', () async {
      when(() => mockRemoteDataSource.updateArticle(any()))
          .thenAnswer((_) async => testArticleModel);

      final result = await repository.reorderArticles([testArticle]);

      expect(result, isA<Right<Failure, void>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.updateArticle(any()))
          .thenThrow(Exception('Reorder failed'));

      final result = await repository.reorderArticles([testArticle]);

      expect(result, isA<Left<Failure, void>>());
    });
  });

  group('searchArticles', () {
    test('returns list of articles on success', () async {
      when(() => mockRemoteDataSource.searchArticles('proj-1', 'test'))
          .thenAnswer((_) async => [testArticleModel]);

      final result = await repository.searchArticles('proj-1', 'test');

      expect(result, isA<Right<Failure, List<Article>>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockRemoteDataSource.searchArticles('proj-1', 'test'))
          .thenThrow(Exception('Search failed'));

      final result = await repository.searchArticles('proj-1', 'test');

      expect(result, isA<Left<Failure, List<Article>>>());
    });
  });
}
