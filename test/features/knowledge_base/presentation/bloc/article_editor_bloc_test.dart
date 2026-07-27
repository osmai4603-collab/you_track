import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/create_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/update_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/publish_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/save_draft.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_draft.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_by_id.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_state.dart';

class MockCreateArticle extends Mock implements CreateArticle {}

class MockUpdateArticle extends Mock implements UpdateArticle {}

class MockPublishArticle extends Mock implements PublishArticle {}

class MockSaveDraft extends Mock implements SaveDraft {}

class MockGetDraft extends Mock implements GetDraft {}

class MockGetArticleById extends Mock implements GetArticleById {}

void main() {
  late ArticleEditorBloc bloc;
  late MockCreateArticle mockCreateArticle;
  late MockUpdateArticle mockUpdateArticle;
  late MockPublishArticle mockPublishArticle;
  late MockSaveDraft mockSaveDraft;
  late MockGetDraft mockGetDraft;
  late MockGetArticleById mockGetArticleById;

  setUpAll(() {
    registerFallbackValue(CreateArticleParams(article: Article(
      id: '',
      projectId: '',
      title: '',
      createdBy: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    )));
    registerFallbackValue(const GetArticleByIdParams(articleId: ''));
  });

  setUp(() {
    mockCreateArticle = MockCreateArticle();
    mockUpdateArticle = MockUpdateArticle();
    mockPublishArticle = MockPublishArticle();
    mockSaveDraft = MockSaveDraft();
    mockGetDraft = MockGetDraft();
    mockGetArticleById = MockGetArticleById();
    bloc = ArticleEditorBloc(
      createArticle: mockCreateArticle,
      updateArticle: mockUpdateArticle,
      publishArticle: mockPublishArticle,
      saveDraft: mockSaveDraft,
      getDraft: mockGetDraft,
      getArticleById: mockGetArticleById,
    );
  });

  tearDown(() => bloc.close());

  final now = DateTime.now();
  final testArticle = Article(
    id: '1',
    projectId: 'proj-1',
    title: 'Test Article',
    contentMarkdown: 'Content',
    status: 'draft',
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  group('ArticleEditorBloc', () {
    test('initial state is ArticleEditorInitial', () {
      expect(bloc.state, isA<ArticleEditorInitial>());
    });

    group('CreateNewArticle', () {
      test('emits [Loading, Loaded] on success', () async {
        when(() => mockCreateArticle(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticle));

        final states = <ArticleEditorState>[];
        bloc.stream.listen(states.add);

        bloc.add(CreateNewArticle(
          projectId: 'proj-1',
          createdBy: 'user-1',
        ));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleEditorLoading>());
        expect(states[1], isA<ArticleEditorLoaded>());
      });

      test('emits [Loading, Error] on failure', () async {
        when(() => mockCreateArticle(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const Left(ServerFailure('Error')));

        final states = <ArticleEditorState>[];
        bloc.stream.listen(states.add);

        bloc.add(CreateNewArticle(
          projectId: 'proj-1',
          createdBy: 'user-1',
        ));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleEditorLoading>());
        expect(states[1], isA<ArticleEditorError>());
      });
    });

    group('UpdateArticleTitle', () {
      test('updates title in loaded state', () async {
        when(() => mockCreateArticle(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticle));

        bloc.add(CreateNewArticle(
          projectId: 'proj-1',
          createdBy: 'user-1',
        ));
        await Future.delayed(Duration.zero);

        bloc.add(const UpdateArticleTitle('New Title'));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleEditorLoaded;
        expect(loaded.title, 'New Title');
        expect(loaded.isSaved, false);
      });
    });

    group('UpdateArticleContent', () {
      test('updates content in loaded state', () async {
        when(() => mockCreateArticle(
              params: any(named: 'params'),
            )).thenAnswer((_) async => Right(testArticle));

        bloc.add(CreateNewArticle(
          projectId: 'proj-1',
          createdBy: 'user-1',
        ));
        await Future.delayed(Duration.zero);

        bloc.add(const UpdateArticleContent('New content'));
        await Future.delayed(Duration.zero);

        final loaded = bloc.state as ArticleEditorLoaded;
        expect(loaded.content, 'New content');
        expect(loaded.isSaved, false);
      });
    });

    group('LoadDraft', () {
      test('emits [Loading, Loaded] with draft data', () async {
        when(() => mockGetDraft(articleId: '1')).thenAnswer(
          (_) async => {
            'title': 'Draft Title',
            'content': 'Draft content',
          },
        );

        final states = <ArticleEditorState>[];
        bloc.stream.listen(states.add);

        bloc.add(const LoadDraft('1'));
        await Future.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], isA<ArticleEditorLoading>());
        expect(states[1], isA<ArticleEditorLoaded>());

        final loaded = states[1] as ArticleEditorLoaded;
        expect(loaded.title, 'Draft Title');
        expect(loaded.content, 'Draft content');
      });
    });
  });
}
