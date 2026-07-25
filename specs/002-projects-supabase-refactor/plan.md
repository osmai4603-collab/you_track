# Implementation Plan: Projects Supabase Refactor

**Branch**: `002-projects-supabase-refactor` | **Date**: 2026-07-25 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-projects-supabase-refactor/spec.md`

## Summary

Refactor the projects feature so that every data display (projects list, project members, project templates, project details) fetches from Supabase instead of hardcoded/mock data. The existing Clean Architecture skeleton (entities, models, repositories, use cases, cubits, pages) is preserved. The data source layer is replaced: a new `ProjectsRemoteDataSource` backed by `SupabaseClient` replaces the in-memory `ProjectsLocalDataSource`, models are updated for snake_case serialization, and the `ProjectView` page's inline mock data is removed in favor of repository-driven data.

## Technical Context

**Language/Version**: Dart 3.x (Flutter SDK)

**Primary Dependencies**: flutter_bloc 9.1.1, get_it 9.2.1, supabase_flutter 2.16.0, fpdart 1.2.0, go_router 17.3.0, equatable 2.1.0

**Storage**: Supabase (PostgreSQL via Supabase Flutter client)

**Testing**: Flutter widget tests (test/ directory exists, no specific framework configured beyond flutter_test)

**Target Platform**: Cross-platform (Android, iOS, Linux, macOS, Web, Windows)

**Project Type**: Mobile + Web application (Flutter)

**Performance Goals**: CRUD operations reflected in Supabase within 2 seconds (SC-003); list page loads under 1 second

**Constraints**: Must preserve existing Clean Architecture structure; must not break existing navigation or state management; must handle offline/error states gracefully without fallback to hardcoded data

**Scale/Scope**: Single feature refactoring affecting ~15 files across data, domain, and presentation layers; 3 Supabase tables (projects, project_members, project_templates)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No constitution file exists (`.specify/memory/constitution.md` not found). No governance constraints to evaluate. Gate passes by default.

## Project Structure

### Documentation (this feature)

```text
specs/002-projects-supabase-refactor/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── init_dependencies.dart          # MODIFY: wire SupabaseClient into projects
│   └── errors/failure.dart             # Already has ServerFailure
├── features/
│   └── projects/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── projects_local_data_source.dart   # KEEP (optional cache)
│       │   │   └── projects_remote_data_source.dart  # CREATE: Supabase data source
│       │   ├── models/
│       │   │   ├── project_model.dart                 # MODIFY: add fromJson/toJson with snake_case
│       │   │   ├── project_member_model.dart          # MODIFY: add fromJson/toJson with snake_case
│       │   │   └── project_template_model.dart        # MODIFY: add fromJson/toJson with snake_case
│       │   └── repositories/
│       │       └── projects_repository_impl.dart      # MODIFY: use remote data source
│       └── presentation/
│           └── pages/
│               └── project_view_page.dart             # MODIFY: remove _initMockData(), use cubit
```

**Structure Decision**: Existing Clean Architecture structure is preserved. Only the data source layer changes: a new remote data source is added, models gain Supabase-compatible serialization, and the repository implementation switches to the remote source. The `ProjectView` page is cleaned up to remove inline mock data.

## Complexity Tracking

No constitution violations to justify.
