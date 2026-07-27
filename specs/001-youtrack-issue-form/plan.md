# Implementation Plan: YouTrack Issue Form Rebuild

**Branch**: `001-youtrack-issue-form` | **Date**: 2026-07-27 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-youtrack-issue-form/spec.md`

## Summary

Rebuild the issue creation/editing form (`issue_form.dart`) to deliver a full YouTrack-inspired UI with a rich text editor (Fleather-based WYSIWYG + Markdown toggle), file attachment zone via Supabase Storage, a right sidebar with 10 property fields, and action controls. A new `IssueFormCubit` manages form state, and the Issue entity gains a `visibility` field for group-based access control.

## Technical Context

**Language/Version**: Dart ^3.12.2 / Flutter (latest stable)

**Primary Dependencies**: flutter_bloc ^9.1.1, fleather ^1.0.0, supabase_flutter ^2.16.0, get_it ^9.2.1, go_router ^17.3.0, fpdart ^1.2.0, equatable ^2.1.0

**Storage**: Supabase (PostgreSQL + Storage)

**Testing**: flutter_test, mocktail ^1.0.4

**Target Platform**: Cross-platform (Android, iOS, Web, Desktop)

**Project Type**: Mobile + Web application (Flutter)

**Performance Goals**: Form loads in <500ms; rich text editor renders at 60fps; file upload shows real-time progress

**Constraints**: Must follow YouTrack constitution (Clean Architecture, TDD, Supabase governance, BLoC state management, go_router navigation)

**Scale/Scope**: Single form page, ~10 sidebar fields, 14 formatting toolbar operations, 10 max attachments per issue

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Feature-First Clean Architecture | ✅ PASS | Form lives in `lib/features/issues/presentation/`; new cubit in `cubits/`; repository/data source extensions in existing feature layers |
| II. Test-First Development (TDD) | ✅ PASS | IssueFormCubit tests, widget tests for form, integration tests for create/edit flows planned |
| III. Supabase Backend Governance | ✅ PASS | Migration for `visibility` field documented; RLS policies required; no raw SQL |
| IV. State Management Discipline | ✅ PASS | `IssueFormCubit` (simple form state) in `presentation/cubits/`; uses Equatable |
| V. Simplicity & YAGNI | ✅ PASS | Reuses existing Fleather pattern from knowledge_base; extends existing issues feature; no new features created |
| VI. Routing & Navigation Governance | ✅ PASS | Route already exists at `/issues/new-issue` in navigation_service.dart; edit route to be added |

**Gate Result**: ALL PASS — proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/001-youtrack-issue-form/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/features/issues/
├── data/
│   ├── datasources/
│   │   ├── issues_remote_data_source.dart       # EXTEND: add createIssue, updateIssue, deleteIssue, uploadAttachment
│   │   └── issues_mock_data_source.dart         # EXTEND: mock implementations
│   ├── models/
│   │   └── issue_model.dart                     # EXTEND: add visibility field, fromJson/toJson
│   └── repositories/
│       └── issues_repository_impl.dart          # EXTEND: add create/update/delete/upload methods
├── domain/
│   ├── entities/
│   │   ├── issue.dart                           # EXTEND: add visibility field
│   │   └── issue_priority.dart                  # EXISTING (no change)
│   ├── repositories/
│   │   └── issues_repository.dart               # EXTEND: add create/update/delete/upload contracts
│   └── usecases/
│       ├── create_issue.dart                    # NEW
│       ├── update_issue.dart                    # NEW
│       ├── delete_issue.dart                    # NEW
│       └── upload_attachment.dart               # NEW
├── presentation/
│   ├── cubits/
│   │   └── issue_form_cubit.dart                # NEW: form state management
│   │   └── issue_form_state.dart                # NEW: form state class
│   ├── pages/
│   │   └── issue_form.dart                      # REBUILD: full YouTrack-style form
│   └── widgets/
│       ├── issue_form_toolbar.dart               # NEW: rich text toolbar
│       ├── issue_form_sidebar.dart               # NEW: properties sidebar
│       ├── issue_form_attachment_zone.dart        # NEW: file drop zone
│       ├── issue_form_action_bar.dart             # NEW: create/cancel/delete buttons
│       ├── issue_visibility_picker.dart           # NEW: visibility group selector
│       └── issue_form_top_bar.dart                # NEW: summary input + quick actions

supabase/migrations/
└── 20260727000000_add_issue_visibility.sql        # NEW: add visibility column + RLS

test/features/issues/
├── presentation/
│   ├── cubits/
│   │   └── issue_form_cubit_test.dart            # NEW
│   └── widgets/
│       └── issue_form_test.dart                   # NEW
└── domain/usecases/
    ├── create_issue_test.dart                     # NEW
    ├── update_issue_test.dart                     # NEW
    ├── delete_issue_test.dart                     # NEW
    └── upload_attachment_test.dart                # NEW
```

**Structure Decision**: Extends the existing `issues` feature (Principle I: no duplicate features). All new code follows the established Clean Architecture layering. The `IssueFormCubit` uses the Cubit pattern (Principle IV: simple form state). Files are kept under 300 lines (Principle V).

## Complexity Tracking

> No constitution violations requiring justification.
