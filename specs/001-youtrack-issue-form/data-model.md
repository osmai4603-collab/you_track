# Data Model: YouTrack Issue Form Rebuild

**Feature**: 001-youtrack-issue-form
**Date**: 2026-07-27

## Entities

### Issue (Extended)

The existing `Issue` entity gains a `visibility` field. All other fields remain unchanged.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| id | String (UUID) | auto | Primary key |
| projectKey | String | required | Project identifier (e.g., "DEM") |
| issueNumber | int | auto | Sequential issue number within project |
| title | String | required | Issue summary (max 255 chars) |
| description | String | '' | Rich text description (Parchment JSON or Markdown) |
| state | IssueStateEnum | toDo | Current workflow state |
| priority | IssuePriority | normal | Priority level |
| issueType | IssueTypeEnum | task | Issue category |
| assigneeId | String? | null | Assigned user ID |
| assigneeName | String? | null | Assigned user display name |
| assigneeAvatarUrl | String? | null | Assigned user avatar URL |
| reporterId | String? | null | Reporter user ID (optional, auto-populated) |
| reporterName | String | '' | Reporter display name (ignored in form) |
| tags | List<String> | [] | Issue tags |
| visibility | List<String> | ['team'] | Access control groups/user IDs |
| createdAt | DateTime | now | Creation timestamp |
| updatedAt | DateTime | now | Last modification timestamp |
| dueDate | DateTime? | null | Due date |
| estimation | Duration? | null | Estimated time to complete |
| spentTime | Duration? | null | Actual time spent |
| votes | int | 0 | Upvote count |
| watchersCount | int | 0 | Number of watchers |
| attachmentsCount | int | 0 | Number of attachments |
| commentsCount | int | 0 | Number of comments |
| isStarred | bool | false | Current user's star status |
| parentId | String? | null | Parent issue ID (for sub-issues) |

**Visibility field values**:
- `['team']` — Visible to project team members
- `['registered']` — Visible to all registered users
- `['user:{id1}', 'user:{id2}', ...]` — Visible to specific users only

### IssueFormState (New)

Cubit state class for the form.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| summary | String | '' | Issue title input |
| description | String | '' | Raw description text (markdown or plain) |
| descriptionFormat | DescriptionFormat | visual | 'visual' or 'markdown' |
| priority | IssuePriority | normal | Selected priority |
| state | IssueStateEnum | toDo | Selected state |
| issueType | IssueTypeEnum | task | Selected type |
| assigneeId | String? | null | Selected assignee |
| subsystem | String | '' | Selected subsystem |
| fixVersions | String | '' | Selected fix version |
| fixedInBuild | String | 'Next Build' | Selected build |
| estimation | Duration? | null | Estimated time |
| spentTime | Duration? | null | Time spent |
| visibility | List<String> | ['team'] | Visibility groups/users |
| attachments | List<IssueAttachment> | [] | Pending attachments |
| validationErrors | Map<String, String> | {} | Field-level errors |
| isSubmitting | bool | false | Submission in progress |
| isEditing | bool | false | Edit mode (vs create) |
| issueId | String? | null | Existing issue ID (edit mode) |

### IssueAttachment (New)

Represents a file being uploaded or already attached.

| Field | Type | Description |
|-------|------|-------------|
| id | String | Local temporary ID |
| fileName | String | Original file name |
| fileSize | int | File size in bytes |
| mimeType | String | MIME type |
| uploadProgress | double | 0.0 to 1.0 |
| storagePath | String? | Supabase Storage path (after upload) |
| status | AttachmentStatus | pending, uploading, uploaded, error |

### AttachmentStatus (New Enum)

| Value | Description |
|-------|-------------|
| pending | Not yet uploaded |
| uploading | Upload in progress |
| uploaded | Successfully uploaded |
| error | Upload failed |

### DescriptionFormat (New Enum)

| Value | Description |
|-------|-------------|
| visual | WYSIWYG mode (Fleather) |
| markdown | Raw markdown text mode |

## Relationships

```
Issue (1) ---> (N) IssueAttachment   [via issue ID in storage path]
Issue (N) ---> (1) Project           [via projectKey]
Issue (N) ---> (1) User              [via assigneeId, reporterId]
Issue (N) ---> (N) User              [via visibility user IDs]
Issue (1) ---> (0..1) Issue          [via parentId for sub-issues]
```

## Validation Rules

| Field | Rule | Error Message |
|-------|------|---------------|
| summary | Required, non-empty | "Summary is required" |
| summary | Max 255 characters | "Summary must be 255 characters or less" |
| attachments[].fileSize | Max 25 MB per file | "File exceeds 25 MB limit" |
| attachments | Max 10 files | "Maximum 10 attachments allowed" |
| attachments[].mimeType | Must be in accepted list | "File type not supported" |

## State Transitions

### Issue State Machine (existing)

```
toDo --> inProgress --> done
inProgress --> toDo (reopened)
done --> toDo (reopened)
```

### Form Submission State Machine (new)

```
idle --> validating --> submitting --> success --> (navigate away)
                   \--> validationError (stay on form)
                 \--> submissionError (show error, preserve data)
```

## Database Schema Change

### Migration: `20260727000000_add_issue_visibility.sql`

```sql
-- Add visibility column to issues table
ALTER TABLE issues
ADD COLUMN visibility jsonb DEFAULT '["team"]'::jsonb;

-- Create index for visibility queries
CREATE INDEX idx_issues_visibility ON issues USING gin (visibility);

-- RLS policy for visibility-based access
CREATE POLICY "Users can view issues based on visibility"
  ON issues FOR SELECT
  USING (
    -- Team members can see team-visible issues
    (visibility @> '["team"]'::jsonb AND auth.uid() IN (
      SELECT user_id FROM project_members WHERE project_id = issues.project_key
    ))
    OR
    -- All authenticated users can see registered-visible issues
    (visibility @> '["registered"]'::jsonb AND auth.uid() IS NOT NULL)
    OR
    -- Specific users can see user-targeted issues
    (visibility @> jsonb_build_array('user:' || auth.uid()::text))
    OR
    -- Reporter can always see their own issues
    (reporter_id = auth.uid()::text)
  );
```
