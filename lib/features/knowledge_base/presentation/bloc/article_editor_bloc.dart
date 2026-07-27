import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/create_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/update_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/publish_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/save_draft.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_draft.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_by_id.dart';
import 'article_editor_event.dart';
import 'article_editor_state.dart';

class ArticleEditorBloc extends Bloc<ArticleEditorEvent, ArticleEditorState> {
  final CreateArticle createArticle;
  final UpdateArticle updateArticle;
  final PublishArticle publishArticle;
  final SaveDraft saveDraft;
  final GetDraft getDraft;
  final GetArticleById getArticleById;

  ArticleEditorBloc({
    CreateArticle? createArticle,
    UpdateArticle? updateArticle,
    PublishArticle? publishArticle,
    SaveDraft? saveDraft,
    GetDraft? getDraft,
    GetArticleById? getArticleById,
  })  : createArticle = createArticle ?? sl<CreateArticle>(),
        updateArticle = updateArticle ?? sl<UpdateArticle>(),
        publishArticle = publishArticle ?? sl<PublishArticle>(),
        saveDraft = saveDraft ?? sl<SaveDraft>(),
        getDraft = getDraft ?? sl<GetDraft>(),
        getArticleById = getArticleById ?? sl<GetArticleById>(),
        super(ArticleEditorInitial()) {
    on<CreateNewArticle>(_onCreateNewArticle);
    on<UpdateArticleTitle>(_onUpdateArticleTitle);
    on<UpdateArticleContent>(_onUpdateArticleContent);
    on<PublishCurrentArticle>(_onPublishCurrentArticle);
    on<AutosaveDraft>(_onAutosaveDraft);
    on<LoadDraft>(_onLoadDraft);
    on<LoadArticleForEdit>(_onLoadArticleForEdit);
  }

  Future<void> _onCreateNewArticle(
    CreateNewArticle event,
    Emitter<ArticleEditorState> emit,
  ) async {
    emit(ArticleEditorLoading());

    final now = DateTime.now();
    final article = Article(
      id: '',
      projectId: event.projectId,
      parentId: event.parentId,
      title: '',
      contentMarkdown: '',
      status: 'draft',
      createdBy: event.createdBy,
      createdAt: now,
      updatedAt: now,
    );

    final result = await createArticle(
      params: CreateArticleParams(article: article),
    );

    result.fold(
      (failure) => emit(ArticleEditorError(failure.message)),
      (created) => emit(ArticleEditorLoaded(article: created)),
    );
  }

  void _onUpdateArticleTitle(
    UpdateArticleTitle event,
    Emitter<ArticleEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is ArticleEditorLoaded) {
      emit(currentState.copyWith(title: event.title, isSaved: false));
    }
  }

  void _onUpdateArticleContent(
    UpdateArticleContent event,
    Emitter<ArticleEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is ArticleEditorLoaded) {
      emit(currentState.copyWith(content: event.content, isSaved: false));
    }
  }

  Future<void> _onPublishCurrentArticle(
    PublishCurrentArticle event,
    Emitter<ArticleEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is ArticleEditorLoaded) {
      if (currentState.article == null) return;

      emit(currentState.copyWith(isSaving: true));

      final updatedArticle = currentState.article!.copyWith(
        title: currentState.title,
        contentMarkdown: currentState.content,
        updatedAt: DateTime.now(),
      );

      final updateResult = await updateArticle(
        params: UpdateArticleParams(article: updatedArticle),
      );

      await updateResult.fold(
        (failure) async {
          emit(ArticleEditorError(failure.message));
        },
        (updated) async {
          final publishResult = await publishArticle(
            params: PublishArticleParams(articleId: updated.id),
          );

          publishResult.fold(
            (failure) => emit(ArticleEditorError(failure.message)),
            (_) => emit(currentState.copyWith(
              article: updated.copyWith(status: 'published'),
              isSaving: false,
              isSaved: true,
            )),
          );
        },
      );
    }
  }

  Future<void> _onAutosaveDraft(
    AutosaveDraft event,
    Emitter<ArticleEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is ArticleEditorLoaded && currentState.article != null) {
      emit(currentState.copyWith(isSaving: true));

      await saveDraft(
        articleId: currentState.article!.id,
        title: currentState.title,
        content: currentState.content,
      );

      emit(currentState.copyWith(isSaving: false, isSaved: true));
    }
  }

  Future<void> _onLoadDraft(
    LoadDraft event,
    Emitter<ArticleEditorState> emit,
  ) async {
    emit(ArticleEditorLoading());

    final draft = await getDraft(articleId: event.articleId);

    if (draft != null) {
      emit(ArticleEditorLoaded(
        title: draft['title'] as String? ?? '',
        content: draft['content'] as String? ?? '',
      ));
    } else {
      emit(ArticleEditorLoaded());
    }
  }

  Future<void> _onLoadArticleForEdit(
    LoadArticleForEdit event,
    Emitter<ArticleEditorState> emit,
  ) async {
    emit(ArticleEditorLoading());

    final result = await getArticleById(
      params: GetArticleByIdParams(articleId: event.articleId),
    );

    result.fold(
      (failure) => emit(ArticleEditorError(failure.message)),
      (article) => emit(ArticleEditorLoaded(
        article: article,
        title: article.title,
        content: article.contentMarkdown,
      )),
    );
  }
}
