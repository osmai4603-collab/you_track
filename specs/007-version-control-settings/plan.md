# Implementation Plan: Version Control Settings

**Branch**: `007-version-control-settings` | **Date**: 2026-07-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/007-version-control-settings/spec.md`

## Summary

Add a Version Control settings page to the project settings, enabling repository integrations (GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, Gitea, Custom Git) with conditional authentication fields (OAuth/Token/SSH), commit parsing, PR automation, visibility controls, user mapping, and synchronization settings. Follows YouTrack's VCS integration design with full data model and conditional field logic. Built as a new feature module following existing Clean Architecture patterns with Supabase backend.

## Technical Context

**Language/Version**: Dart 3.12.2, Flutter (Material3)

**Primary Dependencies**: supabase_flutter ^2.16.0, flutter_bloc ^9.1.1, get_it ^9.2.1, go_router ^17.3.0, fpdart ^1.2.0, equatable ^2.1.0

**Storage**: Supabase (PostgreSQL) — 4 tables: `vcs_integrations`, `vcs_user_mappings`, `vcs_commits`, `vcs_pull_requests`

**Testing**: flutter_test (widget tests, unit tests), integration tests via `flutter test`

**Target Platform**: Cross-platform (iOS, Android, Web, Desktop) — Flutter app

**Project Type**: Mobile/Web application (Clean Architecture with BLoC/Cubit)

**Performance Goals**: Repository table loads < 2s, connection test < 5s, dialog field adaptation < 1s, commit parsing 95% accuracy

**Constraints**: Application-level encryption for credentials, admin-only access to VCS settings, max ~10 repositories per project

**Scale/Scope**: Project-level settings (not organization-wide), 7 user stories, 36 functional requirements, 8 entities

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No constitution.md file exists — no governance constraints to evaluate. Proceeding with standard project patterns.

## Project Structure

### Documentation (this feature)

```text
specs/007-version-control-settings/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── ui-contract.md
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_route_keys.dart          # Add vcs-related route keys
│   ├── enums/
│   │   ├── vcs_provider_type_enum.dart   # NEW: github/gitlab/bitbucket_cloud/bitbucket_server/gitea/custom_git
│   │   ├── vcs_auth_mode_enum.dart       # NEW: oauth/token/ssh
│   │   ├── vcs_connection_status_enum.dart # NEW: connected/disabled/auth_failed/sync_error
│   │   └── vcs_pr_state_enum.dart        # NEW: open/merged/closed
│   └── init_dependencies.dart            # Add _initVersionControlFeature()
│
├── features/
│   └── version_control/                  # NEW FEATURE MODULE
│       ├── data/
│       │   ├── datasources/
│       │   │   └── vcs_remote_data_source.dart
│       │   ├── models/
│       │   │   ├── vcs_integration_model.dart
│       │   │   ├── vcs_user_mapping_model.dart
│       │   │   ├── vcs_commit_model.dart
│       │   │   └── vcs_pull_request_model.dart
│       │   └── repositories/
│       │       └── vcs_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── vcs_integration_entity.dart
│       │   │   ├── vcs_user_mapping_entity.dart
│       │   │   ├── vcs_commit_entity.dart
│       │   │   └── vcs_pull_request_entity.dart
│       │   ├── repositories/
│       │   │   └── vcs_repository.dart
│       │   └── usecases/
│       │       ├── get_vcs_integrations.dart
│       │       ├── add_vcs_integration.dart
│       │       ├── update_vcs_integration.dart
│       │       ├── delete_vcs_integration.dart
│       │       ├── toggle_vcs_integration_status.dart
│       │       ├── test_vcs_connection.dart
│       │       ├── get_vcs_commits.dart
│       │       ├── get_vcs_pull_requests.dart
│       │       ├── get_vcs_user_mappings.dart
│       │       ├── add_vcs_user_mapping.dart
│       │       └── delete_vcs_user_mapping.dart
│       └── presentation/
│           ├── cubits/
│           │   ├── vcs_integrations_cubit.dart
│           │   ├── vcs_integration_form_cubit.dart
│           │   ├── vcs_user_mappings_cubit.dart
│           │   └── vcs_connection_test_cubit.dart
│           ├── pages/
│           │   └── vcs_settings_page.dart
│           └── widgets/
│               ├── vcs_repository_table.dart
│               ├── vcs_status_badge.dart
│               ├── vcs_add_dialog.dart
│               ├── vcs_provider_selector.dart
│               ├── vcs_auth_fields.dart
│               ├── vcs_mapping_fields.dart
│               ├── vcs_automation_fields.dart
│               ├── vcs_user_mapping_table.dart
│               └── vcs_branch_specification_input.dart
│
└── features/projects/presentation/widgets/settings_sections/
    └── project_vcs_settings_section.dart  # REPLACE placeholder
```

**Structure Decision**: New feature module `version_control/` following existing Clean Architecture pattern (same as `custom_fields/`). Integrated into existing `projects` feature settings via `project_vcs_settings_section.dart`. Uses Supabase for persistence, Cubit for state management, GetIt for DI.

## Complexity Tracking

> No constitution violations to justify — feature follows established project patterns.
