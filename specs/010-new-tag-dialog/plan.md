# Implementation Plan: New Tag Dialog

**Branch**: `010-new-tag-dialog` | **Date**: 2026-07-26 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/010-new-tag-dialog/spec.md`

## Summary

Build a modal dialog for creating new tags within the issues feature. The dialog collects tag name, permissions, options (Shared, Remove on resolution, Favorite), and notification subscriptions, then creates the tag and associates it with the current issue. Follows existing Cubit + Clean Architecture patterns.

## Technical Context

**Language/Version**: Dart 3.12.2, Flutter (latest stable)

**Primary Dependencies**: flutter_bloc (Cubit), equatable, get_it, supabase_flutter, fpdart

**Storage**: Supabase (PostgreSQL) — tag data persisted via Supabase client

**Testing**: flutter_test (widget tests), mocktail (mocking)

**Target Platform**: Cross-platform (iOS, Android, Web, Desktop) — Flutter app

**Project Type**: Mobile + Web application (Flutter)

**Performance Goals**: Dialog renders within 500ms, tag creation completes within 2s

**Constraints**: Must follow existing Clean Architecture (data/domain/presentation), use Cubit pattern, integrate with existing issue form sidebar

**Scale/Scope**: Single dialog widget + supporting cubit/repository/usecase layers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No constitution.md file found — project-level governance constraints not defined. Proceeding without gate violations.

## Project Structure

### Documentation (this feature)

```text
specs/010-new-tag-dialog/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── issues/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── tag_remote_datasource.dart        # NEW
│       │   ├── models/
│       │   │   └── tag_model.dart                    # NEW
│       │   └── repositories/
│       │       └── tags_repository_impl.dart         # NEW
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── tag.dart                          # NEW
│       │   │   ├── tag_permission.dart               # NEW
│       │   │   ├── tag_subscription.dart             # NEW
│       │   │   └── project_member.dart               # NEW
│       │   ├── repositories/
│       │   │   └── tags_repository.dart              # NEW
│       │   └── usecases/
│       │       ├── create_tag.dart                   # NEW
│       │       ├── get_project_members.dart          # NEW
│       │       ├── is_tag_name_unique.dart           # NEW
│       │       └── associate_tag_with_issue.dart     # NEW
│       └── presentation/
│           ├── cubits/
│           │   ├── new_tag_cubit.dart                # NEW
│           │   └── new_tag_state.dart                # NEW
│           └── widgets/
│               ├── new_tag_dialog.dart               # NEW
│               ├── new_tag_form.dart                 # NEW
│               ├── tag_permissions_section.dart       # NEW
│               ├── tag_subscriptions_section.dart     # NEW
│               └── specific_users_picker.dart         # NEW
├── core/
│   ├── enums/
│   │   ├── tag_permission_scope_enum.dart            # NEW
│   │   ├── tag_permission_type_enum.dart             # NEW
│   │   └── tag_subscription_event_enum.dart          # NEW
│   └── widgets/
│       └── skeleton_shimmer.dart                     # NEW
```

**Structure Decision**: Following existing feature-based Clean Architecture pattern. New tag functionality lives under `features/issues/` since tags are part of the issues domain. Presentation uses Cubit pattern consistent with `IssueFormCubit`.

## Complexity Tracking

No constitution violations to justify.

## Generated Artifacts

- `research.md` — Phase 0: Technical decisions and best practices
- `data-model.md` — Phase 1: Entity definitions and relationships
- `contracts/` — Phase 1: Interface contracts
- `quickstart.md` — Phase 1: Validation guide
