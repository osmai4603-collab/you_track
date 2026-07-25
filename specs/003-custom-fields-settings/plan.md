# Implementation Plan: Custom Fields Settings

**Branch**: `003-custom-fields-settings` | **Date**: 2026-07-25 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/003-custom-fields-settings/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Add a Custom Fields management page within the project settings section. Project administrators can view, add, edit, delete, and reorder custom fields via a table UI with drag-and-drop. Fields are typed from existing enums (IssueTypeEnum, IssuePriorityTypeEnum, IssueStateEnum, IssueSubsystemEnum) and persisted per-project via Supabase. The feature follows the existing Clean Architecture pattern with a new `custom_fields` feature module under `lib/features/`.

## Technical Context

**Language/Version**: Dart 3.x (Flutter 3.x)

**Primary Dependencies**: flutter_bloc, go_router, get_it, supabase_flutter, reorderables (for drag-and-drop table)

**Storage**: Supabase (existing backend) — new `custom_fields` and `custom_field_values` tables

**Testing**: flutter_test, mocktail/mockito

**Target Platform**: Web (existing project is web-only, indicated by `go_router` and the existing web app structure)

**Project Type**: Web application (Flutter Web)

**Performance Goals**: Table renders with <1s initial load for up to 50 custom fields per project; drag-and-drop reorder persists within 2s

**Constraints**: Feature must follow existing feature-first Clean Architecture; must use existing Supabase client; must use existing go_router navigation patterns

**Scale/Scope**: Per-project custom fields; estimated <100 fields per project; affects issue creation/editing forms downstream

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Principle I — Feature-First Clean Architecture
- **GATE**: Feature MUST be placed in `lib/features/custom_fields/` with data/domain/presentation layers
- **Status**: ✅ Pass — new feature module follows established pattern
- **Rationale**: Custom fields are a distinct domain concept separate from projects, issues, or other features. A dedicated feature module keeps concerns isolated.

### Principle II — Test-First Development (TDD)
- **GATE**: Tests MUST precede implementation for domain use cases, repository contracts, and BLoC/Cubit state transitions
- **Status**: ✅ Pass — P1 stories (View/Reorder, Add) require test coverage; P2 stories (Edit, Delete) secondary

### Principle III — Supabase Backend Governance
- **GATE**: Schema changes MUST be documented in `supabase/migrations/`; RLS MUST be enabled on all new tables
- **Status**: ✅ Pass — requires new migration for `custom_fields` and `custom_field_values` tables with RLS policies

### Principle IV — State Management Discipline
- **GATE**: Simple CRUD operations should use Cubit; MUST NOT contain business logic
- **Status**: ✅ Pass — CustomFieldsCubit for list CRUD with delegate to use cases

### Principle V — Simplicity & YAGNI
- **GATE**: No abstractions for hypothetical future needs; keep files under 300 lines
- **Status**: ✅ Pass — straightforward CRUD with drag-and-drop; no over-engineering

## Project Structure

### Documentation (this feature)

```text
specs/003-custom-fields-settings/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/features/custom_fields/
├── data/
│   ├── datasources/
│   │   ├── custom_fields_remote_data_source.dart
│   │   └── custom_fields_local_data_source.dart
│   ├── models/
│   │   ├── custom_field_model.dart
│   │   └── custom_field_value_model.dart
│   └── repositories/
│       └── custom_fields_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── custom_field_entity.dart
│   │   └── custom_field_value_entity.dart
│   ├── repositories/
│   │   └── custom_fields_repository.dart
│   └── usecases/
│       ├── get_custom_fields_use_case.dart
│       ├── add_custom_field_use_case.dart
│       ├── update_custom_field_use_case.dart
│       ├── delete_custom_fields_use_case.dart
│       └── reorder_custom_fields_use_case.dart
└── presentation/
    ├── cubits/
    │   └── custom_fields_cubit.dart
    └── pages/
        └── custom_fields_settings_section.dart

test/features/custom_fields/
├── domain/usecases/
├── data/repositories/
└── presentation/cubits/

supabase/migrations/
└── [timestamp]_create_custom_fields.sql
```

**Structure Decision**: Single Flutter project with new `custom_fields` feature under `lib/features/`, following the established feature-first Clean Architecture pattern used by all existing features (projects, issues, auth, etc.).
