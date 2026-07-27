import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_comment_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/models/article_comment_model.dart';
import 'package:issues_tracking/features/knowledge_base/data/repositories/article_comment_repository_impl.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';

class MockArticleCommentRemoteDataSource extends Mock
    implements ArticleCommentRemoteDataSource {}

void main() {
  late ArticleCommentRepositoryImpl repository;
  late MockArticleCommentRemoteDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(ArticleCommentModel(
      id: '',
      articleId: '',
      authorId: '',
      commentText: '',
      anchorText: '',
      anchorStart: 0,
      anchorEnd: 0,
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockDataSource = MockArticleCommentRemoteDataSource();
    repository = ArticleCommentRepositoryImpl(remoteDataSource: mockDataSource);
  });

  final now = DateTime.now();
  final testComment = ArticleComment(
    id: 'c1',
    articleId: 'a1',
    authorId: 'u1',
    commentText: 'Great article!',
    anchorText: 'Hello',
    anchorStart: 0,
    anchorEnd: 5,
    createdAt: now,
  );

  final testCommentModel = ArticleCommentModel(
    id: 'c1',
    articleId: 'a1',
    authorId: 'u1',
    commentText: 'Great article!',
    anchorText: 'Hello',
    anchorStart: 0,
    anchorEnd: 5,
    createdAt: now,
  );

  group('getComments', () {
    test('returns list of comments on success', () async {
      when(() => mockDataSource.getComments('a1'))
          .thenAnswer((_) async => [testCommentModel]);

      final result = await repository.getComments('a1');

      expect(result, isA<Right<Failure, List<ArticleComment>>>());
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.length, 1),
      );
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockDataSource.getComments('a1'))
          .thenThrow(Exception('Error'));

      final result = await repository.getComments('a1');

      expect(result, isA<Left<Failure, List<ArticleComment>>>());
    });
  });

  group('addComment', () {
    test('returns created comment on success', () async {
      when(() => mockDataSource.addComment(any()))
          .thenAnswer((_) async => testCommentModel);

      final result = await repository.addComment(testComment);

      expect(result, isA<Right<Failure, ArticleComment>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockDataSource.addComment(any()))
          .thenThrow(Exception('Error'));

      final result = await repository.addComment(testComment);

      expect(result, isA<Left<Failure, ArticleComment>>());
    });
  });

  group('resolveComment', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.resolveComment('c1', 'u1'))
          .thenAnswer((_) async {});

      final result = await repository.resolveComment('c1', 'u1');

      expect(result, isA<Right<Failure, void>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockDataSource.resolveComment('c1', 'u1'))
          .thenThrow(Exception('Error'));

      final result = await repository.resolveComment('c1', 'u1');

      expect(result, isA<Left<Failure, void>>());
    });
  });

  group('deleteComment', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.deleteComment('c1'))
          .thenAnswer((_) async {});

      final result = await repository.deleteComment('c1');

      expect(result, isA<Right<Failure, void>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockDataSource.deleteComment('c1'))
          .thenThrow(Exception('Error'));

      final result = await repository.deleteComment('c1');

      expect(result, isA<Left<Failure, void>>());
    });
  });
}
