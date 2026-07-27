import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_comments_for_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/add_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/resolve_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_comment.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_state.dart';

class MockGetCommentsForArticle extends Mock
    implements GetCommentsForArticle {}

class MockAddComment extends Mock implements AddComment {}

class MockResolveComment extends Mock implements ResolveComment {}

class MockDeleteComment extends Mock implements DeleteComment {}

void main() {
  late ArticleCommentBloc bloc;
  late MockGetCommentsForArticle mockGetComments;
  late MockAddComment mockAddComment;
  late MockResolveComment mockResolveComment;
  late MockDeleteComment mockDeleteComment;

  setUpAll(() {
    registerFallbackValue(const GetCommentsForArticleParams(articleId: ''));
    registerFallbackValue(AddCommentParams(comment: ArticleComment(
      id: '',
      articleId: '',
      authorId: '',
      commentText: '',
      anchorText: '',
      anchorStart: 0,
      anchorEnd: 0,
      createdAt: DateTime.now(),
    )));
    registerFallbackValue(const DeleteCommentParams(commentId: ''));
  });

  setUp(() {
    mockGetComments = MockGetCommentsForArticle();
    mockAddComment = MockAddComment();
    mockResolveComment = MockResolveComment();
    mockDeleteComment = MockDeleteComment();
    bloc = ArticleCommentBloc(
      getComments: mockGetComments,
      addComment: mockAddComment,
      resolveComment: mockResolveComment,
      deleteComment: mockDeleteComment,
    );
  });

  tearDown(() => bloc.close());

  final now = DateTime.now();
  final testComment = ArticleComment(
    id: 'c1',
    articleId: 'a1',
    authorId: 'u1',
    commentText: 'Great!',
    anchorText: 'Hello',
    anchorStart: 0,
    anchorEnd: 5,
    createdAt: now,
  );

  group('ArticleCommentBloc', () {
    test('initial state is ArticleCommentInitial', () {
      expect(bloc.state, isA<ArticleCommentInitial>());
    });

    group('LoadComments', () {
      test('emits [Loading, Loaded] on success', () async {
        when(() => mockGetComments(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right([testComment]));

        final states = <ArticleCommentState>[];
        bloc.stream.listen(states.add);

        bloc.add(const LoadComments('a1'));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleCommentLoading>());
        expect(states[1], isA<ArticleCommentLoaded>());

        final loaded = states[1] as ArticleCommentLoaded;
        expect(loaded.comments.length, 1);
      });

      test('emits [Loading, Error] on failure', () async {
        when(() => mockGetComments(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const Left(ServerFailure('Error')));

        final states = <ArticleCommentState>[];
        bloc.stream.listen(states.add);

        bloc.add(const LoadComments('a1'));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleCommentLoading>());
        expect(states[1], isA<ArticleCommentError>());
      });
    });

    group('AddNewComment', () {
      test('adds comment to loaded state', () async {
        when(() => mockGetComments(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const Right([]));
        when(() => mockAddComment(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testComment));

        final states = <ArticleCommentState>[];
        bloc.stream.listen(states.add);

        bloc.add(LoadComments('a1'));
        await Future.delayed(Duration.zero);

        bloc.add(AddNewComment(testComment));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleCommentLoaded;
        expect(loaded.comments.length, 1);
      });
    });

    group('DeleteCommentEvent', () {
      test('removes comment from loaded state', () async {
        when(() => mockGetComments(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right([testComment]));
        when(() => mockDeleteComment(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const Right(null));

        final states = <ArticleCommentState>[];
        bloc.stream.listen(states.add);

        bloc.add(const LoadComments('a1'));
        await Future.delayed(Duration.zero);

        bloc.add(const DeleteCommentEvent('c1'));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleCommentLoaded;
        expect(loaded.comments.length, 0);
      });
    });
  });
}
