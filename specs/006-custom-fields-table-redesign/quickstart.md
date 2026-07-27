# Quickstart Validation Guide: Custom Fields Table Redesign

**Date**: 2026-07-26
**Feature**: 006-custom-fields-table-redesign

## Prerequisites

- Flutter SDK installed (3.x)
- Supabase project running locally or in staging
- Database migrations applied (`supabase db reset` or `supabase migration up`)
- Test project with at least one custom field created

## Setup Commands

```bash
# 1. Navigate to project root
cd /home/osmsoftwareengineering/flutter_projects/you_track

# 2. Install dependencies
flutter pub get

# 3. Run code generation (if needed)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Apply database migrations
supabase db reset  # or supabase migration up

# 5. Run the app
flutter run
```

## Validation Scenarios

### Scenario 1: View Custom Fields in Table Layout

**Steps**:
1. Open the app and navigate to a project's Settings > Custom Fields
2. Verify the table displays with columns: checkbox, drag handle, Field in Projects, Type, Default Value(s), Empty Value, Default Visibility

**Expected Outcome**:
- Table loads with all custom fields displayed
- Each row shows: checkbox (unchecked), drag handle icon, field name, formatted type (e.g., "enum (single)"), default value or "—", empty value description, visibility status ("Show" or "Hide")
- Page loads in under 3 seconds for 50+ fields

---

### Scenario 2: Add New Field

**Steps**:
1. Click "Add field to project ..." button
2. Fill in field name (e.g., "Priority")
3. Select field type (e.g., "Enum (single)")
4. Enter default value (e.g., "Normal")
5. Click "Add"

**Expected Outcome**:
- Sliding panel opens
- Field is added to the table
- New row appears at the bottom
- Success confirmation (SnackBar or visual feedback)

---

### Scenario 3: Edit Field

**Steps**:
1. Click on a field name in the table
2. Modify the field name in the dialog
3. Click "Save"

**Expected Outcome**:
- Edit dialog opens with pre-filled values
- Field name is updated in the table
- No data loss for existing issues

---

### Scenario 4: Delete Fields

**Steps**:
1. Select multiple fields using checkboxes
2. Click the delete icon in the toolbar
3. Confirm deletion in the dialog

**Expected Outcome**:
- Confirmation dialog shows count of selected fields
- Fields are removed from the table
- Existing issue data is preserved (fields remain in issues but are hidden from settings)

---

### Scenario 5: Drag-and-Drop Reordering

**Steps**:
1. Long-press the drag handle of a field row
2. Drag to a new position
3. Release

**Expected Outcome**:
- Field moves to new position with animation
- Order is persisted (refresh page to verify)
- Reorder completes in under 2 seconds

---

### Scenario 6: Field Visibility Toggle

**Steps**:
1. Click on "Show" or "Hide" text in the Visibility column
2. Verify the toggle changes

**Expected Outcome**:
- Visibility toggles between "Show" and "Hide"
- Change is persisted
- Field appears/disappears in issues list accordingly

---

### Scenario 7: Show/Hide Details Toggle

**Steps**:
1. Click the "Show details" toggle in the toolbar
2. Verify columns change

**Expected Outcome**:
- When toggled OFF: Empty Value and Visibility columns are hidden
- When toggled ON: Empty Value and Visibility columns are visible
- Toggle state persists during session

---

### Scenario 8: Make Private

**Steps**:
1. Select a field in the table
2. Click "Make private" in the toolbar
3. Select "Custom" option
4. Select a group or user
5. Click "Save"

**Expected Outcome**:
- Make Private dialog opens with overlay
- Radio buttons for Everyone / Admins only / Custom
- When Custom selected, groups and users sections appear with checkboxes
- Access control is saved
- Field visibility in issues list is restricted based on selection

---

### Scenario 9: Replace Field Values

**Steps**:
1. Select a field in the table
2. Click "Replace" in the toolbar
3. Click the PopupButton to see values
4. Select a value from the list

**Expected Outcome**:
- PopupButton opens with TextField at top for filtering
- List of field values is displayed
- Selecting a value closes the popup
- (Full replace functionality may be deferred to later version)

---

### Scenario 10: Empty State

**Steps**:
1. Navigate to a project with no custom fields

**Expected Outcome**:
- Empty state message displayed
- Icon: list_alt_outlined
- Title: "No custom fields yet"
- Description: "Add your first custom field..."
- Button: "Add field to project ..."

---

## Test Commands

```bash
# Run all tests
flutter test

# Run custom fields feature tests
flutter test test/features/custom_fields/

# Run widget tests
flutter test test/features/custom_fields/presentation/

# Run cubit tests
flutter test test/features/custom_fields/presentation/cubits/

# Run with coverage
flutter test --coverage
```

## Database Verification

```sql
-- Verify new columns exist
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'custom_fields'
AND column_name IN ('visibility', 'access_control');

-- Verify RLS policies
SELECT policy_name, qual
FROM pg_policies
WHERE tablename = 'custom_fields';

-- Test access control query
SELECT * FROM custom_fields
WHERE access_control->>'type' = 'everyone';
```
