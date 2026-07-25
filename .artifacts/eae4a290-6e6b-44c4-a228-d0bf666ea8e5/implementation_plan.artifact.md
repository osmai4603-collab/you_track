# Implementation Plan - Navigation and Search Header Enhancements

The goal is to implement functional navigation for the "Create Project" button and connect the animated search field to the project filtering logic in the shared shell header.

## User Review Required

> [!IMPORTANT]
> - The "Create Project" button will navigate to the **Project Templates Selection** page (`/projects/templates`), which is the standard starting point for project creation.
> - `ProjectsListCubit` will be moved to the root `StatefulShellRoute` provider. This ensures that the shell header (which is shared across multiple pages) can always access the list cubit for searching projects.

## Proposed Changes

### Core Services

#### [MODIFY] [navigation_service.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/services/navigation_service.dart)
- Move `BlocProvider(create: (_) => sl<ProjectsListCubit>())` from `_projectsBranch` to the `MultiBlocProvider` in `StatefulShellRoute.indexedStack`. This allows the header to perform project searches regardless of which specific project page is active.

### Dashboards Feature

#### [MODIFY] [dashboard_body_header.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/dashboard_body_header.dart)
- **Navigation**: Update `_SectionTwo` so that the "Create Project" button calls `context.go(AppRouteKeys.projectTemplates)`.
- **Search Logic**:
    - Update `_SearchField` to accept an `onChanged` callback.
    - In `_SectionTwo`, pass a callback to `_SearchField` that calls `context.read<ProjectsListCubit>().searchProjects(value)`.
- **UI Fix**: Fix the `Theme` access in `_SearchField` (use `Theme.of(context).textTheme` instead of `TextTheme.of(context)` which is invalid).

### Projects Feature

#### [MODIFY] [projects_list_page.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/pages/projects_list_page.dart)
- Remove the commented-out `ProjectsHeader` and local search controller/logic, as these are now fully integrated into the shared shell header.

---

## Verification Plan

### Manual Verification
- **Navigation**: Click "Create Project" in the header and verify it opens the template selection screen.
- **Animation**: Focus the search field and verify it expands smoothly (animation is already implemented, but I'll double-check it works with the new logic).
- **Search**: Type a project name in the header search field while on the Projects list page and verify the list filters in real-time.
- **Unfocus**: Tap away from the search field and verify it shrinks back.
