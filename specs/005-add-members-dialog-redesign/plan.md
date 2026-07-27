# Implementation Plan: Add Members Dialog Redesign

**Branch**: `005-add-members-dialog-redesign` | **Date**: Sun Jul 26 2026 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/005-add-members-dialog-redesign/spec.md`

## Summary

Redesign the `AddProjectMembersPage` dialog from an overlay-based suggestion system to an always-visible table layout. The dialog will display a search field at the top, followed by a card containing a table with columns: Name, Add to team (toggle), and Roles (dropdown). Each row represents a user or group, with toggle switches for team membership selection and dropdowns for role assignment. The implementation reuses existing `ProjectMembersCubit` and `AddProjectMemberUseCase` with no backend changes required.

## Technical Context

**Language/Version**: Dart 3.x, Flutter 3.x

**Primary Dependencies**: flutter_bloc, flutter/material.dart

**Storage**: N/A (UI-only redesign)

**Testing**: flutter_test, mockito/mocktail for mocking

**Target Platform**: Cross-platform (iOS, Android, Web)

**Project Type**: Mobile application (Flutter)

**Performance Goals**: Search/filter responds within 500ms

**Constraints**: Must follow Feature-First Clean Architecture and existing theme system

**Scale/Scope**: Single dialog widget redesign (~300 lines)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Feature-First Clean Architecture | ✅ PASS | Dialog resides in `lib/features/projects/presentation/pages/` |
| II. Test-First Development (TDD) | ⚠️ PENDING | Widget tests required for dialog interactions |
| III. Supabase Backend Governance | ✅ PASS | No backend changes; reuses existing use case |
| IV. State Management Discipline | ✅ PASS | Uses existing Cubit; local StatefulWidget for UI state |
| V. Simplicity & YAGNI | ✅ PASS | Simple widget redesign without new abstractions |

## Project Structure

### Documentation (this feature)

```text
specs/005-add-members-dialog-redesign/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── ui-contract.md
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/features/projects/
├── data/
│   └── models/
│       └── project_member_model.dart  # Existing
├── domain/
│   ├── entities/
│   │   └── project_member_entity.dart  # Existing
│   └── usecases/
│       └── add_project_member_use_case.dart  # Existing
└── presentation/
    ├── cubits/
    │   └── project_members_cubit.dart  # Existing
    └── pages/
        └── add_project_members_page.dart  # TO BE REDESIGNED
```

**Structure Decision**: Single feature modification within existing Flutter project structure. No new files required; only modification of existing `add_project_members_page.dart`.

## Complexity Tracking

No constitution violations requiring justification.
