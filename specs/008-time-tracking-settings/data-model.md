# Data Model: Time Tracking Settings

**Date**: 2026-07-26
**Feature**: 008-time-tracking-settings

## Supabase Tables

### time_tracking_configs

Project-level time tracking configuration. One row per project (1:1 relationship).

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| project_id | UUID PK FK | NO | — | References projects.id |
| enabled | boolean | NO | false | Master toggle for time tracking |
| estimation_field_id | UUID FK | YES | NULL | References custom_fields.id (Period type) |
| spent_time_field_id | UUID FK | YES | NULL | References custom_fields.id (Period type) |
| aggregate_spent_time | boolean | NO | false | Sum subtask spent time into parent |
| aggregate_estimation | boolean | NO | false | Sum subtask estimations into parent |
| updated_at | timestamptz | NO | now() | For concurrent edit detection |
| created_at | timestamptz | NO | now() | Record creation timestamp |

**Constraints**:
- estimation_field_id ≠ spent_time_field_id (application-level validation, FR-008)
- project_id is unique (one config per project)

**RLS Policies**:
- SELECT: All project members (needed to check if time tracking is enabled)
- INSERT/UPDATE/DELETE: Project owners and administrators only

### work_types

Classifications for time entries. Multiple per project, ordered by sort_order.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | UUID PK | NO | gen_random_uuid() | Primary key |
| project_id | UUID FK | NO | — | References projects.id |
| name | text | NO | — | Display name (e.g., "Development") |
| description | text | YES | NULL | Optional description |
| is_active | boolean | NO | true | Active/inactive toggle |
| sort_order | integer | NO | 0 | Display order (drag-to-reorder) |
| created_at | timestamptz | NO | now() | Record creation timestamp |
| updated_at | timestamptz | NO | now() | Last modification timestamp |

**Constraints**:
- Unique constraint on (project_id, name) — no duplicate work type names per project
- sort_order is non-negative integer

**RLS Policies**:
- SELECT: All project members
- INSERT/UPDATE/DELETE: Project owners and administrators only

**Default Seed Data** (inserted when time tracking is first enabled):
1. Development (sort_order: 0)
2. Testing (sort_order: 1)
3. Design (sort_order: 2)
4. Documentation (sort_order: 3)

### custom_work_item_attributes

Custom fields for time entry forms. Multiple per project, ordered by sort_order.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | UUID PK | NO | gen_random_uuid() | Primary key |
| project_id | UUID FK | NO | — | References projects.id |
| name | text | NO | — | Display name (e.g., "Client") |
| field_type | text | NO | — | Enum: 'text', 'number', 'date', 'dropdown' |
| is_required | boolean | NO | false | Whether field is mandatory |
| options | jsonb | YES | NULL | Dropdown options array (only for dropdown type) |
| sort_order | integer | NO | 0 | Display order in time logging form |
| created_at | timestamptz | NO | now() | Record creation timestamp |
| updated_at | timestamptz | NO | now() | Last modification timestamp |

**Constraints**:
- Unique constraint on (project_id, name) — no duplicate attribute names per project
- options must be a JSON array of strings when field_type = 'dropdown', NULL otherwise
- field_type must be one of: 'text', 'number', 'date', 'dropdown'

**RLS Policies**:
- SELECT: All project members
- INSERT/UPDATE/DELETE: Project owners and administrators only

### time_entries

Individual time log records. Created by team members when logging time (UI out of scope, but schema defined for completeness).

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | UUID PK | NO | gen_random_uuid() | Primary key |
| task_id | UUID FK | NO | — | References issues.id |
| user_id | UUID FK | NO | — | References users.id |
| work_type_id | UUID FK | YES | NULL | References work_types.id (nullable on delete) |
| duration_minutes | integer | NO | — | Time spent in minutes |
| date | date | NO | — | Date of work |
| comment | text | YES | NULL | Optional description |
| custom_attribute_values | jsonb | YES | NULL | Key-value map of attribute_id → value |
| created_at | timestamptz | NO | now() | Record creation timestamp |
| updated_at | timestamptz | NO | now() | Last modification timestamp |

**Constraints**:
- duration_minutes must be positive (> 0)
- work_type_id SET NULL on delete (FR-016: preserve time entries when work type deleted)
- custom_attribute_values format: `{"attribute_uuid": "value", ...}`

**RLS Policies**:
- SELECT: All project members (for viewing time on tasks)
- INSERT: All project members (for logging time)
- UPDATE: Entry owner or project admin
- DELETE: Entry owner or project admin

## Entity Relationships

```
projects 1──1 time_tracking_configs
    FK: time_tracking_configs.project_id → projects.id

projects 1──N work_types
    FK: work_types.project_id → projects.id

projects 1──N custom_work_item_attributes
    FK: custom_work_item_attributes.project_id → projects.id

issues 1──N time_entries
    FK: time_entries.task_id → issues.id

users 1──N time_entries
    FK: time_entries.user_id → users.id

work_types 1──N time_entries (nullable)
    FK: time_entries.work_type_id → work_types.id
    ON DELETE: SET NULL

custom_fields 1──N time_tracking_configs (nullable, x2)
    FK: time_tracking_configs.estimation_field_id → custom_fields.id
    FK: time_tracking_configs.spent_time_field_id → custom_fields.id
```

## State Transitions

### TimeTrackingConfig

```
[Not Created] ──enable──> [Enabled: true]
[Enabled] ──disable──> [Enabled: false]
[Enabled: false] ──enable──> [Enabled: true]
```

### WorkType

```
[Created] ──deactivate──> [is_active: false]
[Deactivated] ──activate──> [is_active: true]
[Any] ──delete──> [Deleted] (time_entries retain null work_type_id)
```

### CustomWorkItemAttribute

```
[Created] ──edit──> [Updated]
[Any] ──delete──> [Deleted]
```

## Indexes

- `time_tracking_configs_project_id_idx`: B-tree on project_id (unique)
- `work_types_project_id_idx`: B-tree on project_id
- `work_types_sort_order_idx`: B-tree on (project_id, sort_order)
- `custom_work_item_attributes_project_id_idx`: B-tree on project_id
- `custom_work_item_attributes_sort_order_idx`: B-tree on (project_id, sort_order)
- `time_entries_task_id_idx`: B-tree on task_id
- `time_entries_user_id_idx`: B-tree on user_id
