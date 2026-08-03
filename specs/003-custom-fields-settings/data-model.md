# Data Model: Custom Fields Settings

## Overview

Custom fields extend issues with project-specific data. Each project defines its own set of custom fields (name, type, default value, order). Issues can store values for these custom fields.

---

## Entity: CustomFieldEntity

| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier (UUID) |
| projectId | String | Parent project ID |
| name | String | Display name (unique per project) |
| fieldType | CustomFieldType | The type of field (issue-type, priority, state, subsystem) |
| defaultValue | String? | Optional default value (one of the enum values for the type) |
| orderIndex | int | Display order position (0-based) |
| createdAt | DateTime | Creation timestamp |
| updatedAt | DateTime | Last update timestamp |

**Validation rules**:
- `name` MUST be non-empty and unique within the project (FR-015)
- `fieldType` MUST be one of: `issue-type`, `priority`, `state`, `subsystem`
- `defaultValue` MUST be a valid value for the chosen `fieldType` if non-null
- `orderIndex` MUST be a non-negative integer

## Entity: CustomFieldValueEntity

| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier (UUID) |
| issueId | String | Parent issue ID |
| customFieldId | String | Reference to the custom field definition |
| value | String | The selected value |

**Validation rules**:
- `value` MUST be a valid enum value for the referenced custom field's type
- Only ONE value per (issue, customField) pair (UNIQUE constraint)

## Enum: CustomFieldType

```dart
enum CustomFieldType {
  issueType('issue-type', IssueTypeEnum.values),
  priority('priority', IssuePriorityTypeEnum.values),
  state('state', IssueStateEnum.values),
  subsystem('subsystem', SubsystemEntity.values);
}
```

Each type maps to an existing enum in `lib/core/enums/` for available values and display names.

## State Transitions

```
CustomFieldsState:
  initial → loading → loaded(fields) | error(message)
  loaded → adding → loaded (with new field)
  loaded → updating → loaded (with updated field)
  loaded → deleting → loaded (field removed)
  loaded → reordering → loaded (fields reordered)

CustomFieldsCubit events/methods:
  - loadFields(projectId): initial → loaded | error
  - addField(name, type, defaultValue): loaded → adding → loaded
  - updateField(id, name, type, defaultValue): loaded → updating → loaded
  - deleteFields(ids): loaded → deleting → loaded
  - reorderFields(fromIndex, toIndex): loaded → reordering → loaded
```

## Supabase Tables

### `custom_fields`

```sql
CREATE TABLE custom_fields (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  field_type TEXT NOT NULL CHECK (field_type IN ('issue-type', 'priority', 'state', 'subsystem')),
  default_value TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(project_id, name)
);

ALTER TABLE custom_fields ENABLE ROW LEVEL SECURITY;

-- RLS policies (to be refined per access requirements)
CREATE POLICY "Project members can view custom_fields"
  ON custom_fields FOR SELECT
  USING (auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = custom_fields.project_id));

CREATE POLICY "Project admins can manage custom_fields"
  ON custom_fields FOR ALL
  USING (auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = custom_fields.project_id AND 'project-admin' = ANY(roles)));
```

### `custom_field_values`

```sql
CREATE TABLE custom_field_values (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  issue_id UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
  custom_field_id UUID NOT NULL REFERENCES custom_fields(id) ON DELETE RESTRICT,
  value TEXT NOT NULL,
  UNIQUE(issue_id, custom_field_id)
);

ALTER TABLE custom_field_values ENABLE ROW LEVEL SECURITY;
```
