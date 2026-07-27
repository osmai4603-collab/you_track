# Research: Time Tracking Settings

**Date**: 2026-07-26
**Feature**: 008-time-tracking-settings

## R1: Feature Module Location

**Decision**: Create `lib/features/time_tracking/` as a new top-level feature module.

**Rationale**: The `custom_fields` feature already lives outside `projects/` and is integrated via the settings section widget. Time tracking follows the same integration pattern — the settings section widget is placed in `projects/presentation/widgets/settings_sections/`, but the domain/data logic lives in its own module. This maintains the one-feature-per-module convention and keeps the projects module focused on project CRUD and member management.

**Alternatives considered**:
- Placing everything inside `projects/` — rejected because it would bloat the projects module (already 10+ pages, 4 cubits) and break the existing convention where cross-cutting concerns get their own module.
- Creating a shared `settings/` module — rejected because it would conflate time tracking with other settings features that have different data models.

## R2: State Management Approach

**Decision**: Use Cubits (not full BLoC) for all time tracking state.

**Rationale**: All other project settings sections use Cubits (`ProjectDetailsCubit`, `ProjectMembersCubit`, `CustomFieldsCubit`). The time tracking settings page has simple state transitions (load → editing → saved/error) without complex event-driven flows. Three separate cubits are needed: one for config (toggle + field mapping + aggregation), one for work types (CRUD + reorder), one for custom attributes (CRUD).

**Alternatives considered**:
- BLoC with events — rejected as over-engineered for a settings page. No async event chains or complex state machines needed.
- Single monolithic cubit — rejected because config, work types, and custom attributes are independent concerns with different save semantics (config is atomic save; work types and attributes are individual CRUD operations).

## R3: Concurrent Edit Detection

**Decision**: Store `updated_at` timestamp on `time_tracking_configs`. On page load, capture the timestamp. On save, compare with current DB value. If mismatch, show warning banner and prompt reload.

**Rationale**: Simple optimistic concurrency without version columns. The "last-write-wins with warning" pattern was chosen in clarification Q2. Since time tracking settings are edited infrequently (typically once per project setup), the probability of concurrent edits is low, making lightweight detection sufficient.

**Alternatives considered**:
- Full version locking (version column + reject on stale) — rejected as over-engineered for a low-frequency settings page. Would add complexity to every save operation.
- No detection (silent last-write-wins) — rejected per clarification Q2; users should be warned when their changes may have been overwritten.

## R4: Work Type Reordering

**Decision**: Add `sort_order` field to `work_types` table. Persist via bulk update on drag completion. Use `reorderables` package (already in pubspec.yaml).

**Rationale**: The `reorderables` package is already a project dependency. Drag-to-reorder was chosen in clarification Q3. Bulk update is efficient for small lists (typically < 20 work types per project). The `sort_order` field is an integer that determines display order in both the settings list and the time logging form.

**Alternatives considered**:
- Separate `work_type_ordering` table — rejected as unnecessary complexity for a single sort field.
- Alphabetical auto-sort — rejected per clarification Q3; admins need explicit ordering control.

## R5: Default Work Types

**Decision**: Seed 4 default work types (Development, Testing, Design, Documentation) when time tracking is first enabled for a project. Insert via Supabase batch insert.

**Rationale**: The spec assumption states defaults should be pre-populated. Inserting on first enable avoids the empty state and provides immediate value. The 4 defaults cover the most common software development activities.

**Alternatives considered**:
- No defaults (empty list until admin adds) — rejected per spec assumption.
- Configurable defaults at org level — rejected as out of scope (project-scoped only).

## R6: Supabase Table Design

**Decision**: 4 new tables (`time_tracking_configs`, `work_types`, `custom_work_item_attributes`, `time_entries`) with RLS policies for admin-only access on config/write operations.

**Rationale**: Each entity maps to a dedicated table following the existing pattern (e.g., `projects`, `project_members`, `custom_fields`). RLS policies enforce FR-026 (admin-only access). The `time_entries` table is included in the data model for completeness but the time logging UI is out of scope for this feature.

**Alternatives considered**:
- Storing config as JSON blob in projects table — rejected because it would make field-level queries difficult and break the relational model.
- Single `time_tracking` table with all nested data — rejected because work types and custom attributes need independent CRUD operations.

## R7: Error Handling Pattern

**Decision**: On save failure, show SnackBar with "Retry" button. Unsaved changes remain editable. The retry button re-invokes the save operation.

**Rationale**: Chosen in clarification Q1. Consistent with the existing project pattern where SnackBars provide feedback (visible in Custom Fields settings). The retry button is more user-friendly than requiring manual re-save, and keeping the form editable prevents data loss.

**Alternatives considered**:
- Snackbar only (no retry) — rejected; forces user to manually re-save.
- Inline error banner — rejected; too heavy for a transient error state.
