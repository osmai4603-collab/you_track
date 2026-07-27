# Implementation Plan: Knowledge Base

**Branch**: `009-knowledge-base` | **Date**: 2026-07-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/009-knowledge-base/spec.md`

## Summary

Build a hierarchical knowledge base feature for the YouTrack Flutter app. Users can browse, create, and edit Markdown articles organized in a tree structure with role-based visibility, inline comments on text selections, real-time @mention notifications, draft autosave, and a right-side table of contents for large screens. The backend is Supabase with RLS policies; the frontend follows the existing Clean Architecture pattern with flutter_bloc state management.

## Technical Context

**Language/Version**: Dart ^3.12.2 / Flutter (stable channel)

**Primary Dependencies**: flutter_bloc ^9.1.1, go_router ^17.3.0, get_it ^9.2.1, equatable ^2.1.0, fpdart ^1.2.0, supabase_flutter ^2.16.0

**Additional Dependencies (new)**:
- `flutter_markdown_plus` — Markdown rendering with selectable text and anchor support
- `fleather` — Rich text editor producing Delta/Markdown output
- `hive` + `hive_flutter` — Local draft persistence for offline autosave (FR-010)

**Storage**: Supabase (PostgreSQL) with 4 new tables: `articles`, `article_comments`, `article_drafts`, `article_notifications`. Local Hive box for offline draft queue.

**Testing**: flutter_test (unit + widget), mockito for mocking, integration tests for P1 user journeys

**Target Platform**: iOS, Android, Web, Desktop (Flutter multi-platform — existing project supports all)

**Project Type**: Mobile + Web application (Flutter)

**Performance Goals**: Article tree loads < 3s for 500 articles (SC-006); real-time notifications < 3s delivery (SC-005); inline comment creation < 5s (SC-007)

**Constraints**: Offline draft persistence required (FR-010); no file/image attachments in v1; no version history in v1

**Scale/Scope**: ~500 articles per project; ~50 concurrent users per project; 5 new Supabase tables; ~15 new Dart files across 3 layers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Feature-First Clean Architecture | ✅ PASS | New feature at `lib/features/knowledge_base/` with data/domain/presentation layers. Shared code in `lib/core/`. |
| II. Test-First Development (TDD) | ✅ PASS | Will write tests for all use cases, BLoC transitions, and widget interactions per TDD cycle. |
| III. Supabase Backend Governance | ✅ PASS | Migration files for all 4 tables. RLS policies for all access patterns. No raw SQL in app code. Realtime scoped to `article_notifications` table filtered by user. |
| IV. State Management Discipline | ✅ PASS | BLoC for complex article tree + editor workflows; Cubit for simple states (TOC scroll, search). Equatable for all state/event classes. |
| V. Simplicity & YAGNI | ✅ PASS | No version history, no file uploads, no advanced search — only what v1 spec requires. |
| VI. Routing & Navigation Governance | ✅ PASS | Route declared in `navigation_service.dart` under project shell. Deep link support via existing `projectKnowlageBasePath` (typo to be fixed). |

**Gate result**: All principles pass. No violations to justify.

## Project Structure

### Documentation (this feature)

```text
specs/009-knowledge-base/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── article-api.md   # Supabase table contract (RLS + query patterns)
├── checklists/
│   └── requirements.md  # Spec quality checklist
├── spec.md              # Feature specification
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_route_keys.dart          # Add knowledge_base route (fix typo)
│   ├── enums/
│   │   ├── article_status_enum.dart      # draft, published
│   │   └── article_visibility_enum.dart  # admins, developers, visitors
│   └── init_dependencies.dart            # Register knowledge_base feature
│
├── features/
│   └── knowledge_base/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── article_remote_datasource.dart
│       │   │   ├── article_local_datasource.dart   # Hive for offline drafts
│       │   │   ├── article_comment_remote_datasource.dart
│       │   │   └── article_notification_remote_datasource.dart
│       │   ├── models/
│       │   │   ├── article_model.dart
│       │   │   ├── article_comment_model.dart
│       │   │   └── article_notification_model.dart
│       │   └── repositories/
│       │       ├── article_repository_impl.dart
│       │       ├── article_comment_repository_impl.dart
│       │       └── article_notification_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── article.dart
│       │   │   ├── article_comment.dart
│       │   │   └── article_notification.dart
│       │   ├── repositories/
│       │   │   ├── article_repository.dart
│       │   │   ├── article_comment_repository.dart
│       │   │   └── article_notification_repository.dart
│       │   └── usecases/
│       │       ├── get_article_tree.dart
│       │       ├── get_article_by_id.dart
│       │       ├── create_article.dart
│       │       ├── update_article.dart
│       │       ├── publish_article.dart
│       │       ├── delete_article.dart
│       │       ├── reorder_articles.dart
│       │       ├── search_articles.dart
│       │       ├── save_draft.dart
│       │       ├── get_draft.dart
│       │       ├── add_comment.dart
│       │       ├── resolve_comment.dart
│       │       ├── delete_comment.dart
│       │       ├── get_comments_for_article.dart
│       │       └── subscribe_to_notifications.dart
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── article_tree_bloc.dart
│           │   ├── article_tree_event.dart
│           │   └── article_tree_state.dart
│           │   ├── article_editor_bloc.dart
│           │   ├── article_editor_event.dart
│           │   └── article_editor_state.dart
│           │   ├── article_comment_bloc.dart
│           │   ├── article_comment_event.dart
│           │   └── article_comment_state.dart
│           ├── cubits/
│           │   ├── article_toc_cubit.dart
│           │   ├── article_search_cubit.dart
│           │   └── article_notification_cubit.dart
│           ├── pages/
│           │   ├── knowledge_base_page.dart
│           │   └── article_editor_page.dart
│           └── widgets/
│               ├── article_tree_sidebar.dart
│               ├── article_content_viewer.dart
│               ├── article_toc_panel.dart
│               ├── article_editor_widget.dart
│               ├── article_comment_thread.dart
│               ├── article_inline_comment_anchor.dart
│               ├── article_empty_state.dart
│               ├── article_skeleton_loader.dart
│               └── article_notification_badge.dart
│
supabase/
└── migrations/
    ├── 20260726_create_articles_table.sql
    ├── 20260726_create_article_comments_table.sql
    ├── 20260726_create_article_drafts_table.sql
    └── 20260726_create_article_notifications_table.sql
```

**Structure Decision**: Single Flutter feature directory `lib/features/knowledge_base/` following the established Clean Architecture pattern. 4 new Supabase migration files. Feature registered in `init_dependencies.dart` alongside existing features.

## Complexity Tracking

No constitution violations. No complexity justifications needed.
