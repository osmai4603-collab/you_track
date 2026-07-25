# Feature Specification: Project People Settings Redesign

**Feature Name**: project-people-settings-redesign  
**Created**: Sun Jul 26 2026  
**Status**: Draft

## Overview

Redesign the Project People Settings page to match the YouTrack-style team management interface. The page displays a searchable, filterable table of project team members with their roles, an "Other People with Access" section for registered users, and supports role management through dropdown interactions. This page is restricted to Project Admins and System Admins only.

## Clarifications

### Session 2026-07-26

- Q: Who should have access to the People Settings page? → A: Project Admins only
- Q: What should happen when a user clicks on a role chip? → A: Opens a role editor dropdown to assign/remove roles
- Q: Which actions should appear in the member row context menu? → A: Remove member only
- Q: How should the "Other People with Access" section get its data? → A: Filter from existing members list (members with empty roles)
- Q: What should the empty state look like when there are no team members? → A: Illustration graphic with "No team members yet" message

## User Scenarios

### Scenario 1: View Project Team Members
- **Given** the user is on the Project Settings People section
- **When** the page loads
- **Then** they see a header showing "Project Team" with the member count badge, followed by a table listing all team members with their name, email, avatar, and assigned roles

### Scenario 2: Search for Team Members
- **Given** the user is viewing the team members table
- **When** they type into the search/filter bar
- **Then** the table instantly filters to show only members whose name or email matches the search query

### Scenario 3: View Member Role Details
- **Given** a team member row is displayed in the table
- **When** the user observes the roles column
- **Then** each role is shown as a colored, clickable chip with a dropdown arrow indicating the role can be changed

### Scenario 4: Identify Project Owner
- **Given** the project has an assigned owner
- **When** the owner is displayed in the team members table
- **Then** the owner is visually distinguished with a "project owner" badge next to their name

### Scenario 5: View Other People with Access
- **Given** there are registered users with project access but no explicit team role
- **When** the user scrolls below the team members table
- **Then** they see an "Other People with Access" section listing these users with a "None" role indicator

### Scenario 6: View Owner and Team Role Filters
- **Given** the user is on the People settings page
- **When** the page renders
- **Then** the header area shows the project owner name and a "Team roles" dropdown filter to narrow members by role

## Functional Requirements

### FR-000: Access Control
- Only users with "Project Admin" or "System Admin" roles can access this page
- Non-admin users should not see or navigate to this settings section
- If a non-admin user somehow accesses the page, display an access denied message

### FR-001: Search and Filter Bar
- Display a search input field at the top of the page with placeholder text "Search for text or add a filter"
- Include a "+" button on the left side of the search bar for adding filter criteria (placeholder — no action on tap in this iteration)
- Include a search/magnifier icon on the right side of the search bar
- The search bar spans the full width of the content area
- Filtering applies in real-time as the user types

### FR-002: Project Team Header
- Display "Project Team" as the section title with a member count badge (e.g., "2")
- Show the project owner name with an avatar and a dropdown indicator on the right side of the header
- Show "Team roles" with a dropdown filter to filter members by their assigned role

### FR-003: Team Members Table
- Display a table with two columns: "Name" and "Roles"
- Each member row includes:
  - A checkbox on the far left for bulk selection
  - A circular avatar showing the member's initials with a unique background color
  - The member's display name in bold
  - The member's email address below the name in muted text
  - A "project owner" badge next to the name for the project owner
  - Role chips in the Roles column, each displayed as a colored, clickable tag with a dropdown arrow

### FR-004: Role Chips
- Each role is rendered as an individual chip/tag
- Chips use distinct colors based on role type (e.g., "System Admin" in orange/red, "Contributor" in teal/cyan, "Project Admin" in orange)
- Clicking a chip opens a dropdown/popup that allows the admin to assign or remove roles for that member
- The dropdown should list all available roles with checkboxes indicating current assignments
- Multiple roles are displayed horizontally with spacing between chips

### FR-005: Other People with Access Section
- Display a section titled "Other People with Access" below the team members table
- Data is derived by filtering the existing members list to show only members with an empty roles array
- Each user row includes a checkbox, avatar, name, and a "None" role indicator with a dropdown arrow
- The section has its own "Name" and "Roles" column headers matching the team members table

### FR-006: Member Row Actions
- Each member row has a "..." (three dots) context menu button on the far right
- Clicking the context menu reveals a "Remove member" action
- The project owner cannot be removed (context menu disabled or hidden for owner)

## Success Criteria

- The page displays all project team members in a structured table layout matching the YouTrack design
- Search and filter functionality responds within 500 milliseconds as the user types
- Role chips are clearly distinguishable by color and text
- The project owner is visually distinct from other team members
- The "Other People with Access" section clearly separates users without explicit roles from team members
- The page handles 0 team members gracefully with an illustration graphic and "No team members yet" empty state message
- The page handles loading and error states with appropriate visual feedback
- All interactive elements (search, role chips, context menus) provide visual feedback on hover/tap

## Scope Boundaries

### In Scope
- Redesign of the existing `project_people_settings_section.dart` widget
- Display of team members in a table format with search, filters, and role chips
- "Other People with Access" section for non-team users
- Owner identification and visual distinction
- Member count display
- Search/filter functionality

### Out of Scope
- Backend API changes for role assignment or member management
- User invitation flow (handled by separate page)
- Member removal or role change backend operations
- Group-based access management
- Bulk member operations (beyond checkbox selection UI)
- Activity or last-seen indicators

## Assumptions

- The `ProjectMemberEntity` data model already contains all necessary fields (`id`, `name`, `email`, `roles`, `isOwner`, `avatarUrl`)
- The `ProjectMembersCubit` can supply the member list; no new use cases or repository methods are needed for the display layer
- The project owner name is available from `ProjectEntity.owner`
- Registered users with access but no team role can be sourced from a "Registered Users" query or derived from the members list with empty roles
- The existing theme system (AppColorScheme, AppTextTheme, AppRadius, AppSpacing) is reused for consistent styling
- Role colors are determined by predefined mappings within the widget (e.g., "System Admin" = orange, "Contributor" = teal, "Project Admin" = orange)

## Dependencies

- `ProjectDetailsCubit` for project metadata (name, owner, key)
- `ProjectMembersCubit` for team member list data
- `ProjectMemberEntity` data model
- Existing theme constants (`AppRadius`, `AppSpacing`, `AppColorScheme`)
