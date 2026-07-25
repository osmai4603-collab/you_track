# Integrate Project Settings Sub-routes into NavigationService

The goal is to define specific routes for each project settings section (General, People, etc.) in the `NavigationService` and update the UI to handle navigation between these sections using a `ShellRoute`.

## User Review Required

> [!IMPORTANT]
> I will be converting the existing `ProjectSettingsPage` route into a `ShellRoute`. This means the sidebar will remain fixed while the content area on the right updates based on the active sub-route.

## Proposed Changes

### [Core]

#### [MODIFY] [AppRouteKeys](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/constants/app_route_keys.dart)
- Add constants for settings sub-routes:
    - `projectSettingsGeneral`
    - `projectSettingsPeople`
    - `projectSettingsCustomFields`
    - `projectSettingsVersionControl`
    - `projectSettingsNotifications`
    - `projectSettingsBuildServers`
    - `projectSettingsTimeTracking`
    - `projectSettingsWorkflows`
    - `projectSettingsApps`
- Add a helper method `projectSettingsSectionPath(String projectId, String section)` to build dynamic paths.

#### [MODIFY] [NavigationService](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/services/navigation_service.dart)
- Refactor the `settings` route in `_projectsBranch` to be a `ShellRoute`.
- The `builder` will return `ProjectSettingsPage` wrapping the child.
- Define `GoRoute` for each section:
    - `general`, `people`, `custom-fields`, `vcs`, `notifications`, `builds`, `time`, `workflows`, `apps`.
- Initially, these routes will point to simple placeholder widgets until dedicated pages are created.

### [Projects Feature]

#### [MODIFY] [ProjectSettingsPage](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/pages/project_settings_page.dart)
- Update constructor to accept `required Widget child`.
- Replace the static "Settings for project" text with the `child`.
- Add logic to calculate `selectedIndex` based on the current location string to highlight the correct sidebar item.

#### [MODIFY] [ProjectSettingsSidebar](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/widgets/project_settings_sidebar.dart)
- Update `onTap` handlers for all sidebar items to navigate to their respective sub-routes using `AppRouteKeys.projectSettingsSectionPath`.

## Verification Plan

### Manual Verification
- Navigate to Project Settings.
- Click on different sidebar items (General, People, etc.).
- Verify that the URL changes correctly (e.g., `/projects/123/settings/people`).
- Verify that the content area updates with the corresponding placeholder text.
- Verify that the sidebar remains visible and the correct item is highlighted.
