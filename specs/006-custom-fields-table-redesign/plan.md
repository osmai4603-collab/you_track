# Implementation Plan: Custom Fields Table Redesign

**Branch**: `006-custom-fields-table-redesign` | **Date**: 2026-07-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/006-custom-fields-table-redesign/spec.md`

## Summary

Rebuild the Custom Fields settings page (`custom_fields_settings_section.dart`) to match YouTrack's table-based layout with enhanced field metadata display, toolbar actions (Add, Edit, Delete, Replace, Make Private), drag-and-drop reordering, field visibility control, and a Show/Hide details toggle. The feature includes full "Make private" implementation with admin-only access control and group/user selection via dialog with overlay.

## Technical Context

**Language/Version**: Dart 3.12.2, Flutter (latest stable)

**Primary Dependencies**: flutter_bloc 9.1.1, equatable 2.1.0, get_it 9.2.1, supabase_flutter 2.16.0, fpdart 1.2.0, reorderables 0.6.0, intl 0.20.2

**Storage**: Supabase (PostgreSQL) via `custom_fields` table with RLS enabled

**Testing**: flutter_test, mockito/mocktail for mocking, flutter test runner

**Target Platform**: Cross-platform (iOS, Android, Web) via Flutter

**Project Type**: Mobile + Web application (Flutter with Supabase backend)

**Performance Goals**: Page load < 3 seconds for 50+ fields, drag-and-drop reorder < 2 seconds, bulk operations < 5 seconds

**Constraints**: Must follow Clean Architecture (Feature-First), TDD, Supabase governance, State Management discipline (Cubit/BLoC), Simplicity & YAGNI principles as defined in the constitution

**Scale/Scope**: Single feature redesign within existing project settings, 14 field types, ~26 files in custom_fields feature

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Feature-First Clean Architecture | ✅ PASS | Feature resides in `lib/features/custom_fields/` with proper layer separation (data/domain/presentation). Shared code in `lib/core/`. |
| II. Test-First Development (TDD) | ⚠️ GAP | No existing tests for custom_fields feature. New implementation MUST include tests for cubit state transitions and widget interactions. |
| III. Supabase Backend Governance | ✅ PASS | Existing RLS policies on `custom_fields` table. New visibility/access control fields must have corresponding migration and RLS policies. |
| IV. State Management Discipline | ✅ PASS | Uses Cubit pattern with Equatable states. New cubits (MakePrivateCubit, VisibilityCubit) follow existing patterns. |
| V. Simplicity & YAGNI | ✅ PASS | Reuses existing widgets (PanelOverlay, SlidingPanel), cubits, and patterns. No new abstractions beyond what's needed. |
| Security & Data Governance | ✅ PASS | Admin-only access control for Make Private. Input validation at domain layer. No sensitive data exposure. |
| Localization | ✅ PASS | All user-facing strings use `intl` l10n system via `AppLocalizations`. |

**Gate Result**: PASS with one gap (TDD) that must be addressed during implementation.

## Project Structure

### Documentation (this feature)

```text
specs/006-custom-fields-table-redesign/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/features/custom_fields/
├── data/
│   ├── datasources/
│   │   └── custom_fields_remote_data_source.dart  # Extend: add updateVisibility(), updateAccessControl()
│   ├── models/
│   │   ├── custom_field_model.dart                # Extend: add visibility, accessControl fields
│   │   └── custom_field_value_model.dart
│   └── repositories/
│       └── custom_fields_repository_impl.dart     # Extend: add updateVisibility(), updateAccessControl()
├── domain/
│   ├── entities/
│   │   ├── custom_field_entity.dart               # Extend: add visibility, accessControl properties
│   │   └── custom_field_value_entity.dart
│   ├── repositories/
│   │   └── custom_fields_repository.dart          # Extend: add new method signatures
│   └── usecases/
│       ├── add_custom_field_use_case.dart
│       ├── delete_custom_fields_use_case.dart
│       ├── get_custom_fields_use_case.dart
│       ├── reorder_custom_fields_use_case.dart
│       ├── update_custom_field_use_case.dart
│       ├── update_field_visibility_use_case.dart  # NEW
│       └── update_field_access_control_use_case.dart  # NEW
└── presentation/
    ├── cubits/
    │   ├── custom_fields_cubit.dart               # Extend: add updateVisibility(), updateAccessControl()
    │   ├── field_visibility_cubit.dart            # NEW
    │   └── field_access_control_cubit.dart        # NEW
    ├── pages/
    │   ├── add_custom_field_page.dart
    │   └── custom_fields_settings_section.dart    # REBUILD: table layout, toolbar, selection, details toggle
    └── widgets/
        ├── custom_tab_bar.dart
        ├── panel_overlay.dart                     # REUSE
        ├── sliding_panel.dart                     # REUSE
        ├── field_table_row.dart                   # NEW: individual row widget
        ├── field_table_header.dart                # NEW: table header with select-all
        ├── field_toolbar.dart                     # NEW: toolbar with action buttons
        ├── make_private_dialog.dart               # NEW: dialog with overlay for access control
        └── replace_value_popup.dart               # NEW: PopupButton with TextField for Replace
```

**Structure Decision**: Feature-First Clean Architecture as mandated by constitution. All custom fields code remains in `lib/features/custom_fields/`. New widgets are added to `presentation/widgets/` following existing patterns. New use cases added to `domain/usecases/`. New cubits added to `presentation/cubits/`.

## Complexity Tracking

> No constitution violations requiring justification. The TDD gap is an existing technical debt, not a new violation.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |
