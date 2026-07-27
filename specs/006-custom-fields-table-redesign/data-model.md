# Data Model: Custom Fields Table Redesign

**Date**: 2026-07-26
**Feature**: 006-custom-fields-table-redesign

## Entities

### CustomField

Represents a custom field configuration in a project.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| id | UUID | Unique identifier | Primary key, auto-generated |
| project_id | UUID | Reference to project | Foreign key, NOT NULL |
| name | TEXT | Field display name | NOT NULL, unique within project |
| field_type | TEXT | Data type of the field | NOT NULL, enum value |
| field_mode | TEXT | Field mode (single/multi) | NOT NULL, default 'single' |
| value_mode | TEXT | Value mode | NOT NULL |
| default_value | TEXT | Default value | Nullable |
| empty_value | TEXT | Empty value display text | Nullable |
| can_be_empty | BOOLEAN | Whether field can be empty | NOT NULL, default true |
| aliases | JSONB | Alternative names | Array of strings |
| visible_to | JSONB | Visibility control | Deprecated, use access_control |
| updatable_by | JSONB | Update permissions | Deprecated, use access_control |
| show_only_when | JSONB | Conditional display rules | Nullable |
| filter_values_based_on | JSONB | Value filtering rules | Nullable |
| order_index | INTEGER | Display order | NOT NULL, auto-incremented |
| visibility | TEXT | Show/hide in issues list | NOT NULL, default 'show' |
| access_control | JSONB | Access control settings | NOT NULL, default '{"type": "everyone"}' |
| created_at | TIMESTAMP | Creation timestamp | NOT NULL, auto-generated |
| updated_at | TIMESTAMP | Last update timestamp | NOT NULL, auto-generated |

**State Transitions**:
- `visibility`: 'show' ↔ 'hide' (toggled by user)
- `access_control.type`: 'everyone' → 'admins_only' → 'custom' (user selects)

---

### CustomFieldValue

Represents a specific value option within a field type (for enum, state, ownedField, version, build types).

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| id | UUID | Unique identifier | Primary key, auto-generated |
| field_id | UUID | Reference to custom_field | Foreign key, NOT NULL |
| value | TEXT | The value string | NOT NULL |
| display_name | TEXT | Display name | Nullable, falls back to value |
| order_index | INTEGER | Display order | NOT NULL, auto-incremented |
| color | TEXT | Color code | Nullable, for state/enum types |
| is_active | BOOLEAN | Whether value is active | NOT NULL, default true |

**Relationships**:
- Many CustomFieldValue → One CustomField

---

### FieldVisibility (Enum)

Controls whether a field appears in issues lists.

| Value | Description |
|-------|-------------|
| show | Field is visible in issues lists |
| hide | Field is hidden from issues lists |

---

### AccessControl

JSON structure for field-level access control.

```json
{
  "type": "everyone" | "admins_only" | "custom",
  "groups": ["group_id_1", "group_id_2"],
  "users": ["user_id_1", "user_id_2"]
}
```

| Type | Description | Additional Fields |
|------|-------------|-------------------|
| everyone | All project members can see the field | None |
| admins_only | Only project admins/owners can see the field | None |
| custom | Specific groups/users can see the field | groups (array of group IDs), users (array of user IDs) |

---

### CustomFieldEnumType (Existing)

Existing enum for field types with display formatting.

| Value | Display Format | Example |
|-------|---------------|---------|
| build | build (single) | "Fixed in build" |
| enumField | enum (single) | "Priority" |
| group | group (single) | "Assignee Group" |
| ownedField | ownedField (single) | "Subsystem" |
| state | state (single) | "State" |
| user | user (single) | "Assignee" |
| version | version (multi) | "Fix versions" |
| date | date | "Due Date" |
| dateTime | date time | "Created At" |
| float | float | "Story Points" |
| integer | integer | "Ideal days" |
| string | string | "Summary" |
| text | text | "Description" |
| period | period | "Estimation" |

---

## Relationships

```text
Project (1) ──── (N) CustomField
CustomField (1) ──── (N) CustomFieldValue
```

## Validation Rules

### CustomField

| Rule | Description |
|------|-------------|
| name_required | Name must not be empty |
| name_unique_per_project | Name must be unique within the same project |
| type_required | Field type must be a valid CustomFieldEnumType value |
| order_index_positive | Order index must be non-negative |
| visibility_valid | Visibility must be 'show' or 'hide' |
| access_control_valid | Access control must have valid type and structure |

### CustomFieldValue

| Rule | Description |
|------|-------------|
| value_required | Value must not be empty |
| value_unique_per_field | Value must be unique within the same field |
| order_index_positive | Order index must be non-negative |

## Supabase Schema Changes

### Migration: Add visibility and access_control columns

```sql
-- Add visibility column
ALTER TABLE custom_fields
ADD COLUMN visibility TEXT NOT NULL DEFAULT 'show'
CHECK (visibility IN ('show', 'hide'));

-- Add access_control column
ALTER TABLE custom_fields
ADD COLUMN access_control JSONB NOT NULL DEFAULT '{"type": "everyone"}';

-- Create index for access_control queries
CREATE INDEX idx_custom_fields_access_control ON custom_fields USING GIN (access_control);
```

### RLS Policy: Field visibility based on access_control

```sql
CREATE POLICY "Users can view custom fields based on access control"
ON custom_fields
FOR SELECT
USING (
  -- Everyone can see
  access_control->>'type' = 'everyone'
  OR
  -- Admins only
  (
    access_control->>'type' = 'admins_only'
    AND EXISTS (
      SELECT 1 FROM project_members
      WHERE user_id = auth.uid()
      AND project_id = custom_fields.project_id
      AND role IN ('owner', 'admin')
    )
  )
  OR
  -- Custom: users directly assigned
  (
    access_control->>'type' = 'custom'
    AND auth.uid() = ANY(
      ARRAY(SELECT jsonb_array_elements_text(access_control->'users'))
    )
  )
  OR
  -- Custom: users in assigned groups
  (
    access_control->>'type' = 'custom'
    AND EXISTS (
      SELECT 1 FROM user_groups_members ugm
      WHERE ugm.group_id = ANY(
        ARRAY(SELECT jsonb_array_elements_text(access_control->'groups'))
      )
      AND ugm.user_id = auth.uid()
    )
  )
);
```
