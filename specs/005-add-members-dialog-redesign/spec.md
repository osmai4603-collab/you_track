# Feature Specification: Add Members Dialog Redesign

**Feature Name**: add-members-dialog-redesign  
**Created**: Sun Jul 26 2026  
**Status**: Draft

## Overview

Redesign the AddProjectMembersPage dialog to provide a table-based member selection experience. The dialog displays a search field at the top, followed by a card containing a table that lists all available groups and users. Each row in the table includes the member's name/email, an "Add to team" toggle switch, a role selection dropdown, and a remove button. This approach replaces the current overlay-based suggestion system with an always-visible table layout matching YouTrack's team management interface.

## User Scenarios

### Scenario 1: Open Add People Dialog
- **Given** the user is on the project settings or team members page
- **When** they click the "Add People" button
- **Then** a dialog opens with a search field at the top and a card/table below showing all available groups and users

### Scenario 2: Search for Users or Groups
- **Given** the Add People dialog is open
- **When** the user types in the search field
- **Then** the table filters in real-time to show only groups and users matching the search query

### Scenario 3: Add a User to the Team
- **Given** the Add People dialog is open and the user list is displayed
- **When** the user toggles the "Add to team" switch for a user row
- **Then** the toggle turns ON (blue) and the user is marked for addition to the team

### Scenario 4: Remove a User from Selection
- **Given** a user is shown in the table with the "Add to team" toggle ON
- **When** the user clicks the X button on that row
- **Then** the row is removed from the table and the user is no longer selected

### Scenario 5: Assign a Role to a User
- **Given** the Add People dialog is open
- **When** the user clicks the role dropdown for a member row
- **Then** a dropdown menu appears with available roles (e.g., Contributor, Project Admin, System Admin) and the user can select one

### Scenario 6: Add a Group to the Team
- **Given** the Add People dialog is open and groups are displayed
- **When** the user toggles the "Add to team" switch for a group row (e.g., "Registered Users")
- **Then** the toggle turns ON (blue) and the group row is marked for addition
- **Note**: The group is added as a single entity; individual members are resolved by the backend when processing the invitation

### Scenario 7: Cancel the Dialog
- **Given** the Add People dialog is open
- **When** the user clicks the "Cancel" button
- **Then** the dialog closes without adding any members

### Scenario 8: Confirm and Invite
- **Given** the Add People dialog is open and one or more users/groups have their toggles ON
- **When** the user clicks the "Invite" button
- **Then** all selected members are added to the project team and the dialog closes

### Scenario 9: Enter Email to Invite New User
- **Given** the Add People dialog is open
- **When** the user types an email address in the search field and presses Enter or clicks Invite
- **Then** a new user invitation is sent to that email address

### Scenario 10: View License Count
- **Given** the Add People dialog is open
- **When** the dialog renders
- **Then** the bottom of the dialog displays the remaining standard user licenses count

## Functional Requirements

### FR-001: Dialog Layout
- Display a dialog titled "Add People" with a subtitle explaining the purpose
- The dialog contains a search field at the top, a table card in the middle, and action buttons at the bottom
- The dialog has a maximum width of 520px
- The dialog uses the existing `AppRadius.mediumBorderRadius` for rounded corners

### FR-002: Search Field
- Display a text input field with placeholder text "Select users and groups or enter an email address"
- The search field spans the full width of the dialog content area
- Typing in the search field filters the table rows in real-time
- The search field supports email entry for inviting new users not yet in the system

### FR-003: Members Table Card
- Display a card below the search field containing a table
- The table has three column headers: "Name", "Add to team", and "Roles"
- The card has a border and rounded corners matching the dialog style
- The card has a maximum height with vertical scrolling when content exceeds the limit

### FR-004: Table Rows - Users
- Each user row displays:
  - A circular avatar with the user's initials and a unique background color
  - The user's display name
  - The user's email address below the name in muted text
  - A toggle switch in the "Add to team" column
  - A dropdown in the "Roles" column showing the current role assignment
  - An X (remove) button on the far right

### FR-005: Table Rows - Groups
- Each group row displays:
  - A group icon or label in the Name column
  - The group name (e.g., "Registered Users", "All Users")
  - A toggle switch in the "Add to team" column
  - A dropdown in the "Roles" column showing "None" by default
  - An X (remove) button on the far right

### FR-006: Add to Team Toggle
- Display a toggle switch in the "Add to team" column for each row
- The toggle is OFF (grey) by default
- Toggling ON (blue) marks the member for addition to the team
- Toggling OFF removes the member from the selection

### FR-007: Role Selection Dropdown
- Display a dropdown in the "Roles" column for each row
- The dropdown lists available roles: "None", "Contributor", "Project Admin", "System Admin"
- Selecting a role updates the display text for that row
- The default role for new additions is "Contributor"

### FR-008: Remove Button
- Display an X button on the far right of each table row
- Clicking the X button removes that row from the table entirely
- Removed rows can be re-added by searching and selecting again

### FR-009: Action Buttons
- Display an "Invite" button (filled, blue) on the bottom left
- Display an "Cancel" button (outlined) next to the Invite button
- Display the remaining license count on the bottom right (e.g., "Standard user licenses: 8")
- Clicking "Invite" processes all toggled-ON members and closes the dialog
- Clicking "Cancel" closes the dialog without changes

### FR-010: Empty State
- When the search query returns no matching members, display the message "No members found"
- When the table is empty (no groups or users available at all), display the message "No members available to add"
- When typing in the search field with no results, display the message "Type to see more relevant options"

### FR-011: Data Source
- Users are loaded from the existing `ProjectMembersCubit` state (members list)
- Groups are hardcoded as "Registered Users" and "All Users" (same as current implementation)
- The dialog receives the `projectId` to associate added members with the correct project

## Success Criteria

- The dialog displays all available groups and users in a structured table layout matching the YouTrack design
- Search and filter functionality responds within 500 milliseconds as the user types
- Toggle switches clearly indicate ON/OFF state with color change
- Role dropdowns are clearly distinguishable and functional
- The remove (X) button provides immediate visual feedback
- The dialog handles 0 members gracefully with appropriate empty state messaging
- All interactive elements (toggles, dropdowns, buttons) provide visual feedback on hover/tap
- The license count is accurately displayed and updates after successful invite

## Scope Boundaries

### In Scope
- Redesign of the `AddProjectMembersPage` dialog widget
- Table-based layout with columns: Name, Add to team, Roles
- Toggle switch for team membership selection
- Role dropdown for role assignment
- Remove (X) button for row removal
- Search/filter functionality
- Email-based user invitation
- License count display

### Out of Scope
- Backend API changes for member management
- Bulk member operations beyond individual toggles
- Group creation or management
- User invitation email template design
- Activity or last-seen indicators
- Role permission management (assigning what roles can do)

## Assumptions

- The `ProjectMembersCubit` already provides the member list via `state.members`
- The `ProjectMemberEntity` data model contains all necessary fields (`id`, `name`, `email`, `roles`, `avatarUrl`)
- Groups are static ("Registered Users", "All Users") and do not require backend support
- The role list ("None", "Contributor", "Project Admin", "System Admin") is consistent across the application
- The license count can be hardcoded or derived from existing project metadata
- The existing theme system (AppRadius, AppSpacing, AppColorScheme) is reused for consistent styling
- The `AddProjectMemberUseCase` handles the backend operation for adding members

## Dependencies

- `ProjectMembersCubit` for member list data and add member operation
- `ProjectMemberEntity` data model
- `AddProjectMemberUseCase` for backend member addition
- Existing theme constants (`AppRadius`, `AppSpacing`, `AppColorScheme`)
- `AppLocalizations` for translated strings (if applicable)
