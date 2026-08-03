# Implementation Plan - Enable Add/Edit Functionality for Issue Form

This plan outlines the steps to activate the `IssueForm` for both adding and editing issues, ensuring data is correctly saved to the Supabase database through the `IssueFormCubit` and `IssuesRepository`.

## User Review Required

> [!IMPORTANT]
> - The form uses `Fleather` for rich text editing. We will save the description as plain text for now.
> - Deletion logic is implemented but requires a confirmation dialog.
> - The `projectKey` is currently defaulted to 'DEM'.
> - **New Fields**: `subsystem`, `fixVersions`, and `fixedInBuild` will be added to the `Issue` entity and database model to ensure full form persistence.
> - **Enums**: `subsystem` will be changed from `String` to `SubsystemEntity`.

## Proposed Changes

### Domain & Data Layer

#### [MODIFY] [issue.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/issue.dart)
- Add `subsystem`, `fixVersions`, and `fixedInBuild` fields to the `Issue` class and its `copyWith` and `props`.

#### [MODIFY] [issue_model.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/issue_model.dart)
- Update `fromJson`, `toJson`, and `fromEntity` to include the new fields.

### Presentation Layer

#### [MODIFY] [issue_form_state.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/issue_form_state.dart)
- Change `subsystem` type to `SubsystemEntity`.
- Ensure all fields are correctly initialized.

#### [MODIFY] [issue_form_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/issue_form_cubit.dart)
- Update `updateSubsystem` to accept `SubsystemEntity`.
- Map all `state` fields (including new ones) to the `Issue` entity in the `submit()` method.

#### [MODIFY] [issue_form_sidebar.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/issue_form_sidebar.dart)
- Implement `_showSubsystemPicker` using `SubsystemEntity.values`.
- Implement placeholders for Assignee, Fix versions, and Fixed in build pickers.

#### [MODIFY] [issue_form.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/pages/issue_form.dart)
- (Already implemented) Load existing issue, sync summary and description controllers.

## Verification Plan

### Manual Verification
1. **Create Issue**: Fill all fields (including sidebar properties) and verify they are saved in Supabase.
2. **Edit Issue**: Verify all fields are correctly pre-populated and updates are persisted.
3. **Delete Issue**: Confirm deletion works as expected.
