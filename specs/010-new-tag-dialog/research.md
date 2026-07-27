# Research: New Tag Dialog

**Feature**: 010-new-tag-dialog
**Date**: 2026-07-26

## Research Tasks

### 1. Tag Entity Data Model

**Decision**: Tag entity with fields for name, owner, permissions, options, and subscriptions.

**Rationale**: The spec defines a rich tag model with permissions (view/use/edit), options (shared, remove on resolution, favorite), and notification subscriptions. This requires a dedicated entity separate from Issue.

**Alternatives considered**:
- Embedding tags as simple strings on issues — Rejected: insufficient for permissions and subscriptions
- Using a generic "label" entity — Rejected: tags have specific behavioral attributes (remove on resolution, subscriptions)

### 2. Permission Model Architecture

**Decision**: Hybrid permission model with role-based (Owner, Admin, Developer, Viewer) and user-based (All Members, Specific Users) options per permission type (view/use/edit).

**Rationale**: Clarification session confirmed hybrid model. Each permission type (view, use, edit) independently selects from the combined set of role-based and user-based options.

**Alternatives considered**:
- Role-only permissions — Rejected: doesn't support "Specific Users" requirement
- User-only permissions — Rejected: too granular for most use cases

### 3. Tag-Issue Association

**Decision**: Many-to-many relationship between Tags and Issues. Creating a tag from the issue form auto-associates it with that issue.

**Rationale**: Clarification session confirmed tags must be associated with the current issue. Tags can be reused across issues (many-to-many), but creation from issue form creates the association automatically.

**Alternatives considered**:
- One-to-many (tag belongs to one issue) — Rejected: tags should be reusable
- Tag creation independent of issues — Rejected: spec requires auto-association

### 4. State Management Pattern

**Decision**: Use Cubit pattern (consistent with existing `IssueFormCubit`).

**Rationale**: Project already uses `flutter_bloc` with Cubit pattern for form state management. The `IssueFormCubit` demonstrates the established pattern: state class with `copyWith`, `Equatable` for comparison, and `canSubmit`/`isSubmitting` flags.

**Alternatives considered**:
- Riverpod — Rejected: project uses flutter_bloc
- Provider — Rejected: project uses flutter_bloc

### 5. Dialog Presentation Pattern

**Decision**: Use `showDialog` with `AlertDialog` or custom `Dialog` widget, following the modal pattern used in `issue_form_sidebar.dart` (which uses `showModalBottomSheet` for pickers).

**Rationale**: The spec requires a modal dialog. The project already uses modal presentations for pickers. A full dialog (not bottom sheet) is appropriate for the form complexity.

**Alternatives considered**:
- Bottom sheet — Rejected: spec explicitly says "modal dialog"
- Separate page/route — Rejected: spec says "modal overlay, not a separate page"

### 6. Skeleton/Shimmer Loading State

**Decision**: Implement a simple skeleton widget using `Container` with `LinearGradient` shimmer effect, or use existing `shimmer` package if already in dependencies.

**Rationale**: FR-006 requires skeleton/shimmer placeholder for Owner dropdown while project members load. Check existing dependencies — `shimmer` package not in pubspec.yaml, so implement inline or add dependency.

**Alternatives considered**:
- CircularProgressIndicator — Rejected: clarification confirmed skeleton/shimmer
- Text placeholder ("Loading...") — Rejected: clarification confirmed skeleton/shimmer

### 7. Specific Users Picker

**Decision**: Secondary `showDialog` with `StatefulWidget` containing a searchable list of project members with checkboxes for multi-selection.

**Rationale**: FR-007a requires a secondary multi-select picker dialog when "Specific Users" is selected. This follows the pattern of nested modals common in Flutter.

**Alternatives considered**:
- Bottom sheet — Rejected: multi-select with search works better in a full dialog
- Inline expansion — Rejected: would make the main dialog too complex

### 8. Supabase Integration

**Decision**: Create tags table in Supabase with RLS policies. Use `supabase_flutter` client for CRUD operations.

**Rationale**: Project uses Supabase for all backend operations. Tags need their own table with proper relationships to Issues and Users.

**Alternatives considered**:
- Firebase — Rejected: project uses Supabase
- Local-only storage — Rejected: tags need to sync across devices

### 9. Validation Strategy

**Decision**: Client-side validation for empty name and character limit; server-side (Supabase) validation for uniqueness.

**Rationale**: FR-013, FR-014 require empty and uniqueness checks. Client-side provides instant feedback; server-side ensures data integrity.

**Alternatives considered**:
- Client-only validation — Rejected: can't guarantee uniqueness
- Server-only validation — Rejected: poor UX (no instant feedback)

### 10. Notification Subscription Events

**Decision**: Store selected events as a list of enum values on the Tag entity. Events: Updates, Comments, Tag added, Spent time, Issue resolved, Votes, Tag removed.

**Rationale**: FR-010 defines 7 specific notification events. These are stored as a list on the tag and used to trigger notifications when the corresponding events occur on issues with this tag.

**Alternatives considered**:
- Separate subscription table — Rejected: over-engineered for this scope
- Boolean flags per event — Rejected: less flexible than a list

## Dependencies to Add

| Package | Purpose | Required? |
|---------|---------|-----------|
| shimmer | Skeleton/shimmer loading effect | Optional (can implement inline) |

## Technical Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Nested dialogs (Specific Users picker) | Medium | Use `Navigator.pop` carefully; test dialog stack |
| Tag uniqueness validation timing | Low | Debounce input; validate on submit |
| Permission model complexity | Medium | Keep dropdown options simple; defer "Specific Users" UI to separate task |
