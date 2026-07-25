# Implementation Plan: Project People Settings Redesign

**Branch**: `001-project-people-settings` | **Date**: Sun Jul 26 2026 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-project-people-settings/spec.md`

## Summary

Redesign the `ProjectPeopleSettingsSection` widget to match the YouTrack-style team management interface. The page displays a searchable, filterable table of project team members with color-coded role chips, an "Other People with Access" section for members with empty roles, and a context menu for member removal. This is a **presentation-layer-only** change — no new backend APIs, entities, or use cases are required. The existing `ProjectMembersCubit` and `ProjectMemberEntity` data model are sufficient.

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter (latest stable)

**Primary Dependencies**: flutter_bloc 9.1.1, equatable 2.1.0, get_it 9.2.1, supabase_flutter 2.16.0, fpdart 1.2.0

**Storage**: Supabase (project_members table) — no schema changes needed

**Testing**: flutter_test, hand-written test doubles (no mockito/mocktail — project uses manual fakes)

**Target Platform**: Mobile + Web (Flutter cross-platform)

**Project Type**: mobile-app (Flutter)

**Performance Goals**: Search/filter responds within 500ms; page loads within 2 seconds for up to 100 members

**Constraints**: Must use existing theme system (AppColorScheme, AppRadius, AppSpacing, AppIcons), existing localization system (intl/ARB), existing cubit patterns (Equatable state, fpdart Either error handling)

**Scale/Scope**: Single widget file redesign (~300 lines target per constitution), 1 modified cubit (search state), 0 new entities/use cases

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Design (Phase 0) ✓

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Feature-First Clean Architecture | PASS | Changes confined to `lib/features/projects/presentation/` — no cross-feature imports, no new data/domain layers needed |
| II. Test-First Development (TDD) | PASS | Widget tests will be written for new UI; cubit state transitions already covered by existing pattern |
| III. Supabase Backend Governance | PASS | No schema changes, no new RLS policies, no new API calls — reuses existing `getProjectMembers` query |
| IV. State Management Discipline | PASS | Uses Cubit (simple state: search query + filtered list); UI-only state (dropdown open/close) uses StatefulWidget `ValueNotifier` |
| V. Simplicity & YAGNI | PASS | Reuses existing cubit, entity, and use case — no new abstractions. Single widget file with helper methods, not split into unnecessary sub-widgets |
| Security & Data Governance | PASS | Access control enforced at presentation level; no new PII handling; no sensitive data in logs |
| Localization | PASS | All user-facing strings use `AppLocalizations` (ARB keys already exist: `projectTeamTitle`, `otherPeopleAccessTitle`, role names) |

### Post-Design (Phase 1) ✓

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Feature-First Clean Architecture | PASS | data-model.md confirms no entity changes; contracts/ui-contract.md confirms widget-only scope |
| II. Test-First Development (TDD) | PASS | quickstart.md defines 7 validation scenarios; widget tests specified |
| III. Supabase Backend Governance | PASS | research.md confirms no new API endpoints or schema changes |
| IV. State Management Discipline | PASS | research.md confirms searchQuery added to existing cubit state; role toggle uses local StatefulWidget state |
| V. Simplicity & YAGNI | PASS | research.md confirms no new use cases, repositories, or data sources added |
| Security & Data Governance | PASS | research.md confirms access control via conditional rendering; no new data flows |
| Localization | PASS | data-model.md lists all new ARB keys needed; existing keys reused where possible |

## Project Structure

### Documentation (this feature)

```text
specs/001-project-people-settings/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
lib/features/projects/
├── domain/
│   └── entities/
│       └── project_member_entity.dart       # Existing — no changes
├── presentation/
│   ├── cubits/
│   │   ├── project_details_cubit.dart       # Existing — no changes
│   │   └── project_members_cubit.dart       # MODIFIED — add searchQuery field + updateSearchQuery method
│   ├── pages/
│   │   └── project_settings_page.dart       # Existing — no changes (hosts the section)
│   └── widgets/
│       └── settings_sections/
│           └── project_people_settings_section.dart  # REDESIGNED — full widget rewrite

test/features/projects/
└── presentation/
    └── widgets/
        └── settings_sections/
            └── project_people_settings_section_test.dart  # NEW — widget tests
```

**Structure Decision**: Follows Feature-First Clean Architecture (Principle I). All changes are within the existing `projects` feature. The cubit is modified (not a new cubit) to add search filtering. The widget is redesigned in place. No new files in data/ or domain/ layers.

## Complexity Tracking

No constitution violations — no complexity tracking needed.
