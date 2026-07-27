# YouTrack-Style Issue Form Rebuild

**Feature**: Issue Form UI Rebuild
**Status**: Draft
**Created**: 2026-07-27

## Overview

Rebuild the issue creation and editing form (`issue_form.dart`) to provide a full-featured, YouTrack-inspired interface. The current implementation only renders a compact fields strip; the rebuilt form must deliver a complete creation/editing experience with a rich text editor, file attachment zone, sidebar properties panel, and action controls.

## User Scenarios & Testing

### Primary User Flows

**Scenario 1: Create a new issue (happy path)**
1. User navigates to the issue creation form
2. User types a summary (title) in the top input field
3. User writes a description using the rich text editor (visual mode)
4. User formats text using toolbar controls (bold, italic, headings, lists, code blocks, etc.)
5. User optionally attaches files via drag-and-drop or file browser
6. User configures issue properties in the right sidebar (priority, state, type, assignee, subsystem, fix versions, estimation)
7. User clicks "Create" to submit the issue
8. System creates the issue and navigates to the issue detail view

**Scenario 2: Create issue with markdown**
1. User switches the format toggle from "Visual" to "Markdown"
2. User writes description using markdown syntax
3. System displays raw markdown text in the editor area
4. User completes creation as in Scenario 1

**Scenario 3: Edit an existing issue**
1. User opens an existing issue in the form
2. Pre-populated fields reflect the current issue data
3. User modifies summary, description, or properties
4. User clicks "Create" (which functions as "Update" in edit mode)
5. System updates the issue

**Scenario 4: Cancel issue creation**
1. User clicks "Cancel" button
2. System discards all changes and navigates back

**Scenario 5: Delete a draft/issue from the form**
1. User clicks "Delete" button (red, visible only in edit mode)
2. System shows a confirmation dialog
3. User confirms deletion
4. System removes the issue and navigates back

**Scenario 6: Configure visibility**
1. User clicks "Visible to" dropdown in the action bar
2. System shows three options: "Team members", "Registered users", "Select specific users"
3. If "Select specific users" is chosen, a user picker dialog opens
4. User selects one or more users/groups
5. Visibility setting is saved with the issue

### Edge Cases

- User submits form with empty summary: system shows inline validation error
- User attaches a file that exceeds maximum size: system shows an error message
- User switches between Visual and Markdown modes with existing content: system preserves content appropriately
- Network error during creation: system shows an error notification and preserves form data
- User tries to delete an issue that doesn't exist: system shows an error

## Functional Requirements

### FR-01: Summary Input Field
- The form displays a prominent, single-line text input at the top labeled "Enter a summary"
- The field accepts free-text input with no formatting
- The field is required; submission is blocked if empty
- Maximum length: 255 characters
- Character count is displayed when approaching the limit

### FR-02: Rich Text Editor - Description Area
- A multi-line rich text editing area is displayed below the summary field
- Placeholder text reads "Type or paste a description..."
- The editor supports the following formatting operations via toolbar:
  - **Text style**: Normal text, Heading 1, Heading 2, Heading 3 (dropdown selector)
  - **Bold** (B): Toggle bold formatting on selected text
  - **Italic** (I): Toggle italic formatting on selected text
  - **Strikethrough** (S): Toggle strikethrough on selected text
  - **Text color** (A): Open a color picker to change text color of selected text
  - **Quote** ("): Wrap selected text/paragraph in a blockquote
  - **Code** (</>): Wrap selected text in inline code or selected block in a code block
  - **Link** (Link icon): Insert a hyperlink on selected text via a URL input dialog
  - **Bulleted list**: Toggle unordered list formatting
  - **Numbered list**: Toggle ordered list formatting
  - **Checklist**: Toggle checkbox list items
  - **Table**: Insert a table grid (with row/column count selector)
  - **Image/File embed**: Insert an image or file inline within the description text

### FR-03: Format Toggle (Visual / Markdown)
- A toggle control allows switching between "Visual" (WYSIWYG) and "Markdown" (raw text) modes
- In Visual mode, the editor renders formatted content in real-time
- In Markdown mode, the editor displays raw markdown source text
- Switching from Visual to Markdown converts the current formatted content to its markdown representation
- Switching from Markdown to Visual renders the markdown as formatted content
- The current mode is visually indicated on the toggle

### FR-04: File Attachment Zone
- A distinct drop zone area is displayed below the description editor
- Zone displays the text "Click to browse or drag files here"
- Supports drag-and-drop of files from the operating system
- Supports click-to-browse opening a native file picker
- Accepted file types: images (PNG, JPG, GIF, WEBP), documents (PDF, DOC, DOCX, TXT), logs (LOG, CSV), archives (ZIP)
- Maximum file size: 25 MB per file
- Maximum attachments per issue: 10
- Attached files are listed below the drop zone with filename, size, and a remove button
- Upload progress is shown per file

### FR-05: Right Sidebar - Properties Panel
- A sidebar is displayed to the right of the main content area (or below on narrow screens)
- The sidebar contains the following property fields, each rendered as a compact clickable field with a dropdown selector:

  **FR-05a: Project**
  - Displays the current project name and project icon/avatar
  - Read-only in the form (project is set before opening the form)

  **FR-05b: Priority**
  - Shows current priority with a color-coded badge (letter + background color)
  - Options: Show Stopper, Critical, Major, Normal, Minor
  - Default: Normal

  **FR-05c: State**
  - Shows current state with a color-coded badge
  - Options: To Do, In Progress, Done
  - Default: To Do

  **FR-05d: Type**
  - Shows current issue type
  - Options: Bug, Cosmetic, Exception, Feature, Task, Usability Problem, Performance Problem, Epic
  - Default: Task

  **FR-05e: Assignee**
  - Shows current assignee name or "Unassigned"
  - Selector lists project members
  - Default: Unassigned

  **FR-05f: Subsystem**
  - Shows current subsystem or "No Subsystem"
  - Selector lists project subsystems
  - Default: No Subsystem

  **FR-05g: Fix Versions**
  - Shows target fix version or "Unscheduled"
  - Selector lists project versions
  - Default: Unscheduled

  **FR-05h: Fixed in Build**
  - Shows the build where the fix was applied or "Next Build"
  - Default: Next Build

  **FR-05i: Estimation**
  - Shows estimated time or "?" (unspecified)
  - Clicking opens a duration input dialog
  - Default: Unspecified

  **FR-05j: Spent Time**
  - Shows actual time spent or "?" (unspecified)
  - Clicking opens a duration input dialog
  - Default: Unspecified

### FR-06: Action Buttons
- **Create button**: Primary blue button labeled "Create"
  - Includes a dropdown arrow for additional options (e.g., "Create and add another")
  - Submits the form and creates/updates the issue
  - Disabled while form is being submitted
- **Cancel button**: White/outline button labeled "Cancel"
  - Discards changes and navigates back
- **Visible to dropdown**: A dropdown labeled "Visible to"
  - Options: "Team members", "Registered users", "Select specific users"
  - When "Select specific users" is chosen, a dialog opens with a grouped checkbox list: "Project team" section and "Registered users" section, each showing individual users as checkbox ListTiles
  - Default: "Team members"
- **Delete button**: Red text button labeled "Delete"
  - Only visible when editing an existing issue
  - Shows confirmation dialog before deleting

### FR-07: Top Bar Quick Actions
- **Lightbulb icon**: Provides smart suggestions (e.g., auto-fill assignee based on project rules)
- **Paperclip icon**: Quick-access shortcut to open the file attachment picker
- **Mention icon (@)**: Inserts an @-mention and shows a team member picker dropdown
- **Three-dot overflow menu**: Contains secondary actions:
  - "Copy issue link": copies the issue URL to clipboard
  - "Export as markdown": exports the description as markdown text
  - "Create sub-issue": opens a new issue form pre-linked as a child
- **Star icon (0)**: Toggles the issue as a favorite/starred; shows current vote/watcher count

### FR-08: Responsive Layout
- On wide screens (desktop/tablet landscape): main content area (summary + editor + attachments) on the left, properties sidebar on the right
- On narrow screens (mobile/portrait): properties sidebar moves below the main content
- The form fills the available screen space without unnecessary scrolling

### FR-09: Form State Management
- A dedicated `IssueFormCubit` manages all form state (field values, validation errors, submission status, upload progress)
- The cubit holds the current form model and exposes field-level change handlers
- `reporterId` is optional and auto-populated from the current authenticated user; `reporterName` is not used in the form
- Changes are not persisted until the user explicitly clicks "Create"
- If the user navigates away with unsaved changes, a confirmation prompt is shown
- In edit mode, the cubit is initialized with the existing issue data

## Success Criteria

- Users can create a new issue with a formatted description in under 2 minutes
- The rich text editor supports at least 10 distinct formatting operations
- File attachments can be added via drag-and-drop or file picker with visual feedback
- All 10 sidebar property fields are functional with dropdown/duration selectors
- The form layout adapts correctly to both wide (desktop) and narrow (mobile) screens
- Form validation prevents submission with an empty summary
- Switching between Visual and Markdown modes preserves content without data loss
- The form integrates with the existing BLoC architecture and Issue entity model
- Users report the form feels consistent with the YouTrack visual style

## Key Entities

| Entity | Description |
|--------|-------------|
| Issue | The core domain entity being created/edited; has 25+ fields including title, description, state, priority, type, assignee, time tracking, etc. Requires a new `visibility` field for group-based access control. |
| IssueStateEnum | Sealed class with 3 states: toDo, inProgress, done |
| IssuePriority | Enhanced enum with 5 levels: showStopper, critical, major, normal, minor |
| IssueTypeEnum | Sealed class with 8 types: bug, cosmetic, exception, feature, task, usabilityProblem, performanceProblem, epic |
| Project | The parent project context; provides project key, name, icon, members, subsystems, versions |

## Clarifications

### Session 2026-07-27

- Q: How should issue visibility be modeled? → A: Group-based visibility with three options: "Team members", "Registered users", or "Select specific users" (individually chosen). Requires adding a `List<String> visibility` field to the Issue entity and a corresponding Supabase schema migration.
- Q: Should the form use a dedicated BLoC/Cubit or extend the existing issues_bloc? → A: New dedicated `IssueFormCubit` for form-specific state (field values, validation, submission, upload progress).
- Q: How should the user picker for "Select specific users" work? → A: A dialog showing a grouped checkbox list with two sections: "Project team" and "Registered users", each listing individual users as checkbox ListTiles.
- Q: How is the reporter determined when creating an issue? → A: `reporterId` is optional (auto-populated from current user if available); `reporterName` is ignored — no reporter field shown in the form UI.
- Q: What actions should the three-dot overflow menu in the top bar contain? → A: Secondary actions: "Copy issue link", "Export as markdown", "Create sub-issue".

## Assumptions

- The Issue entity requires a new `visibility` field (group-based: team members, registered users, or specific users) to support the visibility dropdown
- The project already has the `fleather` package for rich text editing; this will be used as the WYSIWYG editor foundation
- File attachments will be handled through Supabase Storage (already a project dependency)
- The BLoC pattern (already in use) will manage form state and submission
- Localization (ARB files) will be updated for all new UI strings
- The form operates within the existing navigation/routing structure (go_router)
- User/team member data is available through existing project infrastructure
- The "Subsystem" and "Fix Versions" fields are optional project-level configurations; if not configured, these fields show "No Subsystem" / "Unscheduled" as defaults
