# Implementation Plan - Activate Project People Settings Page

The user wants to enable the "People" page within the project settings, which currently displays an "Access Denied" message. This is due to a hardcoded administrative check (`project?.owner == 'admin'`) that fails for most users/projects.

## Proposed Changes

### Project Settings Components

#### [MODIFY] [project_people_settings_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart)
- Remove the hardcoded `isAdmin = project?.owner == 'admin'` check or set it to `true` to allow access to the People settings page.
- This will bypass the `_buildAccessDeniedView` and show the actual members management UI.

#### [MODIFY] [project_time_tracking_settings_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/widgets/settings_sections/project_time_tracking_settings_section.dart)
- Similar to the People section, update the `isAdmin` check to allow access, as it currently uses the same broken placeholder logic.

## Verification Plan

### Manual Verification
1. Navigate to Project Settings -> People.
2. Verify that the members list and management UI are visible instead of the "Access Denied" message.
3. Verify that the "Time Tracking" settings are also accessible if applicable.
