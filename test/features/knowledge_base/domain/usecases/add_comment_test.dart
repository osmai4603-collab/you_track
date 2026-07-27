import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/add_comment.dart';

class MockArticleCommentRepository extends Mock
    implements ArticleCommentRepository {}

void main() {
  late AddComment useCase;
  late MockArticleCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleCommentRepository();
    useCase = AddComment(mockRepository);
  });

  final now = DateTime.now();
  final testComment = ArticleComment(
    id: '',
    articleId: 'a1',
    authorId: 'u1',
    commentText: 'Great!',
    anchorText: 'Hello',
    anchorStart: 0,
    anchorEnd: 5,
    createdAt: now,
  );

  final createdComment = ArticleComment(
    id: 'c1',
    articleId: 'a1',
    authorId: 'u1',
    commentText: 'Great!',
    anchorText: 'Hello',
    anchorStart: 0,
    anchorEnd: 5,
    createdAt: now,
  );

  test('adds comment successfully', () async {
    when(() => mockRepository.addComment(testComment))
        .thenAnswer((_) async => Right(createdComment));

    final result = await useCase(
      params: AddCommentParams(comment: testComment),
    );

    expect(result, isA<Right<dynamic, ArticleComment>>());
    result.fold(
      (l) => fail('Expected Right'),
      (r) => expect(r.id, 'c1'),
    );
  });

  test('returns failure on error', () async {
    when(() => mockRepository.addComment(testComment))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    final result = await useCase(
      params: AddCommentParams(comment: testComment),
    );

    expect(result.isLeft(), true);
  });
}
