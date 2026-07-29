# Implementation Plan - Enable Add/Edit Functionality for Issue Form

This plan outlines the steps to activate the `IssueForm` for both adding and editing issues, ensuring data is correctly saved to the Supabase database through the `IssueFormCubit` and `IssuesRepository`.

## User Review Required

> [!IMPORTANT]
> - The form uses `Fleather` for rich text editing. We will save the description as plain text/markdown for now as per the current `IssueModel` structure.
> - Deletion logic is implemented but requires a confirmation dialog (already present in `IssueFormActionBar`).
> - The `projectKey` is currently defaulted to 'DEM'. This should be passed from the navigation context.

## Proposed Changes

### Issue Feature

#### [MODIFY] [issue_form.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/pages/issue_form.dart)
- Implement `initState` logic to load an existing issue if `issueId` is provided.
- Wire `FleatherController` to `IssueFormCubit` to sync description changes.
- Sync `summary` text field with `IssueFormCubit` state for initial values when editing.
- Ensure `IssueFormTopBar` and `IssueFormSidebar` are fully functional and updating the Cubit.

#### [MODIFY] [issue_form_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/issue_form_cubit.dart)
- Ensure all fields are correctly mapped from the state to the `Issue` entity in `submit()`.
- Implement a method to fetch an issue by ID and initialize the state.

#### [MODIFY] [issue_form_top_bar.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/issue_form_top_bar.dart)
- Use a `TextEditingController` for the summary to set its initial value from the Cubit state when editing.

## Verification Plan

### Manual Verification
1. **Create Issue**:
   - Open the form in "Add" mode.
   - Fill in Summary, Description, Priority, and State.
   - Click "Create".
   - Verify the issue appears in the list and is saved in Supabase.
2. **Edit Issue**:
   - Open an existing issue in the form.
   - Verify fields are pre-populated.
   - Change some values (e.g., Priority, Summary).
   - Click "Update".
   - Verify changes are reflected in the list and database.
3. **Delete Issue**:
   - Open an existing issue.
   - Click "Delete" and confirm.
   - Verify the issue is removed.
