# Implementation Plan: Create Project Navigation

**Branch**: `001-create-project-navigation` | **Date**: 2026-07-25 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-create-project-navigation/spec.md`

## Summary

The "Create Project" button in the shared header (`YouTrackContentHeader`) has an empty `onPressed: () {}` handler. The original working implementation in `projects_list_page.dart` was commented out when the button was moved to the global header. This feature wires up the existing button to navigate to the template selection page (`/projects/templates`), restoring the full project creation wizard flow: List → Template Selection → Template Details → Form → Add Members.

No new pages, routes, entities, or state management are needed. The change is confined to a single callback in one file.

## Technical Context

**Language/Version**: Dart 3.12.2, Flutter (latest stable)

**Primary Dependencies**: flutter_bloc (BLoC/Cubit), go_router (navigation)

**Storage**: Supabase (existing backend — no schema changes needed)

**Testing**: flutter_test (widget tests), flutter_lints (static analysis)

**Target Platform**: Android, iOS, Linux, macOS, Web, Windows (multi-platform)

**Project Type**: mobile-app (cross-platform Flutter)

**Performance Goals**: Navigation completes in <1 second (local route, no network call)

**Constraints**: Must not break existing shell header behavior; must not introduce new dependencies

**Scale/Scope**: Single file edit, one callback wiring

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Gate | Status |
|-----------|------|--------|
| I. Feature-First Clean Architecture | Button is in `lib/features/dashboards/presentation/widgets/` (shared header). Navigation goes to existing projects feature routes. No cross-feature import violations. | PASS |
| II. Test-First Development (TDD) | Widget test for button tap → navigation. No new business logic (cubit/use case) to test. | PASS |
| III. Supabase Backend Governance | No Supabase changes. No schema, RLS, or API modifications. | PASS (N/A) |
| IV. State Management Discipline | No new state management. Existing `YouTrackShellCubit` and `ProjectCreationCubit` are reused. | PASS |
| V. Simplicity & YAGNI | Single callback change. No new abstractions, classes, or files needed. | PASS |

**No violations.** Complexity Tracking section not needed.

## Project Structure

### Documentation (this feature)

```text
specs/001-create-project-navigation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── features/
│   ├── dashboards/
│   │   └── presentation/
│   │       └── widgets/
│   │           └── dashboard_body_header.dart  # EDIT: wire onPressed callback
│   └── projects/
│       └── presentation/
│           └── pages/
│               ├── create_project_form_page.dart  # EXISTING (destination)
│               └── project_template_selection_page.dart  # EXISTING (intermediate)
├── core/
│   └── constants/
│       └── app_route_keys.dart  # EXISTING (route constants)
│   └── services/
│       └── navigation_service.dart  # EXISTING (route definitions)
test/
└── features/
    └── dashboards/
        └── presentation/
            └── widgets/
                └── dashboard_body_header_test.dart  # NEW: widget test
```

**Structure Decision**: Single-project Flutter app. Feature lives in `lib/features/dashboards/presentation/widgets/` (existing shared header). No new files or directories needed for the feature itself — only a new test file.

## Complexity Tracking

> No constitution violations to justify.
