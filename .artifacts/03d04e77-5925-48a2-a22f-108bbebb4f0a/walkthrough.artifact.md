# Walkthrough - Integrated Project Settings Sub-routes

I have integrated the project settings sub-routes into the application's navigation system. This allows for deep linking into specific settings sections and provides a more seamless user experience when switching between sections while keeping the sidebar fixed.

## Changes Made

### 1. Defined Sub-route Constants
Updated [AppRouteKeys](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/constants/app_route_keys.dart) with specific keys for each settings section (e.g., `general`, `people`, `notifications`) and a helper method `projectSettingsSectionPath` to construct the full dynamic URL.

### 2. Implemented ShellRoute in NavigationService
Refactored [NavigationService](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/services/navigation_service.dart) to use a `ShellRoute` for the project settings path.
- The `ShellRoute` wraps all sub-routes with the `ProjectSettingsPage`.
- Added individual `GoRoute` definitions for all sections.
- Implemented a redirect from `/settings` to `/settings/general` for a better default landing.

### 3. Dynamic Page Content and Selection
Updated [ProjectSettingsPage](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/pages/project_settings_page.dart):
- Added a `child` parameter to the constructor to render the active section's content.
- Implemented `_getSelectedIndex` to automatically determine which sidebar item should be highlighted based on the current URL.

### 4. Linked Sidebar to New Routes
Updated [ProjectSettingsSidebar](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/widgets/project_settings_sidebar.dart) `onTap` handlers to navigate to the new specific section paths using the construction helper.

## Verification
- Navigating to `/projects/:id/settings` correctly redirects to `/projects/:id/settings/general`.
- Clicking on "People" correctly updates the URL to `/projects/:id/settings/people` and shows the placeholder content.
- The sidebar correctly highlights the active section based on the URL.
