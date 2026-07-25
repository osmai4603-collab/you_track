<!-- Sync Impact Report
  Version change: N/A → 1.0.0 (initial ratification)
  Modified principles: N/A (first version)
  Added sections: Core Principles (5), Security & Data Governance, Development Workflow, Governance
  Removed sections: N/A
  Templates requiring updates:
    ✅ .specify/templates/plan-template.md - Constitution Check section aligns with principles
    ✅ .specify/templates/spec-template.md - Requirements format compatible
    ✅ .specify/templates/tasks-template.md - Task phases compatible
  Follow-up TODOs: None
-->

# YouTrack Constitution

## Core Principles

### I. Feature-First Clean Architecture

Every feature MUST reside in `lib/features/<feature_name>/` with the following
layered structure:

- **data/**: datasources (remote/local), models, repository implementations
- **domain/**: entities, repository interfaces, use cases
- **presentation/**: pages, widgets, BLoC/Cubit state management

Shared code MUST live in `lib/core/` (theme, constants, services, widgets).
Features MUST NOT import from other features' data or presentation layers;
cross-feature communication MUST go through domain-level interfaces or a shared
service in `lib/core/`.

Each feature MUST define a repository interface in `lib/features/<feature>/domain/`
with an implementation in `lib/features/<feature>/data/`. Dependency injection
MUST use `get_it` and be registered in a central service locator file.

**Rationale**: Enforces clear boundaries, enables parallel development,
and keeps features independently testable and replaceable.

### II. Test-First Development (TDD)

All new business logic MUST follow the Red-Green-Refactor cycle:

1. **Red**: Write a failing test that defines the expected behavior
2. **Green**: Write the minimum code to make the test pass
3. **Refactor**: Clean up while keeping tests green

Tests MUST be written before implementation for:
- Domain use cases and repository contracts
- BLoC/Cubit state transitions
- Widget interactions (widget tests)

Minimum test coverage per feature:
- Domain layer: 100% of use cases and repository contracts
- Presentation layer: all BLoC/Cubit state transitions
- Integration tests: critical user journeys (at least P1 stories)

Tests MUST use `flutter_test` and run via `flutter test`. Mocking MUST use
the `mockito` or `mocktail` pattern with generated mocks.

**Rationale**: TDD catches defects early, serves as living documentation,
and forces clear interface design before implementation.

### III. Supabase Backend Governance

All Supabase interactions MUST follow these rules:

- **Schema changes**: MUST be documented in a migration file under `supabase/migrations/`
  with a descriptive name and tested against a local Supabase instance before merge
- **Row Level Security (RLS)**: EVERY table MUST have RLS enabled; policies MUST
  be defined for all access patterns; no `anon` role write access in production
- **API contracts**: Remote data sources MUST program against Supabase client typed
  queries; raw SQL MUST NOT be used in application code
- **Realtime subscriptions**: MUST be scoped to specific tables and filtered; no
  unfiltered broadcast subscriptions in production
- **Secrets**: API keys and service role keys MUST NOT be committed to the repository;
  use environment variables or `.env` files excluded via `.gitignore`

**Rationale**: Supabase is the single backend; strict governance prevents
data leaks, schema drift, and untested production changes.

### IV. State Management Discipline

State management MUST use `flutter_bloc` (BLoC) or `flutter_bloc` Cubit:

- **Complex state** (multiple events, side effects, async workflows): Use BLoC
  with typed events and states
- **Simple state** (form fields, toggle, single async load): Use Cubit
- **UI-only state** (animations, scroll position): Use `ValueNotifier` or
  `StatefulWidget` — no BLoC/Cubit overhead

All BLoC/Cubit classes MUST:
- Be placed in `lib/features/<feature>/presentation/bloc/` (BLoC) or
  `lib/features/<feature>/presentation/cubits/` (Cubit)
- Use `Equatable` for state and event classes to avoid unnecessary rebuilds
- NOT contain business logic; delegate to use cases in the domain layer

**Rationale**: Consistent state management reduces cognitive load and
prevents ad-hoc state patterns that are hard to test and maintain.

### V. Simplicity & YAGNI

Developers MUST:

- Choose the simplest solution that satisfies the current requirements
- NOT add abstractions, layers, or infrastructure for hypothetical future needs
- Reuse existing patterns in the codebase before introducing new ones
- Keep each file under 300 lines; split when exceeded
- Prefer composition over inheritance for widget and service design

When a feature can be implemented with fewer layers or classes, do so. The
three-layer architecture is the maximum, not the minimum.

**Rationale**: Over-engineering slows delivery and increases maintenance burden.
Simplicity is a feature, not a compromise.

## Security & Data Governance

- Authentication MUST use Supabase Auth; custom auth flows MUST NOT bypass
  Supabase's JWT validation
- User input MUST be validated at the domain layer before persistence
- Sensitive data (tokens, passwords) MUST NOT appear in logs or error messages
- The app MUST handle network errors gracefully and inform the user of
  connectivity issues without exposing stack traces
- All PII handling MUST comply with the principle of least privilege;
  features MUST only request the data they need

## Development Workflow

- **Branching**: Feature branches MUST be named `<ticket-id>-<short-description>`
- **Commits**: MUST follow Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`,
  `test:`, `chore:`)
- **Code review**: ALL pull requests MUST be reviewed by at least one other developer
  before merge; reviewer MUST verify constitution compliance
- **CI gate**: `flutter analyze` and `flutter test` MUST pass before merge
- **Dependencies**: New dependencies MUST be justified in the PR description and
  approved by a maintainer; `flutter_lints` rules MUST NOT be downgraded without
  documented rationale
- **Localization**: User-facing strings MUST use the `intl` l10n system defined in
  `l10n.yaml`; hardcoded strings in widgets MUST NOT be merged

## Governance

This constitution supersedes all other development practices for the YouTrack
project. In case of conflict between this document and any other guide, this
document takes precedence.

**Amendment process**:
1. Proposed changes MUST be documented with rationale and impact analysis
2. The constitution version MUST be incremented per semantic versioning:
   - MAJOR: principle removal or incompatible redefinition
   - MINOR: new principle or section added
   - PATCH: clarifications, wording, typo fixes
3. All dependent templates and workflow files MUST be updated in the same change
4. The amendment MUST be reviewed and approved before merge

**Compliance review**: Every PR description MUST include a self-check confirming
which constitution principles the change touches. Reviewers MUST flag violations
and require justification or remediation before approval.

**Runtime guidance**: For day-to-day development decisions not covered by this
constitution, refer to `lib/` code conventions, existing patterns, and the
Flutter style guide.

**Version**: 1.0.0 | **Ratified**: 2026-07-25 | **Last Amended**: 2026-07-25
