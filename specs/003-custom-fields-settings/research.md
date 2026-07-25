# Research: Custom Fields Settings

## Overview

Research findings to resolve unknowns for implementing the Custom Fields Settings feature.

---

## 1. Drag-and-Drop Implementation

**Decision**: Use `reorderables` package (`ReorderableTable` widget) or implement custom `LongPressDraggable` + `DragTarget` for the table rows.

**Rationale**: The existing codebase has no drag-and-drop dependency yet. The `reorderables` package provides `ReorderableTable` which handles row reordering with visual feedback and automatic list reordering. A custom implementation using Flutter's native `LongPressDraggable`/`DragTarget` is also viable but requires more boilerplate for table row reordering. Since the user explicitly recommended `reorderables`, this should be the default.

**Alternatives considered**:
- Flutter native `ReorderableListView`: Does not support table/grid layouts well
- `reorderable_table` package: Less maintained than `reorderables`
- Custom `LongPressDraggable` + `DragTarget`: Full control but more code

## 2. Field Type Mapping

**Decision**: Map existing enums to a unified `CustomFieldType` enum in the custom_fields feature.

**Rationale**: The existing enums (IssueTypeEnum, IssuePriorityTypeEnum, IssueStateEnum, IssueSubsystemEnum) are defined in `lib/core/enums/` and use a sealed class pattern. Each custom field's type should be stored as a string identifier (e.g., `"issue-type"`, `"priority"`, `"state"`, `"subsystem"`) and the matching enum is resolved at display time. This avoids tight coupling between the custom fields feature and the specific enum implementations.

**Field types available**:
- `issue-type` → IssueTypeEnum (8 values: bug, cosmetic, exception, feature, task, usability-problem, performance-problem, epic)
- `priority` → IssuePriorityTypeEnum (5 values: show-stopper, critical, major, normal, minor)
- `state` → IssueStateEnum (3 values: to-do, in-progress, done)
- `subsystem` → IssueSubsystemEnum (4 values: no-value, issue-tracking, project-management, migration)

## 3. Supabase Table Schema

**Decision**: Two new tables — `custom_fields` and `custom_field_values`.

**Rationale**: Custom fields are per-project configurations. `custom_fields` stores the field definition (name, type, default value, order). `custom_field_values` stores the actual values on issues. Both follow the existing Supabase patterns with RLS policies.

**`custom_fields` table**:
- `id` UUID PRIMARY KEY DEFAULT gen_random_uuid()
- `project_id` UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE
- `name` TEXT NOT NULL
- `field_type` TEXT NOT NULL (one of: "issue-type", "priority", "state", "subsystem")
- `default_value` TEXT (nullable, one of the enum values for the chosen type)
- `order_index` INTEGER NOT NULL DEFAULT 0
- `created_at` TIMESTAMPTZ NOT NULL DEFAULT now()
- `updated_at` TIMESTAMPTZ NOT NULL DEFAULT now()
- UNIQUE(project_id, name)

**`custom_field_values` table**:
- `id` UUID PRIMARY KEY DEFAULT gen_random_uuid()
- `issue_id` UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE
- `custom_field_id` UUID NOT NULL REFERENCES custom_fields(id) ON DELETE RESTRICT (preserve historical data)
- `value` TEXT (the selected enum value)
- UNIQUE(issue_id, custom_field_id)

## 4. Existing Integration Points

**Sidebar**: `CustomFieldsSidebarItem` already exists at `lib/features/projects/presentation/widgets/sidebar_items/custom_fields_sidebar_item.dart`. It's already wired into the `ProjectSettingsSidebar` at index 2.

**Routing**: Route `settings/custom-fields` already defined in `navigation_service.dart` (line 292) with a placeholder `Center(child: Text('Custom Fields Settings'))`.

**Settings page**: `ProjectSettingsPage` already handles `/custom-fields` path at index 2 in `_getSelectedIndex()`.

**Quick action**: "Custom Fields" quick action button exists in `ProjectPeopleSettingsSection._buildQuickActions()`.

## 5. Persistence Strategy

**Decision**: Use Supabase as the single source of truth (following Principle III — Supabase Backend Governance). No local caching for the initial implementation (YAGNI).

**Rationale**: The existing data layer pattern uses `ProjectsRemoteDataSource` backed by Supabase. The custom fields feature should follow the same pattern. A `CustomFieldsRemoteDataSource` will communicate with Supabase. The repository pattern (`CustomFieldsRepositoryImpl`) will wrap the data source.

## 6. State Management Approach

**Decision**: Use a Cubit (`CustomFieldsCubit`) for the custom fields list CRUD.

**Rationale**: The operations are simple CRUD (load list, add, edit, delete, reorder) — perfect for Cubit. No complex event-driven workflows that would warrant a full BLoC. This follows Principle IV (State Management Discipline: simple state → Cubit).
