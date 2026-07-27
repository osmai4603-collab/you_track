# Research: YouTrack Issue Form Rebuild

**Feature**: 001-youtrack-issue-form
**Date**: 2026-07-27

## Research Tasks

### R1: Fleather Integration Patterns

**Decision**: Reuse the existing Fleather pattern from `knowledge_base` feature.

**Rationale**: The project already has `fleather: ^1.0.0` and uses it in `article_editor_widget.dart` with `FleatherToolbar.basic()` and `FleatherEditor`. The `ParchmentController` in `lib/core/services/parchment_controller.dart` extends `FleatherController`. This proven pattern should be replicated for the issue form.

**Alternatives considered**:
- Custom rich text editor: Rejected — unnecessary when Fleather is already integrated
- flutter_quill: Rejected — project already uses Fleather; adding another editor package violates YAGNI

**Key findings**:
- `FleatherToolbar.basic(controller:)` provides all required formatting buttons (bold, italic, strikethrough, quote, code, link, lists, checklist)
- Additional toolbar items (text color, heading dropdown, table, image embed) require custom toolbar buttons
- `FleatherController.document` provides `toPlainText()` for markdown conversion
- The Visual/Markdown toggle requires converting between Parchment document and markdown (fleather supports this via `FleatherController`)

### R2: File Upload via Supabase Storage

**Decision**: Use Supabase Storage with progress tracking via `supabase.storage.from('bucket').uploadBinary()`.

**Rationale**: The project already uses `supabase_flutter: ^2.16.0`. Supabase Storage provides native file upload with progress callbacks. The existing knowledge base feature already handles file uploads through Supabase.

**Alternatives considered**:
- Direct HTTP upload: Rejected — bypasses Supabase governance (Principle III)
- Local-only storage: Rejected — files need to persist across devices

**Key findings**:
- Upload path convention: `issues/{issue_id}/{filename}`
- Progress tracking available via `onUploadProgress` callback
- File size validation should happen client-side before upload (25MB limit)
- Accepted types: PNG, JPG, GIF, WEBP, PDF, DOC, DOCX, TXT, LOG, CSV, ZIP

### R3: Issue Visibility Field Design

**Decision**: Add `visibility` as `List<String>` to Issue entity with values: `['team']`, `['registered']`, or `['user:id1', 'user:id2', ...]`.

**Rationale**: The clarification session determined group-based visibility with three modes. Storing as a JSON array in PostgreSQL aligns with how the knowledge_base feature handles `visibility` (also `List<String>`).

**Alternatives considered**:
- Separate `issue_visibility` table: Rejected — over-normalized for this use case; PostgreSQL JSON handles this well
- Single string field: Rejected — cannot represent "select specific users" list

**Key findings**:
- PostgreSQL `jsonb` column type for `visibility`
- RLS policies must check visibility array against current user
- Default visibility: `['team']` (team members only)

### R4: Form State Management with Cubit

**Decision**: Create `IssueFormCubit` with `IssueFormState` using Equatable.

**Rationale**: Constitution Principle IV specifies Cubit for simple state (form fields). The form has clear field-level change handlers and submission state. The existing `IssuesBloc` handles listing/filtering and should not be mixed with form state.

**Alternatives considered**:
- Extending IssuesBloc: Rejected — mixing concerns; form state is independent of list state
- StatefulWidget only: Rejected — violates Constitution Principle IV for form state

**Key findings**:
- State class should include: summary, description, priority, state, type, assignee, subsystem, fixVersions, fixedInBuild, estimation, spentTime, visibility, attachments, validationErrors, isSubmitting, isEditing
- Cubit methods: updateSummary, updateDescription, updatePriority, updateState, updateType, updateAssignee, updateSubsystem, updateFixVersions, updateFixedInBuild, updateEstimation, updateSpentTime, updateVisibility, addAttachment, removeAttachment, submit, delete
- Validation: summary required (non-empty, max 255 chars)

### R5: Responsive Layout Strategy

**Decision**: Use `LayoutBuilder` to switch between side-by-side (wide) and stacked (narrow) layouts.

**Rationale**: Flutter's `LayoutBuilder` provides breakpoint-based layout switching without external packages. This is the standard Flutter responsive pattern.

**Alternatives considered**:
- `flutter_screenutil`: Rejected — overkill for a single form page
- Separate pages for mobile/desktop: Rejected — doubles maintenance; YAGNI

**Key findings**:
- Breakpoint: 800px width (desktop vs mobile)
- Wide: Row with main content (Expanded) + sidebar (fixed width ~280px)
- Narrow: Column with main content + sidebar below
- Form fills available space (FR-08)

### R6: Migration and RLS Pattern

**Decision**: Follow existing migration naming convention `YYYYMMDDHHMMSS_description.sql` with UUID primary keys and RLS policies.

**Rationale**: The project has 11 existing migrations following this pattern. The knowledge base migration (`20260726000010`) demonstrates the exact RLS pattern needed.

**Alternatives considered**: None — must follow existing conventions (Principle III).

**Key findings**:
- Migration: `20260727000000_add_issue_visibility.sql`
- Add `visibility` column as `jsonb DEFAULT '["team"]'::jsonb`
- Create RLS policy: users can read issues where visibility contains 'team' (and user is in team), 'registered' (and user is authenticated), or specific user ID
- Index on `visibility` for query performance
