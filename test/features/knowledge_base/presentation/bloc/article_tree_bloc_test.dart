import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_tree.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/reorder_articles.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_state.dart';

class MockGetArticleTree extends Mock implements GetArticleTree {}

class MockDeleteArticle extends Mock implements DeleteArticle {}

class MockReorderArticles extends Mock implements ReorderArticles {}

void main() {
  late ArticleTreeBloc bloc;
  late MockGetArticleTree mockGetArticleTree;
  late MockDeleteArticle mockDeleteArticle;
  late MockReorderArticles mockReorderArticles;

  setUpAll(() {
    registerFallbackValue(const GetArticleTreeParams(projectId: ''));
    registerFallbackValue(const DeleteArticleParams(articleId: ''));
    registerFallbackValue(const ReorderArticlesParams(articles: []));
  });

  setUp(() {
    mockGetArticleTree = MockGetArticleTree();
    mockDeleteArticle = MockDeleteArticle();
    mockReorderArticles = MockReorderArticles();
    bloc = ArticleTreeBloc(
      getArticleTree: mockGetArticleTree,
      deleteArticle: mockDeleteArticle,
      reorderArticles: mockReorderArticles,
    );
  });

  tearDown(() => bloc.close());

  final now = DateTime.now();
  final testArticles = [
    Article(
      id: '1',
      projectId: 'proj-1',
      title: 'Root Article',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
    Article(
      id: '2',
      projectId: 'proj-1',
      parentId: '1',
      title: 'Child Article',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  group('ArticleTreeBloc', () {
    test('initial state is ArticleTreeInitial', () {
      expect(bloc.state, isA<ArticleTreeInitial>());
    });

    group('LoadArticleTree', () {
      test('emits [Loading, Loaded] on success', () async {
        when(() => mockGetArticleTree(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticles));

        final states = <ArticleTreeState>[];
        bloc.stream.listen(states.add);

        bloc.add(const LoadArticleTree('proj-1'));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleTreeLoading>());
        expect(states[1], isA<ArticleTreeLoaded>());

        final loaded = states[1] as ArticleTreeLoaded;
        expect(loaded.articles.length, 2);
        expect(loaded.tree.containsKey('root'), true);
        expect(loaded.tree['root']!.length, 1);
        expect(loaded.tree['1']!.length, 1);
      });

      test('emits [Loading, Error] on failure', () async {
        when(() => mockGetArticleTree(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const Left(ServerFailure('Error')));

        final states = <ArticleTreeState>[];
        bloc.stream.listen(states.add);

        bloc.add(const LoadArticleTree('proj-1'));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleTreeLoading>());
        expect(states[1], isA<ArticleTreeError>());
      });
    });

    group('SelectArticle', () {
      test('updates selectedArticleId', () async {
        when(() => mockGetArticleTree(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticles));

        bloc.add(const LoadArticleTree('proj-1'));
        await Future.delayed(Duration.zero);

        bloc.add(const SelectArticle('1'));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleTreeLoaded;
        expect(loaded.selectedArticleId, '1');
      });
    });

    group('ExpandNode', () {
      test('adds node to expandedNodeIds', () async {
        when(() => mockGetArticleTree(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticles));

        bloc.add(const LoadArticleTree('proj-1'));
        await Future.delayed(Duration.zero);

        bloc.add(const ExpandNode('1'));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleTreeLoaded;
        expect(loaded.expandedNodeIds.contains('1'), true);
      });
    });

    group('CollapseNode', () {
      test('removes node from expandedNodeIds', () async {
        when(() => mockGetArticleTree(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticles));

        bloc.add(const LoadArticleTree('proj-1'));
        await Future.delayed(Duration.zero);

        bloc.add(const ExpandNode('1'));
        await Future.delayed(Duration.zero);

        bloc.add(const CollapseNode('1'));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleTreeLoaded;
        expect(loaded.expandedNodeIds.contains('1'), false);
      });
    });
  });
}
