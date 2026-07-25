# Feature Specification: Create Project Navigation

**Feature Branch**: `001-create-project-navigation`

**Created**: 2026-07-25

**Status**: Draft

**Input**: User description: "when user press create project i wanna navigate him to create_project_form_page.dart"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Navigate to Create Project Form (Priority: P1)

As a project administrator, I want to press a "Create Project" button on the projects list page so that I am taken directly to the project creation form where I can enter the project name and key.

**Why this priority**: This is the entry point for the entire project creation flow. Without a visible, accessible button, users cannot create new projects through the UI.

**Independent Test**: Can be fully tested by navigating to the projects list page, locating the "Create Project" button, pressing it, and verifying the create project form page loads with name and key fields.

**Acceptance Scenarios**:

1. **Given** the user is on the projects list page, **When** the user presses the "Create Project" button, **Then** the system navigates to the create project form page displaying fields for project name and project key
2. **Given** the user is on the projects list page, **When** the create project form page loads, **Then** the page displays a breadcrumb trail showing "Projects > Create Project"
3. **Given** the user is on the create project form page, **When** the user presses the "Cancel" button, **Then** the system navigates back to the projects list page

---

### User Story 2 - Form Page Accessible via Direct Navigation (Priority: P2)

As a user, I want the create project form page to be reachable via the `/projects/new` route so that bookmarked or shared links work correctly.

**Why this priority**: Ensures deep-linking and browser back/forward navigation work for the creation flow, improving user experience for power users.

**Independent Test**: Can be tested by navigating directly to `/projects/new` in the browser and verifying the form page loads correctly.

**Acceptance Scenarios**:

1. **Given** the user navigates directly to `/projects/new`, **When** the page loads, **Then** the create project form is displayed with empty name and key fields
2. **Given** the user navigates to `/projects/new` while not authenticated, **When** the page loads, **Then** the system redirects to the login page

---

### Edge Cases

- What happens when the user presses "Create Project" while a project creation is already in progress? The button should be disabled or show a loading indicator to prevent duplicate submissions.
- What happens when the user navigates to `/projects/new` and the `ProjectCreationCubit` is not provided? The system should display an error state or redirect to the projects list.
- What happens when the user presses the browser back button from the form page? The system should return to the projects list without losing any previously entered form data in the cubit state.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The projects list page MUST display a "Create Project" button that is visible and accessible to authorized users
- **FR-002**: Pressing the "Create Project" button MUST navigate the user to the create project form page at `/projects/new`
- **FR-003**: The create project form page MUST display a breadcrumb navigation showing "Projects > Create Project"
- **FR-004**: The create project form page MUST provide a "Cancel" button that returns the user to the projects list page
- **FR-005**: The create project form page MUST display fields for entering a project name and a project key
- **FR-006**: The form MUST auto-generate a project key from the project name when the user types a name, unless the user manually edits the key field
- **FR-007**: The "Create Project" button MUST be disabled while a project creation request is in progress
- **FR-008**: The system MUST display a preview of issue IDs (e.g., "PRJ-1", "PRJ-2") based on the entered project key

### Key Entities

- **Project**: Represents a workspace for organizing issues; key attributes include name (display name) and key (short prefix for issue IDs, e.g., "PRJ")
- **ProjectCreationState**: Tracks the current state of the project creation form including name, key, loading status, and error messages

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can reach the create project form from the projects list page in one tap/click
- **SC-002**: The navigation from button press to form page render completes in under 1 second
- **SC-003**: 100% of users on the projects list page can locate and use the "Create Project" button without confusion
- **SC-004**: The form page correctly displays breadcrumbs and cancel functionality on every load

## Assumptions

- The user is already authenticated and has permission to create projects
- The `ProjectCreationCubit` is provided by the projects shell route and manages form state
- The existing route definition at `/projects/new` is correct and does not need modification
- The existing `CreateProjectFormPage` widget is the correct destination and does not need structural changes
- The projects list page currently has the header section commented out and needs it re-enabled
