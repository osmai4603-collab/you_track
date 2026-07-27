# Feature Specification: New Tag Dialog

**Feature Branch**: `010-new-tag-dialog`

**Created**: 2026-07-26

**Status**: Draft

**Input**: User description: "A popup card/dialog for creating a new tag within the issues feature, containing header with title and close button, tag name input, permission dropdowns, subscription settings, and action buttons."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create a Tag with Default Settings (Priority: P1)

As any authenticated project member, I want to open the New Tag dialog, enter a tag name, and click Create to quickly add a new tag with sensible defaults, so that I can label and organize issues efficiently.

**Why this priority**: This is the core happy path. Without the ability to create a tag, the feature has no value.

**Independent Test**: Can be fully tested by opening the dialog, entering a name, clicking Create, and verifying the tag is created and appears in the tag list.

**Acceptance Scenarios**:

1. **Given** the user is on the issues page, **When** they click the "New Tag" button, **Then** a modal dialog appears with the title "New Tag", a close button, and a tag name input field.
2. **Given** the dialog is open, **When** the user types a valid tag name and clicks "Create", **Then** the tag is created with default settings (Remove on resolution checked, Shared on, Owner set to current user, all permissions set to Owner).
3. **Given** the tag is successfully created, **When** the creation completes, **Then** the dialog closes, the new tag appears in the tag list, and the tag is automatically associated with the current issue being edited.

---

### User Story 2 - Configure Tag Permissions (Priority: P2)

As a project member, I want to configure who can view, use, and edit a tag when creating it, so that I can control access and ownership of tags.

**Why this priority**: Permission control is essential for multi-user projects but not required for basic tag creation.

**Independent Test**: Can be tested by opening the dialog, changing permission dropdown values, and verifying the tag is created with the selected permissions.

**Acceptance Scenarios**:

1. **Given** the dialog is open, **When** the user clicks the "Owner" dropdown, **Then** a list of project members is displayed for selection.
2. **Given** the dialog is open, **When** the user changes the "Can view", "Can use", or "Can edit" dropdowns, **Then** the selected values are reflected in the dropdowns.
3. **Given** the user has configured permissions, **When** they click "Create", **Then** the tag is created with the specified permission settings.

---

### User Story 3 - Configure Tag Options and Subscriptions (Priority: P2)

As a user, I want to toggle tag options (Remove on resolution, Shared, Favorite) and select which notification events to subscribe to, so that the tag behaves according to my preferences.

**Why this priority**: These options add important customization but are not required for basic tag creation.

**Independent Test**: Can be tested by toggling checkboxes/switches, expanding the Subscriptions section, selecting events, and verifying the tag is created with those settings.

**Acceptance Scenarios**:

1. **Given** the dialog is open, **When** the user toggles the "Shared" switch, **Then** the switch visually reflects the new state (on/off).
2. **Given** the dialog is open, **When** the user checks or unchecks the "Remove on resolution" checkbox, **Then** the checkbox state updates accordingly.
3. **Given** the dialog is open, **When** the user checks the "Mark as favorite for all viewers" checkbox, **Then** the checkbox becomes checked.
4. **Given** the dialog is open, **When** the user clicks the "Subscriptions" section header, **Then** the section expands to show notification event checkboxes.
5. **Given** the Subscriptions section is expanded, **When** the user selects one or more notification events (Updates, Comments, Tag added, Spent time, Issue resolved, Votes, Tag removed), **Then** the selected events are visually marked as checked.
6. **Given** the Subscriptions section is expanded, **When** the user clicks the section header again, **Then** the section collapses and hides the checkboxes.

---

### User Story 4 - Cancel Tag Creation (Priority: P3)

As a user, I want to dismiss the New Tag dialog without creating a tag, so that I can back out of the operation if I change my mind.

**Why this priority**: Basic UX safety net; users expect to be able to cancel any dialog.

**Independent Test**: Can be tested by opening the dialog, entering data, clicking Cancel, and verifying the dialog closes without creating a tag.

**Acceptance Scenarios**:

1. **Given** the dialog is open with unsaved changes, **When** the user clicks the "Cancel" button, **Then** the dialog closes without creating a tag.
2. **Given** the dialog is open, **When** the user clicks the close (X) button in the header, **Then** the dialog closes without creating a tag.
3. **Given** the dialog is open, **When** the user clicks outside the dialog area, **Then** the dialog closes without creating a tag.

---

### Edge Cases

- What happens when the user submits an empty tag name? The system must show a validation error and prevent creation.
- What happens when the user enters a tag name that already exists? The system must show a duplicate name error and prevent creation.
- What happens when the tag name exceeds the maximum allowed length? The system must enforce the character limit and show a helpful message.
- What happens when the Owner dropdown list is empty (no project members)? The system must disable the Create button or show a message indicating at least one member is required.
- What happens when project members are still loading? The Owner dropdown must show a skeleton/shimmer placeholder until data is available.
- What happens when the network is slow or the user clicks Create multiple times rapidly? The system must disable the Create button after the first click to prevent duplicate submissions.
- What happens when the dialog is opened on a small screen? The dialog must be scrollable to access all fields without overflow.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a modal dialog with the title "New Tag" and a close (X) button in the top-right corner.
- **FR-002**: System MUST provide a text input field for the tag name with a visual icon indicator (droplet/picker icon) on the right side.
- **FR-003**: System MUST enforce a maximum character limit on the tag name input field.
- **FR-004**: System MUST display a checkbox labeled "Remove on resolution" (default: checked) with a help icon (?) that shows a tooltip explaining the option on hover.
- **FR-005**: System MUST display a toggle switch labeled "Shared" (default: on/enabled).
- **FR-006**: System MUST provide a dropdown selector for "Owner" populated with current project members only (users who are part of the active project), showing a skeleton/shimmer placeholder while data loads.
- **FR-007**: System MUST provide dropdown selectors for "Can view", "Can use", and "Can edit" with options: Owner, Admin, Developer, Viewer, All Members, Specific Users. All three dropdowns default to "Owner".
- **FR-007a**: When "Specific Users" is selected, System MUST open a secondary multi-select picker dialog to choose individual users.
- **FR-008**: System MUST display a checkbox labeled "Mark as favorite for all viewers" (default: unchecked).
- **FR-009**: System MUST provide a collapsible "Subscriptions" section with a chevron-down indicator that expands to reveal notification event checkboxes.
- **FR-010**: System MUST display checkboxes for notification events: Updates, Comments, Tag added, Spent time, Issue resolved, Votes, Tag removed (all default: unchecked).
- **FR-011**: System MUST provide a primary "Create" button styled with the theme's primary color (supports dark/light mode automatically).
- **FR-012**: System MUST provide a secondary "Cancel" button with outline styling (no filled background).
- **FR-013**: System MUST validate that the tag name is not empty before allowing creation.
- **FR-014**: System MUST validate that the tag name is unique within the project using a 300ms debounce during typing, with final validation on submit.
- **FR-015**: System MUST disable the "Create" button while a tag creation request is in progress to prevent duplicate submissions.
- **FR-016**: System MUST close the dialog when the user clicks the close (X) button, the Cancel button, or outside the dialog.
- **FR-017**: System MUST close the dialog upon successful tag creation.
- **FR-018**: System MUST automatically associate the newly created tag with the current issue being edited.
- **FR-019**: System MUST display validation errors inline below the tag name field when validation fails.
- **FR-020**: System MUST make the dialog scrollable on small screens to ensure all fields remain accessible.
- **FR-021**: System MUST pre-select the current user as Owner by default.

### Key Entities

- **Tag**: A label applied to issues for categorization and filtering. Key attributes: unique identifier, name, owner (user reference), shared status (boolean), remove on resolution (boolean), favorite status (boolean), permission settings (view/use/edit levels), subscription events (list of notification types), project reference, creation timestamp, creator.
- **Permission Level**: An access control setting for a tag. Key attributes: level type (view/use/edit), allowed scope (Owner, Admin, Developer, Viewer, All Members, or Specific Users — hybrid model supporting both role-based and user-based access).

## Success Criteria *(mandatory)*

### Buildable Outcomes (Implementation Phase)

- **SC-002**: The dialog displays all required fields and options without requiring scrolling on screens with 768px height or greater (enforced via MediaQuery/LayoutBuilder).
- **SC-004**: Validation errors for empty or duplicate tag names are displayed within 1 second of submission attempt.
- **SC-006**: Users can dismiss the dialog (Cancel or close button) in under 1 second with no residual state changes.

### Post-Launch Acceptance Criteria (Measured After Deployment)

- **SC-001**: Users can create a new tag with default settings in under 15 seconds (open dialog → type name → click Create).
- **SC-003**: 95% of tag creation attempts succeed on the first try (no validation errors for valid inputs).
- **SC-005**: The dialog opens and renders all interactive elements within 500ms of the user clicking the New Tag button.
- **SC-007**: The Subscriptions section expand/collapse animation completes in under 300ms without visual glitches.

## Assumptions

- Any authenticated project member can create tags; no admin-only restriction applies.
- The user is authenticated and has at least one project context active.
- The current user is automatically set as the tag Owner by default.
- The "Remove on resolution" tooltip text explains that the tag will be automatically removed from issues when they are resolved.
- Permission dropdowns offer role-based options (Owner, Admin, Developer, Viewer) consistent with existing project roles.
- The tag name has a maximum length of 100 characters (standard for tag/label systems).
- The Subscriptions section is collapsed by default to reduce visual clutter.
- The dialog is presented as a modal overlay, not a separate page.
- Tag creation requires network connectivity to persist to the backend.
- The close button (X), Cancel button, and clicking outside the dialog all perform the same dismiss action.
- The "Shared" toggle defaulting to "on" means the tag is visible to all project members by default.

## Clarifications

### Session 2026-07-26

- Q: Who is authorized to create tags — any project member, admins only, or a restricted role? → A: Any authenticated project member can create tags.
- Q: What happens after a tag is created — is it standalone or associated with an issue? → A: The newly created tag is automatically associated with the current issue being edited.
- Q: What permission level options are available in the "Can view", "Can use", "Can edit" dropdowns? → A: Hybrid model — Owner, Admin, Developer, Viewer, All Members, Specific Users.
- Q: What should users see while the Owner dropdown loads project members? → A: Skeleton/shimmer placeholder until data loads.
- Q: When "Specific Users" is selected in a permission dropdown, how do users pick which users? → A: Opens a secondary multi-select picker dialog to choose users.

### Session 2026-07-26 (Analysis Refinements)

- Q: Who can configure tag permissions — admins only or any member? → A: Any project member (not admin-only). Updated US2 actor.
- Q: When does uniqueness validation fire — on submit, on blur, or real-time? → A: Real-time with 300ms debounce during typing, plus final validation on submit. Updated FR-014.
- Q: What color should the Create button use? → A: Theme primary color (supports dark/light mode). Updated FR-011.
- Q: Which users appear in the Owner dropdown? → A: Current project members only. Updated FR-006.
- Q: What are the default values for permission dropdowns? → A: "Owner" for all three (Can view, Can use, Can edit). Updated FR-007.
- Q: Are performance SCs (15s, 500ms, 300ms) buildable requirements? → A: No — moved to Post-Launch Acceptance Criteria. SC-002 (768px) remains buildable.
