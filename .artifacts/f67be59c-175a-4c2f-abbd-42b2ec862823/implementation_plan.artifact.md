# Refactoring Navigation and Implementing YouTrack Shell Header

This plan aims to refactor the application's shell to use `YouTrackShell` instead of `_ShellLayout`, implement a state-managed `YouTrackContentHeader`, and add a clickable `Breadcrumbs` component with hover effects.

## User Review Required

> [!IMPORTANT]
> - The project uses **Supabase** for authentication. We will filter issues based on `supabase.auth.currentUser?.id`.
> - **GoRouter**'s state will be used to dynamically generate breadcrumbs and determine contextual tools.
> - A new `YouTrackShellCubit` will be introduced to manage the shell's state (search, current path, etc.).

## Proposed Changes

### Core & Shell State Management

#### [NEW] [youtrack_shell_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart)
Create a Cubit to manage the state of the YouTrack shell, including:
- Current navigation path.
- Search query for the header.
- Handlers for breadcrumb clicks.

#### [MODIFY] [init_dependencies.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/init_dependencies.dart)
Register `YouTrackShellCubit` in `GetIt`.

---

### UI Components

#### [NEW] [breadcrumbs.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/breadcrumbs.dart)
Implement a `Breadcrumbs` widget that:
- Parses the current URI into clickable segments.
- Handles hover effects: turns red, adds red underline, changes mouse cursor to pointer.

#### [MODIFY] [dashboard_body_header.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/dashboard_body_header.dart)
Implement `YouTrackContentHeader` with two main sections:
- **Section 1 (Issues Chips)**:
    - Filters issues from `IssuesBloc` (reporter == current user).
    - Displays up to 5 chips.
    - Shows `PopupMenuButton` for remaining issues.
    - Conditional visibility based on current path (Projects or Issues).
- **Section 2 (Contextual Tools)**:
    - Displays "Create Project" and search bar if in `/projects`.
    - Displays "New Issue" button if in `/issues`.
    - Integrates the `Breadcrumbs` widget.

#### [MODIFY] [youtrack_shell.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/youtrack_shell.dart)
Update `YouTrackShell` to properly integrate with `StatefulNavigationShell`.

---

### Navigation Refactoring

#### [MODIFY] [navigation_service.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/services/navigation_service.dart)
- Replace `_ShellLayout` with `YouTrackShell`.
- Wrap `YouTrackShell` with `BlocProvider<YouTrackShellCubit>`.

## Verification Plan

### Automated Tests
- N/A (Manual verification on device/emulator is preferred for UI/Navigation changes).

### Manual Verification
1. Navigate through different sidebar sections and verify `YouTrackContentHeader` updates correctly.
2. Check if issues opened by the user appear as chips (max 5) and overflow into the menu.
3. Test Breadcrumbs: hover effects and navigation on click.
4. Verify contextual tools (buttons/search) appear/disappear based on the section.
