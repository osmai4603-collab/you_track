# Tasks: Knowledge Base

**Input**: Design documents from `/specs/009-knowledge-base/`

**Prerequisites**: plan.md, spec.md, data-model.md, contracts/article-api.md, research.md, quickstart.md

**Tests**: The constitution mandates TDD (Principle II). Test tasks are included for all domain use cases, BLoC state transitions, and P1 user journeys.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, dependencies, database schema, core enums, and DI registration

- [X] T001 Add new dependencies to `pubspec.yaml`: `flutter_markdown_plus`, `fleather`, `hive`, `hive_flutter`
- [X] T002 [P] Create Supabase migration `supabase/migrations/20260726_create_articles_table.sql` with RLS policies per `contracts/article-api.md`
- [X] T003 [P] Create Supabase migration `supabase/migrations/20260726_create_article_comments_table.sql` with RLS policies per `contracts/article-api.md`
- [X] T004 [P] Create Supabase migration `supabase/migrations/20260726_create_article_notifications_table.sql` with RLS policies and mention notification trigger per `contracts/article-api.md`
- [X] T005 [P] Create enums `lib/core/enums/article_status_enum.dart` (draft, published) and `lib/core/enums/article_visibility_enum.dart` (admin, developer, visitor)
- [X] T006 [P] Fix route typo in `lib/core/constants/app_route_keys.dart`: rename `projectKnowlageBasePath` to `projectKnowledgeBasePath` and update all references
- [X] T007 Register knowledge_base feature in `lib/core/init_dependencies.dart` with `_initKnowledgeBaseFeature()` (data sources, repositories, use cases, BLoCs, Cubits)
- [X] T008 Initialize Hive and register `article_drafts` box in `main.dart` before `runApp()`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core entities, repository interfaces, data sources, and models that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T009 [P] Create Article entity `lib/features/knowledge_base/domain/entities/article.dart` extending `Entity` with Equatable
- [X] T010 [P] Create ArticleComment entity `lib/features/knowledge_base/domain/entities/article_comment.dart` extending `Entity` with Equatable
- [X] T011 [P] Create ArticleNotification entity `lib/features/knowledge_base/domain/entities/article_notification.dart` extending `Entity` with Equatable
- [X] T012 [P] Create ArticleModel `lib/features/knowledge_base/data/models/article_model.dart` with `fromJson`/`toJson` and `toEntity`/`fromEntity`
- [X] T013 [P] Create ArticleCommentModel `lib/features/knowledge_base/data/models/article_comment_model.dart` with `fromJson`/`toJson` and `toEntity`/`fromEntity`
- [X] T014 [P] Create ArticleNotificationModel `lib/features/knowledge_base/data/models/article_notification_model.dart` with `fromJson`/`toJson` and `toEntity`/`fromEntity`
- [X] T015 Create ArticleRepository interface `lib/features/knowledge_base/domain/repositories/article_repository.dart` with methods: getArticleTree, getArticleById, createArticle, updateArticle, publishArticle, deleteArticle, reorderArticles, searchArticles
- [X] T016 Create ArticleCommentRepository interface `lib/features/knowledge_base/domain/repositories/article_comment_repository.dart` with methods: getComments, addComment, resolveComment, deleteComment
- [X] T017 Create ArticleNotificationRepository interface `lib/features/knowledge_base/domain/repositories/article_notification_repository.dart` with methods: getUnreadNotifications, markAsRead, subscribeToNewNotifications
- [X] T018 Create ArticleRemoteDataSource `lib/features/knowledge_base/data/datasources/article_remote_datasource.dart` implementing Supabase CRUD per `contracts/article-api.md`
- [X] T019 Create ArticleLocalDataSource `lib/features/knowledge_base/data/datasources/article_local_datasource.dart` implementing Hive draft persistence (save, get, delete, getAllUnsynced)
- [X] T020 Create ArticleCommentRemoteDataSource `lib/features/knowledge_base/data/datasources/article_comment_remote_datasource.dart` implementing Supabase queries per `contracts/article-api.md`
- [X] T021 Create ArticleNotificationRemoteDataSource `lib/features/knowledge_base/data/datasources/article_notification_remote_datasource.dart` implementing Supabase queries and Realtime subscription per `contracts/article-api.md`
- [X] T022 Create ArticleRepositoryImpl `lib/features/knowledge_base/data/repositories/article_repository_impl.dart` wrapping data sources with try/catch and `Either<Failure, T>`
- [X] T023 Create ArticleCommentRepositoryImpl `lib/features/knowledge_base/data/repositories/article_comment_repository_impl.dart` wrapping data source with try/catch and `Either<Failure, T>`
- [X] T024 Create ArticleNotificationRepositoryImpl `lib/features/knowledge_base/data/repositories/article_notification_repository_impl.dart` wrapping data source with try/catch and `Either<Failure, T>`
- [X] T025 Write unit tests for all 3 repository implementations `test/features/knowledge_base/data/repositories/`
- [X] T026 Add knowledge_base route to `lib/core/services/navigation_service.dart` as nested route under project shell with deep link support

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Browse and Read Articles (Priority: P1) 🎯 MVP

**Goal**: Users can browse a collapsible article tree in a sidebar and read any permitted article's rendered Markdown content with a right-side table of contents.

**Independent Test**: Open knowledge base page → tree loads → click article → Markdown renders → TOC shows headings on wide screen.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T027 [P] [US1] Write failing unit test for GetArticleTree use case `test/features/knowledge_base/domain/usecases/get_article_tree_test.dart`
- [X] T028 [P] [US1] Write failing unit test for GetArticleById use case `test/features/knowledge_base/domain/usecases/get_article_by_id_test.dart`
- [X] T029 [P] [US1] Write failing BLoC test for ArticleTreeBloc (LoadTree, SelectArticle, ExpandNode, CollapseNode) `test/features/knowledge_base/presentation/bloc/article_tree_bloc_test.dart`
- [X] T030 [P] [US1] Write failing Cubit test for ArticleTocCubit (ExtractHeadings, ScrollToHeading) `test/features/knowledge_base/presentation/cubits/article_toc_cubit_test.dart`

### Implementation for User Story 1

- [ ] T031 [P] [US1] Create GetArticleTree use case `lib/features/knowledge_base/domain/usecases/get_article_tree.dart`
- [ ] T032 [P] [US1] Create GetArticleById use case `lib/features/knowledge_base/domain/usecases/get_article_by_id.dart`
- [ ] T033 [US1] Create ArticleTreeEvent classes `lib/features/knowledge_base/presentation/bloc/article_tree_event.dart` (LoadTree, SelectArticle, ExpandNode, CollapseNode, ReorderArticles)
- [ ] T034 [US1] Create ArticleTreeState classes `lib/features/knowledge_base/presentation/bloc/article_tree_state.dart` (Loading, Loaded, Error, with tree nodes and selected article)
- [ ] T035 [US1] Create ArticleTreeBloc `lib/features/knowledge_base/presentation/bloc/article_tree_bloc.dart` implementing event handlers
- [ ] T036 [US1] Create ArticleTocCubit `lib/features/knowledge_base/presentation/cubits/article_toc_cubit.dart` for heading extraction and scroll navigation
- [ ] T037 [US1] Create ArticleTreeSidebar widget `lib/features/knowledge_base/presentation/widgets/article_tree_sidebar.dart` with animated expand/collapse tree nodes
- [ ] T038 [US1] Create ArticleContentViewer widget `lib/features/knowledge_base/presentation/widgets/article_content_viewer.dart` using `flutter_markdown_plus` with selectable text
- [ ] T039 [US1] Create ArticleTocPanel widget `lib/features/knowledge_base/presentation/widgets/article_toc_panel.dart` showing headings list with click-to-scroll (hidden on < 1024px)
- [ ] T040 [US1] Create ArticleSkeletonLoader widget `lib/features/knowledge_base/presentation/widgets/article_skeleton_loader.dart` for loading state
- [ ] T041 [US1] Create ArticleEmptyState widget `lib/features/knowledge_base/presentation/widgets/article_empty_state.dart` with role-aware CTA
- [ ] T042 [US1] Create KnowledgeBasePage `lib/features/knowledge_base/presentation/pages/knowledge_base_page.dart` composing sidebar + content + TOC in a Row
- [ ] T043 [US1] Wire up knowledge_base route to KnowledgeBasePage in navigation_service.dart with MultiBlocProvider
- [ ] T044 [US1] Run all US1 tests and verify they pass

**Checkpoint**: Users can browse and read articles with tree navigation and TOC

---

## Phase 4: User Story 2 - Create and Edit Articles (Priority: P1) 🎯 MVP

**Goal**: Admins and developers can create new articles, edit them with a rich text editor, autosave drafts, and publish articles.

**Independent Test**: Click "+ New Article" → editor opens → type and format → autosave fires → publish → article appears in tree.

### Tests for User Story 2

- [X] T045 [P] [US2] Write failing unit test for CreateArticle use case `test/features/knowledge_base/domain/usecases/create_article_test.dart`
- [X] T046 [P] [US2] Write failing unit test for UpdateArticle use case `test/features/knowledge_base/domain/usecases/update_article_test.dart`
- [X] T047 [P] [US2] Write failing unit test for PublishArticle use case `test/features/knowledge_base/domain/usecases/publish_article_test.dart`
- [X] T048 [P] [US2] Write failing unit test for SaveDraft use case `test/features/knowledge_base/domain/usecases/save_draft_test.dart`
- [X] T049 [P] [US2] Write failing unit test for GetDraft use case `test/features/knowledge_base/domain/usecases/get_draft_test.dart`
- [X] T050 [P] [US2] Write failing BLoC test for ArticleEditorBloc (CreateArticle, UpdateContent, UpdateTitle, PublishArticle, Autosave) `test/features/knowledge_base/presentation/bloc/article_editor_bloc_test.dart`

### Implementation for User Story 2

- [ ] T051 [P] [US2] Create CreateArticle use case `lib/features/knowledge_base/domain/usecases/create_article.dart`
- [ ] T052 [P] [US2] Create UpdateArticle use case `lib/features/knowledge_base/domain/usecases/update_article.dart`
- [ ] T053 [P] [US2] Create PublishArticle use case `lib/features/knowledge_base/domain/usecases/publish_article.dart`
- [ ] T054 [P] [US2] Create SaveDraft use case `lib/features/knowledge_base/domain/usecases/save_draft.dart`
- [ ] T055 [P] [US2] Create GetDraft use case `lib/features/knowledge_base/domain/usecases/get_draft.dart`
- [ ] T056 [US2] Create ArticleEditorEvent classes `lib/features/knowledge_base/presentation/bloc/article_editor_event.dart`
- [ ] T057 [US2] Create ArticleEditorState classes `lib/features/knowledge_base/presentation/bloc/article_editor_state.dart`
- [ ] T058 [US2] Create ArticleEditorBloc `lib/features/knowledge_base/presentation/bloc/article_editor_bloc.dart` with autosave timer (5s periodic)
- [ ] T059 [US2] Create ArticleEditorWidget `lib/features/knowledge_base/presentation/widgets/article_editor_widget.dart` using `fleather` editor with formatting toolbar
- [ ] T060 [US2] Create ArticleEditorPage `lib/features/knowledge_base/presentation/pages/article_editor_page.dart` with title input, editor, visibility selector, and publish button
- [ ] T061 [US2] Wire up editor route to ArticleEditorPage in navigation_service.dart
- [ ] T062 [US2] Connect "+ New Article" button in project header to navigate to editor
- [ ] T063 [US2] Run all US2 tests and verify they pass

**Checkpoint**: Content creation and editing fully functional with autosave

---

## Phase 5: User Story 3 - Organize Articles in a Hierarchy (Priority: P2)

**Goal**: Admins and developers can nest articles under parents and reorder them within the tree.

**Independent Test**: Create article with parent → appears nested → drag to reorder → order persists.

### Tests for User Story 3

- [X] T064 [P] [US3] Write failing unit test for ReorderArticles use case `test/features/knowledge_base/domain/usecases/reorder_articles_test.dart`
- [X] T065 [P] [US3] Write failing unit test for DeleteArticle use case (re-parenting logic) `test/features/knowledge_base/domain/usecases/delete_article_test.dart`
- [X] T066 [P] [US3] Write failing BLoC test for ArticleTreeBloc reorder events `test/features/knowledge_base/presentation/bloc/article_tree_bloc_test.dart`

### Implementation for User Story 3

- [ ] T067 [P] [US3] Create ReorderArticles use case `lib/features/knowledge_base/domain/usecases/reorder_articles.dart`
- [ ] T068 [P] [US3] Create DeleteArticle use case `lib/features/knowledge_base/domain/usecases/delete_article.dart` with re-parenting logic (re-parent children to grandparent)
- [ ] T069 [US3] Add parent article selector dropdown to ArticleEditorPage `lib/features/knowledge_base/presentation/pages/article_editor_page.dart`
- [ ] T070 [US3] Add drag-and-drop reordering to ArticleTreeSidebar `lib/features/knowledge_base/presentation/widgets/article_tree_sidebar.dart` within same parent level
- [ ] T071 [US3] Add delete article action with re-parent confirmation dialog to ArticleTreeSidebar
- [ ] T072 [US3] Run all US3 tests and verify they pass

**Checkpoint**: Article hierarchy management fully functional

---

## Phase 6: User Story 4 - Add Inline Comments (Priority: P2)

**Goal**: Users can select text in an article, add anchored comments, view comment threads, resolve and delete comments.

**Independent Test**: Select text → add comment → comment appears anchored → resolve → comment dims → delete → comment removed.

### Tests for User Story 4

- [X] T073 [P] [US4] Write failing unit test for AddComment use case `test/features/knowledge_base/domain/usecases/add_comment_test.dart`
- [X] T074 [P] [US4] Write failing unit test for ResolveComment use case `test/features/knowledge_base/domain/usecases/resolve_comment_test.dart`
- [X] T075 [P] [US4] Write failing unit test for DeleteComment use case `test/features/knowledge_base/domain/usecases/delete_comment_test.dart`
- [X] T076 [P] [US4] Write failing unit test for GetCommentsForArticle use case `test/features/knowledge_base/domain/usecases/get_comments_for_article_test.dart`
- [X] T077 [P] [US4] Write failing BLoC test for ArticleCommentBloc (LoadComments, AddComment, ResolveComment, DeleteComment) `test/features/knowledge_base/presentation/bloc/article_comment_bloc_test.dart`

### Implementation for User Story 4

- [ ] T078 [P] [US4] Create AddComment use case `lib/features/knowledge_base/domain/usecases/add_comment.dart`
- [ ] T079 [P] [US4] Create ResolveComment use case `lib/features/knowledge_base/domain/usecases/resolve_comment.dart`
- [ ] T080 [P] [US4] Create DeleteComment use case `lib/features/knowledge_base/domain/usecases/delete_comment.dart`
- [ ] T081 [P] [US4] Create GetCommentsForArticle use case `lib/features/knowledge_base/domain/usecases/get_comments_for_article.dart`
- [ ] T082 [US4] Create ArticleCommentEvent classes `lib/features/knowledge_base/presentation/bloc/article_comment_event.dart`
- [ ] T083 [US4] Create ArticleCommentState classes `lib/features/knowledge_base/presentation/bloc/article_comment_state.dart`
- [ ] T084 [US4] Create ArticleCommentBloc `lib/features/knowledge_base/presentation/bloc/article_comment_bloc.dart`
- [ ] T085 [US4] Create ArticleInlineCommentAnchor widget `lib/features/knowledge_base/presentation/widgets/article_inline_comment_anchor.dart` for highlighting anchored text and showing comment indicator
- [ ] T086 [US4] Create ArticleCommentThread widget `lib/features/knowledge_base/presentation/widgets/article_comment_thread.dart` with comment list, add/resolve/delete actions
- [ ] T087 [US4] Integrate inline comment anchoring into ArticleContentViewer `lib/features/knowledge_base/presentation/widgets/article_content_viewer.dart` (text selection → context menu → add comment)
- [ ] T088 [US4] Run all US4 tests and verify they pass

**Checkpoint**: Inline commenting system fully functional

---

## Phase 7: User Story 5 - Real-time Notifications (Priority: P3)

**Goal**: Users receive real-time notifications when mentioned via @username in comments, with notification badge and click-to-navigate.

**Independent Test**: Post comment with @mention → recipient sees notification within 3s → click navigates to article and scrolls to comment.

### Tests for User Story 5

- [X] T089 [P] [US5] Write failing unit test for SubscribeToNotifications use case `test/features/knowledge_base/domain/usecases/subscribe_to_notifications_test.dart`
- [X] T090 [P] [US5] Write failing Cubit test for ArticleNotificationCubit (ReceiveNotification, MarkAsRead, LoadUnread) `test/features/knowledge_base/presentation/cubits/article_notification_cubit_test.dart`

### Implementation for User Story 5

- [ ] T091 [P] [US5] Create SubscribeToNotifications use case `lib/features/knowledge_base/domain/usecases/subscribe_to_notifications.dart`
- [ ] T092 [US5] Create ArticleNotificationCubit `lib/features/knowledge_base/presentation/cubits/article_notification_cubit.dart` managing unread count and notification list
- [ ] T093 [US5] Create ArticleNotificationBadge widget `lib/features/knowledge_base/presentation/widgets/article_notification_badge.dart` showing unread count indicator
- [ ] T094 [US5] Integrate notification badge into KnowledgeBasePage header `lib/features/knowledge_base/presentation/pages/knowledge_base_page.dart`
- [ ] T095 [US5] Add notification tap → navigate to article → scroll to comment logic in KnowledgeBasePage
- [ ] T096 [US5] Wire Supabase Realtime subscription in ArticleNotificationRemoteDataSource to filter by `recipient_id`
- [ ] T097 [US5] Run all US5 tests and verify they pass

**Checkpoint**: Real-time notification system fully functional

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Search, performance, accessibility, and final validation

- [ ] T098 [P] Create SearchArticles use case `lib/features/knowledge_base/domain/usecases/search_articles.dart`
- [ ] T099 [P] Create ArticleSearchCubit `lib/features/knowledge_base/presentation/cubits/article_search_cubit.dart` with debounced search
- [ ] T100 Add search bar to KnowledgeBasePage header `lib/features/knowledge_base/presentation/pages/knowledge_base_page.dart`
- [ ] T101 Write failing widget tests for KnowledgeBasePage `test/features/knowledge_base/presentation/pages/knowledge_base_page_test.dart`
- [ ] T102 Write failing widget tests for ArticleEditorPage `test/features/knowledge_base/presentation/pages/article_editor_page_test.dart`
- [X] T103 Run `flutter analyze lib/features/knowledge_base/` and fix all issues
- [ ] T104 Run full test suite `flutter test test/features/knowledge_base/` and verify all pass
- [ ] T105 Run quickstart.md validation scenarios V1-V8 manually
- [ ] T106 Verify article tree loads < 3s for 500 articles (SC-006)
- [ ] T107 Verify all user-facing strings use `intl` l10n system (constitution compliance)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies - can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 completion - BLOCKS all user stories
- **Phases 3-7 (User Stories)**: All depend on Phase 2 completion
  - US1 and US2 (both P1) can run in parallel after Phase 2
  - US3 depends on US1 (tree widget) and US2 (editor for parent selector)
  - US4 depends on US1 (content viewer for text selection)
  - US5 depends on US4 (notifications triggered by comments)
- **Phase 8 (Polish)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 - No dependencies on other stories
- **US2 (P1)**: Can start after Phase 2 - No dependencies on other stories
- **US3 (P2)**: Depends on US1 (tree sidebar widget) and US2 (editor page for parent selector)
- **US4 (P2)**: Depends on US1 (content viewer for text selection integration)
- **US5 (P3)**: Depends on US4 (comment submission triggers notification)

### Within Each User Story

- Tests written and FAILING before implementation
- Entities/Models before use cases
- Use cases before BLoC/Cubit
- BLoC/Cubit before widgets
- Widgets before pages
- Pages before route wiring
- All tests PASS at checkpoint

### Parallel Opportunities

- Phase 1: T002, T003, T004, T005, T006 can all run in parallel (different files)
- Phase 2: T009-T014 (entities and models) can all run in parallel; T018-T021 (data sources) can all run in parallel
- Phase 3: T027-T030 (tests) can run in parallel; T031-T032 (use cases) can run in parallel
- Phase 4: T045-T050 (tests) can run in parallel; T051-T055 (use cases) can run in parallel
- Phases 3 and 4 (US1 and US2) can run in parallel after Phase 2
- Phase 5: T064-T066 (tests) can run in parallel; T067-T068 (use cases) can run in parallel
- Phase 6: T073-T077 (tests) can run in parallel; T078-T081 (use cases) can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all tests for US1 together:
Task: "Write failing unit test for GetArticleTree use case in test/features/knowledge_base/domain/usecases/get_article_tree_test.dart"
Task: "Write failing unit test for GetArticleById use case in test/features/knowledge_base/domain/usecases/get_article_by_id_test.dart"
Task: "Write failing BLoC test for ArticleTreeBloc in test/features/knowledge_base/presentation/bloc/article_tree_bloc_test.dart"
Task: "Write failing Cubit test for ArticleTocCubit in test/features/knowledge_base/presentation/cubits/article_toc_cubit_test.dart"

# Launch all use cases together:
Task: "Create GetArticleTree use case in lib/features/knowledge_base/domain/usecases/get_article_tree.dart"
Task: "Create GetArticleById use case in lib/features/knowledge_base/domain/usecases/get_article_by_id.dart"

# Launch all widgets together (after BLoC):
Task: "Create ArticleTreeSidebar widget in lib/features/knowledge_base/presentation/widgets/article_tree_sidebar.dart"
Task: "Create ArticleContentViewer widget in lib/features/knowledge_base/presentation/widgets/article_content_viewer.dart"
Task: "Create ArticleTocPanel widget in lib/features/knowledge_base/presentation/widgets/article_toc_panel.dart"
```

---

## Implementation Strategy

### MVP First (User Stories 1 + 2)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (Browse & Read) + Phase 4: User Story 2 (Create & Edit)
4. **STOP and VALIDATE**: Users can browse tree, read articles, create new articles, edit and publish
5. Deploy/demo if ready

### Incremental Delivery

1. Phase 1 + Phase 2 → Foundation ready
2. US1 + US2 → Test independently → Deploy/Demo (MVP!)
3. US3 → Hierarchy organization → Deploy/Demo
4. US4 → Inline comments → Deploy/Demo
5. US5 → Real-time notifications → Deploy/Demo
6. Phase 8 → Polish → Final release

### Parallel Team Strategy

With multiple developers:

1. Team completes Phase 1 + Phase 2 together
2. Once Phase 2 is done:
   - Developer A: US1 (Browse & Read) + US3 (Hierarchy)
   - Developer B: US2 (Create & Edit)
   - Developer C: US4 (Inline Comments) + US5 (Notifications)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Constitution Principle II (TDD) requires tests before implementation for use cases, BLoC transitions, and widget interactions
- Constitution Principle I requires all code in `lib/features/knowledge_base/` with data/domain/presentation layers
- Constitution Principle III requires Supabase migrations for all schema changes
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Total tasks: 107 (8 setup + 18 foundational + 18 US1 + 19 US2 + 9 US3 + 16 US4 + 9 US7 + 10 polish)
