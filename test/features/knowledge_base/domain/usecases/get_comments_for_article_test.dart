import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_comments_for_article.dart';

class MockArticleCommentRepository extends Mock
    implements ArticleCommentRepository {}

void main() {
  late GetCommentsForArticle useCase;
  late MockArticleCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleCommentRepository();
    useCase = GetCommentsForArticle(mockRepository);
  });

  final now = DateTime.now();
  final testComments = [
    ArticleComment(
      id: 'c1',
      articleId: 'a1',
      authorId: 'u1',
      commentText: 'Great!',
      anchorText: 'Hello',
      anchorStart: 0,
      anchorEnd: 5,
      createdAt: now,
    ),
  ];

  test('returns comments for article', () async {
    when(() => mockRepository.getComments('a1'))
        .thenAnswer((_) async => Right(testComments));

    final result = await useCase(
      params: const GetCommentsForArticleParams(articleId: 'a1'),
    );

    expect(result, isA<Right<dynamic, List<ArticleComment>>>());
    result.fold(
      (l) => fail('Expected Right'),
      (r) => expect(r.length, 1),
    );
  });

  test('returns failure on error', () async {
    when(() => mockRepository.getComments('a1'))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    final result = await useCase(
      params: const GetCommentsForArticleParams(articleId: 'a1'),
    );

    expect(result.isLeft(), true);
  });
}
