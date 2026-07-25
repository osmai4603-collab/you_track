# Walkthrough - YouTrack Shell Refactoring

I have successfully refactored the application shell and implemented the contextual header with issue tracking and breadcrumbs.

## Changes Made

### 1. State Management
- Created [youtrack_shell_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart) to manage the shell's active path and search state.
- Registered the Cubit in the dependency injection container ([init_dependencies.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/init_dependencies.dart)).

### 2. Navigation Refactoring
- Replaced the legacy `_ShellLayout` with the new [YouTrackShell](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/youtrack_shell.dart) in [navigation_service.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/services/navigation_service.dart).
- Integrated `MultiBlocProvider` to ensure `DashboardBloc`, `IssuesBloc`, and `YouTrackShellCubit` are available throughout the shell.
- Implemented automatic path synchronization using `addPostFrameCallback` within the shell.

### 3. YouTrack Content Header
- Completely overhauled [dashboard_body_header.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/dashboard_body_header.dart):
    - **Section 1 (User Issues)**: Now filters issues from `IssuesBloc` where the reporter matches the current user. Displays up to 5 chips with a "More" popup menu for overflows.
    - **Section 2 (Contextual Tools)**:
        - Shows "Create Project" and a search bar when in the Projects section.
        - Shows "New Issue" when in the Issues section.
        - Integrated the dynamic Breadcrumbs.

### 4. Breadcrumbs Component
- Implemented [breadcrumbs.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/breadcrumbs.dart) with the requested interactivity:
    - **Hover Effect**: Text turns red with a red underline, and the cursor changes to a pointer.
    - **Navigation**: Each segment is clickable and navigates to its corresponding path using `go_router`.

## How to Verify
1. **Navigate**: Use the sidebar to switch between "Issues" and "Projects". Observe the header changing its buttons and search field.
2. **Issue Chips**: If there are issues where you are the reporter, they will appear as chips at the top of the header.
3. **Breadcrumbs**: Hover over the breadcrumb segments to see the color/underline change, and click them to navigate back up the path hierarchy.
