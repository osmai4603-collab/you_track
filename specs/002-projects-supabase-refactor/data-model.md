# Data Model: Projects Supabase Refactor

**Feature**: 002-projects-supabase-refactor
**Date**: 2026-07-25

## Entities

### Project

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | uuid | PRIMARY KEY, DEFAULT gen_random_uuid() | Supabase-generated UUID |
| name | text | NOT NULL | Display name of the project |
| project_key | text | NOT NULL, UNIQUE | Short prefix for issue IDs (e.g., "DEMO") |
| description | text | nullable | Free-text project description |
| is_archived | boolean | NOT NULL, DEFAULT false | Soft-delete flag |
| is_template | boolean | NOT NULL, DEFAULT false | Whether this is a template project |
| template_id | text | nullable | FK to project_templates.id (if created from template) |
| owner | text | NOT NULL | User ID of the project owner |
| created_at | timestamptz | NOT NULL, DEFAULT now() | Creation timestamp |
| is_favorite | boolean | NOT NULL, DEFAULT false | Per-user favorite flag (current scope: global) |
| member_initials | jsonb | DEFAULT '[]' | Array of member initial strings for avatar display |

**Relationships**:
- Has many `ProjectMember` (via `project_id` FK)
- Belongs to `ProjectTemplate` (via `template_id` FK, optional)

### ProjectMember

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | uuid | PRIMARY KEY, DEFAULT gen_random_uuid() | Supabase-generated UUID |
| project_id | uuid | NOT NULL, FK → projects.id ON DELETE CASCADE | Parent project |
| name | text | NOT NULL | Display name or initials |
| email | text | NOT NULL | Contact email |
| roles | jsonb | NOT NULL, DEFAULT '[]' | Array of role strings (e.g., ["Project Admin", "Developer"]) |
| avatar_url | text | nullable | URL to avatar image |
| is_owner | boolean | NOT NULL, DEFAULT false | Whether this member owns the project |

**Relationships**:
- Belongs to `Project` (via `project_id` FK)

### ProjectTemplate

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | text | PRIMARY KEY | Human-readable ID (e.g., "scrum", "kanban") |
| name | text | NOT NULL | Display name (e.g., "Scrum") |
| description | text | NOT NULL | Template description |
| icon_key | text | NOT NULL | Icon identifier for UI rendering |
| default_fields | jsonb | NOT NULL, DEFAULT '{}' | Map of field name → default value |

**Relationships**:
- Referenced by `Project` (via `template_id`, optional)

## State Transitions

### Project Lifecycle

```
[Created] → [Active] → [Archived]
                ↓           ↓
           [Updated]    [Deleted]
```

- **Created**: New project inserted into Supabase
- **Active**: Normal operating state, `is_archived = false`
- **Archived**: Soft-deleted, `is_archived = true` (still visible in archive view)
- **Deleted**: Hard-deleted from Supabase (removes row)

## Validation Rules

- `name`: Required, non-empty string
- `project_key`: Required, non-empty, unique across all projects, max 10 characters
- `owner`: Required, must match an authenticated user ID
- `created_at`: Auto-generated, immutable after creation
- `is_archived`: Boolean, defaults to false
- `template_id`: If provided, must reference an existing `project_templates.id`

## Supabase Row Level Security (RLS) Policies

- **projects**: Authenticated users can SELECT all non-archived projects. Only the owner can UPDATE/DELETE. Only authenticated users can INSERT.
- **project_members**: Authenticated users can SELECT members of projects they are members of. Project owners can INSERT/DELETE members.
- **project_templates**: All authenticated users can SELECT. No INSERT/UPDATE/DELETE from app (templates managed via Supabase dashboard or migration).

## Model Serialization Mapping

### ProjectModel — snake_case keys for Supabase

| Dart Field | JSON Key | Dart Type | PostgreSQL Type |
|------------|----------|-----------|-----------------|
| id | id | String | uuid |
| name | name | String | text |
| projectKey | project_key | String | text |
| description | description | String? | text |
| isArchived | is_archived | bool | boolean |
| isTemplate | is_template | bool | boolean |
| templateId | template_id | String? | text |
| owner | owner | String | text |
| createdAt | created_at | DateTime | timestamptz |
| isFavorite | is_favorite | bool | boolean |
| memberInitials | member_initials | List<String> | jsonb |

### ProjectMemberModel — snake_case keys for Supabase

| Dart Field | JSON Key | Dart Type | PostgreSQL Type |
|------------|----------|-----------|-----------------|
| id | id | String | uuid |
| projectId | project_id | String | uuid (FK) |
| name | name | String | text |
| email | email | String | text |
| roles | roles | List<String> | jsonb |
| avatarUrl | avatar_url | String? | text |
| isOwner | is_owner | bool | boolean |

### ProjectTemplateModel — snake_case keys for Supabase

| Dart Field | JSON Key | Dart Type | PostgreSQL Type |
|------------|----------|-----------|-----------------|
| id | id | String | text |
| name | name | String | text |
| description | description | String | text |
| iconKey | icon_key | String | text |
| defaultFields | default_fields | Map<String, String> | jsonb |
