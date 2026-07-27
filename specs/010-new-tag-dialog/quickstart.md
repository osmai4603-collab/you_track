# Quickstart: New Tag Dialog

**Feature**: 010-new-tag-dialog
**Date**: 2026-07-26

## Prerequisites

- Flutter SDK ^3.12.2 installed
- Supabase project configured with `tags`, `tag_permissions`, `tag_subscriptions`, `issue_tags` tables
- Run `flutter pub get` to install dependencies
- Authenticated user with project context active

## Validation Scenarios

### Scenario 1: Create Tag with Defaults

1. Open the issues page
2. Click into an issue to open the form
3. Click the tag input area or "New Tag" button
4. Verify the dialog opens with title "New Tag"
5. Type "bug" in the tag name field
6. Verify "Remove on resolution" is checked
7. Verify "Shared" toggle is on
8. Verify Owner dropdown shows current user
9. Click "Create"
10. Verify dialog closes
11. Verify "bug" tag appears in the issue's tag list

**Expected**: Tag created with default settings, associated with current issue.

### Scenario 2: Create Tag with Custom Permissions

1. Open the New Tag dialog
2. Type "urgent" in the tag name field
3. Change "Can view" dropdown to "All Members"
4. Change "Can edit" dropdown to "Admin"
5. Click "Create"
6. Verify tag is created with the selected permissions

**Expected**: Tag created with custom permission settings.

### Scenario 3: Toggle Options and Subscriptions

1. Open the New Tag dialog
2. Type "review" in the tag name field
3. Uncheck "Remove on resolution"
4. Toggle "Shared" off
5. Check "Mark as favorite for all viewers"
6. Expand "Subscriptions" section
7. Check "Comments" and "Issue resolved"
8. Click "Create"
9. Verify tag is created with all toggled options

**Expected**: All option states preserved on creation.

### Scenario 4: Validation - Empty Name

1. Open the New Tag dialog
2. Leave tag name empty
3. Click "Create"
4. Verify error message appears below the input field
5. Verify dialog does not close

**Expected**: Validation error shown, creation prevented.

### Scenario 5: Validation - Duplicate Name

1. Ensure a tag named "backend" already exists
2. Open the New Tag dialog
3. Type "backend" in the tag name field
4. Click "Create"
5. Verify duplicate name error appears
6. Verify dialog does not close

**Expected**: Uniqueness validation prevents duplicate creation.

### Scenario 6: Cancel Dismisses Dialog

1. Open the New Tag dialog
2. Type "test" in the tag name field
3. Click "Cancel"
4. Verify dialog closes
5. Verify no tag was created

**Expected**: No side effects on cancel.

### Scenario 7: Specific Users Picker

1. Open the New Tag dialog
2. Change "Can view" to "Specific Users"
3. Verify a secondary picker dialog opens
4. Select 2-3 users from the list
5. Confirm selection
6. Verify the picker closes and selections are saved

**Expected**: Multi-select user picker works correctly.

### Scenario 8: Loading State

1. Open the New Tag dialog
2. Observe the Owner dropdown area
3. Verify a skeleton/shimmer placeholder is shown while members load
4. Verify dropdown populates with members after loading

**Expected**: Smooth loading experience without layout jumps.

## Running Tests

```bash
# Unit tests for cubit and use cases
flutter test test/features/issues/presentation/cubits/new_tag_cubit_test.dart
flutter test test/features/issues/domain/usecases/create_tag_test.dart

# Widget tests for dialog
flutter test test/features/issues/presentation/widgets/new_tag_dialog_test.dart

# Integration test
flutter test integration_test/new_tag_dialog_test.dart
```

## Key Files to Verify

- `lib/features/issues/presentation/widgets/new_tag_dialog.dart` — Main dialog widget
- `lib/features/issues/presentation/cubits/new_tag_cubit.dart` — State management
- `lib/features/issues/domain/usecases/create_tag.dart` — Tag creation logic
- `lib/features/issues/data/repositories/tags_repository_impl.dart` — Supabase integration
