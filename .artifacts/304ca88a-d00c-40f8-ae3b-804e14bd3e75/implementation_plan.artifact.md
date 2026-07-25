# Implementation Plan - Project General Settings Section

This plan covers the design and implementation of the "General" settings section for a project, matching the provided design.

## Proposed Changes

### [Projects Feature]

#### [NEW] [project_general_settings_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/presentation/widgets/settings_sections/project_general_settings_section.dart)
- Implement the "General" settings UI:
    - Blue information banner at the top.
    - Project icon and Name input field.
    - Project ID input field with an information tooltip icon.
    - Rich-text style Description field with a placeholder.
    - Visibility settings section (placeholder for now).
- Use `ProjectDetailsCubit` to load and display current project information.
- Use `AppSpacing`, `AppIcons`, and `AppRadius` for consistency.

#### [MODIFY] [navigation_service.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/services/navigation_service.dart)
- Replace the placeholder `Center(child: Text('General Settings'))` with `ProjectGeneralSettingsSection`.

## Verification Plan

### Manual Verification
- Navigate to Project Settings -> General.
- Verify the layout matches the provided image.
- Verify that project name and ID are populated from the Cubit.
- Check the responsive behavior of the form.
