# Data Model: New Tag Dialog

**Feature**: 010-new-tag-dialog
**Date**: 2026-07-26

## Entities

### Tag

A label applied to issues for categorization, filtering, and notification subscriptions.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String (UUID) | PK, auto-generated | Unique identifier |
| name | String | NOT NULL, MAX 100 chars, UNIQUE per project | Tag display name |
| owner_id | String (UUID) | FK → User.id, NOT NULL | Tag owner |
| project_id | String (UUID) | FK → Project.id, NOT NULL | Parent project |
| shared | Boolean | NOT NULL, DEFAULT true | Visible to all project members |
| remove_on_resolution | Boolean | NOT NULL, DEFAULT true | Auto-remove from issues when resolved |
| favorite | Boolean | NOT NULL, DEFAULT false | Marked as favorite for all viewers |
| created_at | Timestamp | NOT NULL, DEFAULT now() | Creation timestamp |
| created_by | String (UUID) | FK → User.id, NOT NULL | Creator user |

### TagPermission

Access control settings for a tag. Each tag has three permission records (view, use, edit).

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String (UUID) | PK, auto-generated | Unique identifier |
| tag_id | String (UUID) | FK → Tag.id, NOT NULL | Parent tag |
| permission_type | Enum | NOT NULL, VALUES: view, use, edit | Permission category |
| scope | Enum | NOT NULL, VALUES: owner, admin, developer, viewer, all_members, specific_users | Access scope |
| created_at | Timestamp | NOT NULL, DEFAULT now() | Creation timestamp |

### TagPermissionUser

Specific users granted access when scope = specific_users.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String (UUID) | PK, auto-generated | Unique identifier |
| tag_permission_id | String (UUID) | FK → TagPermission.id, NOT NULL | Parent permission |
| user_id | String (UUID) | FK → User.id, NOT NULL | Granted user |

### TagSubscription

Notification events subscribed to for a tag.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String (UUID) | PK, auto-generated | Unique identifier |
| tag_id | String (UUID) | FK → Tag.id, NOT NULL | Parent tag |
| event_type | Enum | NOT NULL, VALUES: updates, comments, tag_added, spent_time, issue_resolved, votes, tag_removed | Notification event |

### IssueTag (Junction)

Associates tags with issues (many-to-many).

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| issue_id | String (UUID) | FK → Issue.id, PK | Parent issue |
| tag_id | String (UUID) | FK → Tag.id, PK | Associated tag |
| created_at | Timestamp | NOT NULL, DEFAULT now() | Association timestamp |

## Relationships

```
Tag 1 ──── * TagPermission (view/use/edit)
TagPermission 1 ──── * TagPermissionUser (when scope = specific_users)
Tag 1 ──── * TagSubscription
Tag * ──── * Issue (via IssueTag junction)
Tag * ──── 1 User (owner)
Tag * ──── 1 Project
```

## Validation Rules

| Rule | Field | Constraint |
|------|-------|------------|
| V1 | Tag.name | Required, 1-100 characters |
| V2 | Tag.name | Unique within project (case-insensitive) |
| V3 | Tag.owner_id | Must be a valid project member |
| V4 | TagPermission.scope | Required for each permission_type |
| V5 | TagPermissionUser | Required when scope = specific_users |
| V6 | TagSubscription.event_type | Must be one of the 7 defined event types |

## State Transitions

Tags are created and do not change state after creation in this feature. No lifecycle states defined for v1.

## Enums

### TagPermissionType
- `view` — Who can see this tag
- `use` — Who can apply this tag to issues
- `edit` — Who can modify this tag's settings

### TagPermissionScope
- `owner` — Only the tag owner
- `admin` — All admin-role users
- `developer` — All developer-role users
- `viewer` — All viewer-role users
- `all_members` — All project members
- `specific_users` — Selected individual users

### TagSubscriptionEvent
- `updates` — Issue field changes
- `comments` — New comments on tagged issues
- `tag_added` — Tag added to an issue
- `spent_time` — Time logged on tagged issues
- `issue_resolved` — Tagged issue marked resolved
- `votes` — Votes on tagged issues
- `tag_removed` — Tag removed from an issue
