# Implementation Plan: Time Tracking Settings

**Branch**: `008-time-tracking-settings` | **Date**: 2026-07-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/008-time-tracking-settings/spec.md`

## Summary

Build the Time Tracking settings page within the Projects feature, following YouTrack's design and existing Clean Architecture patterns. The page enables project administrators to activate time tracking, configure estimation and spent-time field mappings, set up subtask time aggregation, manage work types with drag-to-reorder, and define custom work item attributes. Includes concurrent edit detection (last-write-wins with warning banner) and error handling (snackbar with retry).

## Technical Context

**Language/Version**: Dart 3.12.2, Flutter (Material3)

**Primary Dependencies**: supabase_flutter ^2.16.0, flutter_bloc ^9.1.1, get_it ^9.2.1, go_router ^17.3.0, fpdart ^1.2.0, equatable ^2.1.0, reorderables ^0.6.0

**Storage**: Supabase (PostgreSQL) — 4 new tables: `time_tracking_configs`, `work_types`, `custom_work_item_attributes`, `time_entries`

**Testing**: flutter_test (widget tests, unit tests), integration tests via `flutter test`

**Target Platform**: Cross-platform (iOS, Android, Web, Desktop) — Flutter app

**Project Type**: Mobile/Web application (Clean Architecture with BLoC/Cubit)

**Performance Goals**: Settings page load < 2s, form interactions < 500ms, aggregation update < 3s, work type CRUD < 2s

**Constraints**: Admin-only access (FR-026), project-scoped data, concurrent edit detection via updated_at timestamp, error snackbar with retry on save failure

**Scale/Scope**: Project-level settings (not organization-wide), 6 user stories, 33 functional requirements, 4 entities

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No constitution.md file exists — no governance constraints to evaluate. Proceeding with standard project patterns.

## Project Structure

### Documentation (this feature)

```text
specs/008-time-tracking-settings/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── ui-contract.md
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_route_keys.dart              # Already has time tracking route key (no change needed)
│   ├── enums/
│   │   └── custom_field_type_enum.dart      # Already has Period type (verify coverage)
│   └── init_dependencies.dart               # Add _initTimeTrackingFeature()
│
├── features/
│   ├── time_tracking/                       # NEW FEATURE MODULE
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── time_tracking_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── time_tracking_config_model.dart
│   │   │   │   ├── work_type_model.dart
│   │   │   │   ├── custom_work_item_attribute_model.dart
│   │   │   │   └── time_entry_model.dart
│   │   │   └── repositories/
│   │   │       └── time_tracking_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── time_tracking_config_entity.dart
│   │   │   │   ├── work_type_entity.dart
│   │   │   │   ├── custom_work_item_attribute_entity.dart
│   │   │   │   └── time_entry_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── time_tracking_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_time_tracking_config.dart
│   │   │       ├── save_time_tracking_config.dart
│   │   │       ├── get_work_types.dart
│   │   │       ├── add_work_type.dart
│   │   │       ├── update_work_type.dart
│   │   │       ├── delete_work_type.dart
│   │   │       ├── reorder_work_types.dart
│   │   │       ├── get_custom_work_item_attributes.dart
│   │   │       ├── add_custom_work_item_attribute.dart
│   │   │       ├── update_custom_work_item_attribute.dart
│   │   │       └── delete_custom_work_item_attribute.dart
│   │   └── presentation/
│   │       ├── cubits/
│   │       │   ├── time_tracking_config_cubit.dart
│   │       │   ├── work_types_cubit.dart
│   │       │   └── custom_attributes_cubit.dart
│   │       └── widgets/
│   │           ├── time_tracking_toggle.dart
│   │           ├── field_configuration_section.dart
│   │           ├── aggregation_section.dart
│   │           ├── work_types_section.dart
│   │           ├── work_type_form_dialog.dart
│   │           ├── custom_attributes_section.dart
│   │           ├── custom_attribute_form_dialog.dart
│   │           └── time_tracking_save_bar.dart
│   │
│   └── projects/presentation/widgets/settings_sections/
│       └── project_time_tracking_settings_section.dart  # REPLACE placeholder
```

**Structure Decision**: New feature module `time_tracking/` following existing Clean Architecture pattern (same as `custom_fields/`). Integrated into existing `projects` feature settings via `project_time_tracking_settings_section.dart`. Uses Supabase for persistence, Cubit for state management, GetIt for DI.

## Complexity Tracking

> No constitution violations to justify — feature follows established project patterns.
