# Feature Specification: Projects Supabase Refactor

**Feature Branch**: `002-projects-supabase-refactor`

**Created**: 2026-07-25

**Status**: Draft

**Input**: User description: "refactor projects: every data display must come from supabase"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Projects List Displays Live Data from Supabase (Priority: P1)

As a user, I want the projects list page to show all projects stored in Supabase so that the data I see is always current, persistent, and consistent across devices and sessions.

**Why this priority**: The projects list is the primary entry point for the entire projects feature. Without live data, users see stale hardcoded projects and any new projects they create are lost on restart. This is the foundation that all other project data displays depend on.

**Independent Test**: Can be fully tested by loading the projects list page, verifying the displayed projects match the Supabase database, creating a new project and seeing it appear in the list, and refreshing the app to confirm persistence.

**Acceptance Scenarios**:

1. **Given** the user is on the projects list page, **When** the page loads, **Then** all projects displayed are fetched directly from Supabase and match the data stored in the remote database
2. **Given** the user creates a new project via the create project form, **When** the creation completes, **Then** the new project is stored in Supabase and appears in the projects list without requiring a manual refresh
3. **Given** the user toggles a project's favorite status, **When** the action completes, **Then** the updated favorite status is persisted in Supabase
4. **Given** the user archives or deletes a project, **When** the action completes, **Then** the change is reflected in Supabase and the project list updates accordingly
5. **Given** the user has multiple devices or sessions, **When** they open the projects list on any device, **Then** they see the same projects and project data

---

### User Story 2 - Project Members Are Fetched from Supabase (Priority: P2)

As a user, I want the project members displayed on the project view page and the members management page to come from Supabase so that team membership information is accurate and up to date.

**Why this priority**: Team members are essential for collaboration. Displaying hardcoded members gives a false impression of who has access. This is the second most important data display after the projects list itself.

**Independent Test**: Can be tested by navigating to a project's view page, verifying the members list matches Supabase data, adding a new member, and confirming the member appears in the list and persists after app restart.

**Acceptance Scenarios**:

1. **Given** the user navigates to a project view page, **When** the page loads, **Then** the team members displayed are fetched from Supabase and reflect actual project membership
2. **Given** the user is on the project members management page, **When** they add a new member, **Then** the new member is stored in Supabase and appears in the members list
3. **Given** the user views a project with no members, **When** the page loads, **Then** an appropriate empty state is displayed instead of hardcoded placeholder members

---

### User Story 3 - Project Templates Are Fetched from Supabase (Priority: P3)

As a user, I want the project templates shown during project creation to come from Supabase so that the available templates are consistent and can be managed centrally.

**Why this priority**: Templates provide a streamlined project creation experience. Having them in Supabase allows administrators to add or modify templates without app redeployment. This is lower priority because templates change less frequently than project or member data.

**Independent Test**: Can be tested by navigating to the template selection page, verifying displayed templates match Supabase data, and selecting a template during project creation to confirm its fields are loaded from Supabase.

**Acceptance Scenarios**:

1. **Given** the user is on the template selection page, **When** the page loads, **Then** all available templates are fetched from Supabase and displayed in a grid
2. **Given** the user selects a template, **When** the template details page loads, **Then** the template description and default fields are fetched from Supabase
3. **Given** the user creates a project using a template, **When** the project creation submits, **Then** the template's default configuration is applied to the new project

---

### User Story 4 - Project Details Page Shows Live Data (Priority: P4)

As a user, I want the project details page (with tabbed views for Issues, Boards, etc.) to display data sourced from Supabase rather than local placeholders.

**Why this priority**: The project details page is a secondary view after the project list and project view. It shows tabbed content where issues and boards data should eventually come from their respective Supabase tables. For this refactoring scope, the projects data on this page (project info, tags, drafts, saved searches) must come from Supabase.

**Independent Test**: Can be tested by navigating to a project details page and verifying that project information, tags, and sidebar content are fetched from Supabase.

**Acceptance Scenarios**:

1. **Given** the user navigates to a project details page, **When** the page loads, **Then** the project information displayed (name, key, description) is fetched from Supabase
2. **Given** the user views the project details sidebar, **When** the page loads, **Then** tags and saved searches (if displayed) are fetched from Supabase

---

### Edge Cases

- What happens when Supabase is unreachable or returns an error? The system MUST display a user-friendly error message with an option to retry, and MUST NOT fall back to hardcoded or cached data that could be stale
- What happens when a user creates a project but the Supabase write fails? The system MUST display an error message and MUST NOT add the project to the local display
- What happens when the user navigates to a project that was deleted by another user? The system MUST display a "project not found" message and redirect to the projects list
- What happens when Supabase returns an empty projects table? The system MUST display an appropriate empty state (e.g., "No projects yet. Create your first project.")
- What happens when a member is removed from a project by another user? The system MUST reflect the updated member list on the next data fetch
- What happens when the user has no internet connectivity? The system MUST display a network error state rather than showing stale or mock data

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The projects list page MUST fetch all projects from Supabase and display them, replacing all hardcoded/mock project data
- **FR-002**: The project view page MUST fetch project members from Supabase and display them, replacing all hardcoded member data that is currently created in the widget's `_initMockData()` method
- **FR-003**: The project template selection page MUST fetch all templates from Supabase and display them, replacing the hardcoded template list
- **FR-004**: The project details page MUST display project information fetched from Supabase, replacing any hardcoded or locally sourced data
- **FR-005**: Creating a new project MUST persist the project to Supabase, and the new project MUST be immediately visible in the projects list
- **FR-006**: Updating a project (name, description, favorite status) MUST persist the change to Supabase and reflect it in the UI
- **FR-007**: Archiving or deleting a project MUST update Supabase and remove the project from the displayed list
- **FR-008**: Adding or removing project members MUST update Supabase and reflect the change in the project view and members management pages
- **FR-009**: All error states (network failure, Supabase errors, empty results) MUST be handled gracefully with user-friendly messages, and the system MUST NOT display hardcoded fallback data
- **FR-010**: The system MUST ensure that the repository layer communicates with a remote data source backed by Supabase for all project-related data operations
- **FR-011**: The data serialization format for models MUST be compatible with Supabase's PostgreSQL column naming conventions (snake_case)
- **FR-012**: The dependency injection setup MUST wire the Supabase client into the projects feature's data source layer

### Key Entities

- **Project**: Represents a workspace for organizing issues; key attributes include id, name, project key, description, owner, creation date, archived status, favorite status, and template reference
- **ProjectMember**: Represents a user's membership in a project; key attributes include id, project reference, user reference, name, email, roles, avatar URL, and owner flag
- **ProjectTemplate**: Represents a reusable project configuration; key attributes include id, name, description, icon, and default fields configuration

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of data displayed in the projects list, project view, project details, and template selection pages comes from Supabase with zero hardcoded or mock data sources
- **SC-002**: Newly created projects persist in Supabase and survive app restart with zero data loss
- **SC-003**: All CRUD operations on projects, members, and templates are reflected in Supabase within 2 seconds of the user action
- **SC-004**: The system displays appropriate error states for all failure scenarios (network, auth, server) without showing stale or placeholder data
- **SC-005**: Users on different devices or sessions see identical project data when connected to the same Supabase instance

## Assumptions

- Supabase is already initialized and configured with anonymous authentication enabled, as confirmed by the existing `main.dart` setup
- Supabase database tables for projects, project members, and project templates either exist or will be created as part of the database schema setup (separate migration work)
- The existing Clean Architecture structure (entities, models, repositories, use cases, cubits) is preserved; this refactoring only changes the data source layer
- The dashboards feature's `DashboardRemoteDataSourceImpl` serves as the established pattern for Supabase remote data sources in this project
- Project model serialization will be updated to use snake_case keys to match Supabase's PostgreSQL naming convention, similar to how `DashboardModel` is structured
- The `SupabaseClient` instance already registered in GetIt will be injected into the new remote data source
- Authentication and authorization logic (who can view/edit projects) is handled at the Supabase Row Level Security level, not in the app code
- The local data source may be retained as a fallback or cache layer, but all primary data displays MUST read from the remote (Supabase) data source
