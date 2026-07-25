# Research: Create Project Navigation

**Date**: 2026-07-25
**Feature**: 001-create-project-navigation

## Research Questions

### 1. Where is the "Create Project" button and why is it broken?

**Decision**: The button exists in `lib/features/dashboards/presentation/widgets/dashboard_body_header.dart` (lines 118-122) inside the `_SectionTwo` widget. Its `onPressed` is `() {}` — a no-op.

**Rationale**: The button was moved from `projects_list_page.dart` (where it navigated to `AppRouteKeys.projectTemplates`) to the shared header during a UI refactor. The navigation callback was not carried over.

**Alternatives considered**:
- Restoring the button in `projects_list_page.dart` (commented out at lines 53-85): Rejected because the shared header pattern is already adopted and removing it would regress the UI architecture.

### 2. What route should the button navigate to?

**Decision**: Navigate to `AppRouteKeys.projectTemplates` (`/projects/templates`) — the template selection page.

**Rationale**: This preserves the existing 4-step wizard flow: List → Template Selection → Template Details → Form. The `ProjectCreationCubit` is already provided by the projects `ShellRoute` and manages the entire creation state. The form page (`CreateProjectFormPage`) already works with or without a selected template.

**Alternatives considered**:
- Navigate directly to `AppRouteKeys.createProject` (`/projects/new`): Rejected because it skips the template selection step that's already wired and functional.
- Show a choice dialog: Rejected per YAGNI — the existing wizard flow is sufficient.

### 3. What import is needed?

**Decision**: Import `app_route_keys.dart` into `dashboard_body_header.dart`.

**Rationale**: The file does not currently import `AppRouteKeys`. The navigation call `context.go(AppRouteKeys.projectTemplates)` requires this import.

**Alternatives considered**:
- Hardcode the route string: Rejected — violates the project convention of using `AppRouteKeys` constants (all route strings are centralized there).

### 4. Does the YouTrackShell need to be modified?

**Decision**: No. `YouTrackShell` is a `StatelessWidget` that renders the `YouTrackContentHeader` and `YouTrackSidebar`. The header already conditionally shows project-related UI based on `currentPath.contains('projects')`. No shell changes needed.

**Alternatives considered**:
- Add a new route parameter or cubit method: Rejected — unnecessary complexity for a callback wiring.
