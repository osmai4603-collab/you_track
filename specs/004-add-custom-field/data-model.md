# Data Model: Add Custom Field Page

## Entities

### CustomField
Represents a custom field definition within a project.

**Attributes**:
- `id`: UUID (primary key, auto-generated)
- `projectId`: UUID (foreign key to Project)
- `name`: String (required, 1-100 characters)
- `description`: String (optional, max 500 characters)
- `type`: FieldType enum (required)
- `isPrivate`: Boolean (default: false)
- `createdAt`: Timestamp (auto-generated)
- `updatedAt`: Timestamp (auto-updated)

**Validation Rules**:
- `name`: Must be unique within project, alphanumeric with spaces/hyphens/underscores
- `name`: Cannot be empty, max 100 characters
- `description`: Max 500 characters
- `type`: Must be valid FieldType enum value

**State Transitions**:
- Created → Active (immediate)
- Active → Updated (when modified)
- Active → Deleted (soft delete)

### FieldType
Enum representing allowed custom field types.

**Values**:
- `build`: Build configuration fields
- `enum`: Enumeration fields with predefined options
- `group`: Group/department classification
- `owned-field`: Fields owned by specific users
- `state`: Status/state fields
- `user`: User assignment fields
- `version`: Version/release fields

### Project
Parent entity that contains custom fields.

**Attributes**:
- `id`: UUID (primary key)
- `name`: String
- `customFields`: List<CustomField> (relationship)

**Relationships**:
- One Project has many CustomFields
- CustomField belongs to one Project

## Database Schema (Supabase)

### Tables
```sql
CREATE TABLE custom_fields (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  type VARCHAR(20) NOT NULL CHECK (type IN ('build', 'enum', 'group', 'owned-field', 'state', 'user', 'version')),
  is_private BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(project_id, name)
);

-- Enable RLS
ALTER TABLE custom_fields ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view custom fields in their projects"
  ON custom_fields FOR SELECT
  USING (project_id IN (
    SELECT project_id FROM project_members WHERE user_id = auth.uid()
  ));

CREATE POLICY "Project admins can manage custom fields"
  ON custom_fields FOR ALL
  USING (project_id IN (
    SELECT project_id FROM project_members 
    WHERE user_id = auth.uid() AND role = 'admin'
  ));
```

## Data Validation

### Domain Layer Validation
- Validate field name uniqueness within project
- Validate field name format (alphanumeric, spaces, hyphens, underscores)
- Validate field name length (1-100 characters)
- Validate description length (max 500 characters)
- Validate type is valid FieldType enum

### UI Layer Validation
- Real-time feedback on field name availability
- Character count for name and description
- Visual indicators for valid/invalid states

## Migration Strategy

### Initial Migration
- Create `custom_fields` table with constraints
- Add RLS policies
- Create indexes for performance

### Rollback Strategy
- Drop table if migration fails
- Version control for all schema changes