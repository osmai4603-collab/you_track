# Quickstart Validation Guide: Time Tracking Settings

**Date**: 2026-07-26
**Feature**: 008-time-tracking-settings

## Prerequisites

- Flutter project builds and runs successfully
- Supabase backend is configured with the 4 new tables (see data-model.md)
- User is authenticated as a project owner or administrator
- At least one project exists with custom fields of "Period" type

## Validation Scenarios

### Scenario 1: Toggle Time Tracking ON/OFF

1. Navigate to Project Settings → Time Tracking
2. **Verify**: Toggle switch labeled "Time Tracking" is visible at top
3. Toggle ON
4. **Verify**: All configuration sections appear (Field Configuration, Aggregation, Work Types, Custom Attributes)
5. Toggle OFF
6. **Verify**: Confirmation dialog appears with warning
7. Confirm disable
8. **Verify**: All sections hide; page shows only the toggle in OFF state

### Scenario 2: Configure Field Mapping

1. Ensure time tracking is ON
2. Open "Estimation Field" dropdown
3. **Verify**: List shows available Period-type fields
4. Select a field
5. Open "Spent Time Field" dropdown
6. **Verify**: List shows available Period-type fields (excluding the one selected for Estimation)
7. Select a different field
8. Click Save
9. **Verify**: Success snackbar appears
10. Reload page
11. **Verify**: Both fields are still selected

### Scenario 3: Inline Field Creation

1. Ensure time tracking is ON with no Period-type fields in the project
2. Open "Estimation Field" dropdown
3. **Verify**: "Add Estimation Field" option is visible
4. Click "Add Estimation Field"
5. **Verify**: A form/dialog appears for creating a new Period-type field
6. Complete creation
7. **Verify**: The new field is auto-selected in the dropdown

### Scenario 4: Subtask Aggregation

1. Ensure time tracking is ON
2. Toggle "Aggregate Spent Time from Subtasks" ON
3. Toggle "Aggregate Estimation from Subtasks" ON
4. Click Save
5. **Verify**: Both toggles persist after reload
6. Toggle both OFF, Save, verify persistence

### Scenario 5: Work Type CRUD + Reorder

1. Ensure time tracking is ON
2. **Verify**: Default work types are listed (Development, Testing, Design, Documentation)
3. Click "Add Work Type"
4. Enter name "Code Review" and description
5. Click Save
6. **Verify**: "Code Review" appears in the list
7. Click edit on "Code Review"
8. Change name to "Code Review & Approval"
9. **Verify**: Updated name reflected in list
10. Drag "Code Review & Approval" to the top of the list
11. **Verify**: Order is updated
12. Click delete on "Code Review & Approval"
13. **Verify**: Confirmation dialog appears
14. Confirm deletion
15. **Verify**: Work type removed from list
16. Save all changes, reload
17. **Verify**: Order and deletions persist

### Scenario 6: Custom Attribute CRUD

1. Ensure time tracking is ON
2. Click "Add Custom Attribute"
3. Create a text attribute "Client Name" (required)
4. **Verify**: Attribute appears in list with "required" badge
5. Create a dropdown attribute "Billing Category" with options ["Billable", "Non-Billable", "Internal"]
6. **Verify**: Attribute appears in list with dropdown type indicator
7. Edit "Client Name" to optional
8. **Verify**: Required badge removed
9. Delete "Billing Category"
10. **Verify**: Confirmation dialog, attribute removed
11. Save, reload, verify persistence

### Scenario 7: Save/Discard Flow

1. Make changes to multiple settings (toggle aggregation, add a work type)
2. **Verify**: Save and Discard buttons become enabled
3. Click Discard
4. **Verify**: Confirmation dialog appears
5. Confirm discard
6. **Verify**: All changes reverted to last saved state
7. Make changes again, click Save
8. **Verify**: Success snackbar, changes persist after reload

### Scenario 8: Error Handling

1. Disconnect from network (or simulate backend failure)
2. Make a change and click Save
3. **Verify**: Error snackbar appears with "Retry" button
4. **Verify**: Unsaved changes remain in the form (not lost)
5. Reconnect and click Retry
6. **Verify**: Save succeeds, success snackbar shown

### Scenario 9: Concurrent Edit Detection

1. Open Time Tracking settings in Browser A
2. Open same page in Browser B
3. In Browser B, change a setting and Save
4. In Browser A, make a different change and click Save
5. **Verify**: Warning banner appears indicating settings were modified by another admin
6. **Verify**: Reload option is provided

### Scenario 10: Admin-Only Access

1. Log in as a non-admin project member
2. Navigate to project settings
3. **Verify**: Time Tracking sidebar item is visible (or hidden based on role)
4. Try to access `/projects/{id}/settings/time` directly
5. **Verify**: Access denied or redirect (consistent with other admin-only settings)
