# Implementation Plan: Add Custom Field Page

**Branch**: `004-add-custom-field` | **Date**: 2026-07-26 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/004-add-custom-field/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Add a custom field creation page with sliding panel animation, overlay, tabbed type selection, form inputs, and privacy toggle. Implementation will follow Flutter feature-first clean architecture with BLoC/Cubit state management, Supabase backend integration, and TDD approach.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart 3.12.2, Flutter 3.x

**Primary Dependencies**: flutter_bloc, equatable, get_it, supabase_flutter, go_router, intl

**Storage**: Supabase (PostgreSQL) with Row Level Security

**Testing**: flutter_test, mockito/mocktail, widget tests, integration tests

**Target Platform**: iOS and Android (mobile app)

**Project Type**: mobile-app

**Performance Goals**: 60 fps animations, under 2 seconds panel open time

**Constraints**: Offline-capable for cached data, network error handling required

**Scale/Scope**: 10k+ users, 50+ screens, multiple feature modules

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Constitution Compliance**:
- Feature-First Clean Architecture: Feature will reside in `lib/features/custom_field/` with data/domain/presentation layers
- Test-First Development: TDD will be followed with tests before implementation
- Supabase Backend Governance: Schema changes via migrations, RLS enabled, typed queries
- State Management Discipline: Use Cubit for simple form state, BLoC for complex workflows
- Simplicity & YAGNI: Minimal layers, reuse existing patterns

**Gate Status**: PASS - No violations detected. All principles can be satisfied.

### Post-Design Re-evaluation
After Phase 1 design, re-evaluated constitution compliance:
- **Feature-First Clean Architecture**: Design places feature in `lib/features/custom_field/` with proper layers ✓
- **Test-First Development**: Testing strategy includes TDD approach ✓
- **Supabase Backend Governance**: Schema migrations, RLS policies, typed queries ✓
- **State Management Discipline**: Cubit for simple state, BLoC for complex workflows ✓
- **Simplicity & YAGNI**: Minimal new patterns, reuse existing infrastructure ✓

**Updated Gate Status**: PASS - All principles satisfied in design.

## Project Structure

### Documentation (this feature)

```text
specs/004-add-custom-field/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── app.dart
├── core/                    # Shared code (theme, constants, services, widgets)
│   ├── theme/
│   ├── constants/
│   ├── services/
│   └── widgets/
└── features/
    ├── custom_fields/       # Existing feature (may be extended)
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── [other features]/

test/
├── unit/
├── widget/
└── integration/

supabase/
└── migrations/              # Database schema migrations

android/
ios/
web/
```

**Structure Decision**: Flutter mobile app following feature-first clean architecture. New feature will reside in `lib/features/custom_field/` (or extend existing `custom_fields/`) with data/domain/presentation layers. Tests in `test/` directory.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
