# Quickstart Validation Guide: YouTrack Issue Form Rebuild

**Feature**: 001-youtrack-issue-form
**Date**: 2026-07-27

## Prerequisites

- Flutter SDK ^3.12.2 installed
- Supabase project configured with `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env`
- Run `flutter pub get` to install dependencies
- Run `supabase db push` to apply the visibility migration

## Validation Scenarios

### V1: Create Issue — Happy Path

**Steps**:
1. Navigate to `/issues/new-issue?project=DEM`
2. Type "Login button not responding" in the summary field
3. Type "The login button on the home page does not respond to taps on iOS devices." in the description
4. Select "Bug" from the Type sidebar field
5. Select "Critical" from the Priority sidebar field
6. Click "Create"

**Expected**: Issue is created, user navigates to issue detail view showing the new issue with correct fields.

### V2: Create Issue — Validation Error

**Steps**:
1. Navigate to the issue creation form
2. Leave summary empty
3. Click "Create"

**Expected**: Inline error "Summary is required" appears below the summary field. Form is not submitted.

### V3: Rich Text Editor — Formatting

**Steps**:
1. Open the issue creation form
2. Click in the description area
3. Type "Steps to reproduce"
4. Select the text and click the Bold (B) button
5. Press Enter and type "1. Open the app"
6. Click the Numbered List button
7. Type "2. Tap login"
8. Click the Code (</>) button on some text

**Expected**: Text appears bold, numbered list is created, code formatting is applied. All formatting persists when switching away and back.

### V4: Format Toggle — Visual to Markdown

**Steps**:
1. Open the issue creation form
2. Type "Hello **world**" in Visual mode with bold formatting
3. Switch to Markdown mode

**Expected**: Raw markdown `Hello **world**` is displayed. Switching back to Visual renders the bold formatting again.

### V5: File Attachment — Upload

**Steps**:
1. Open the issue creation form
2. Click "browse" in the attachment zone
3. Select a PNG image under 25 MB
4. Observe upload progress indicator
5. Verify file appears in the attached files list with name and size

**Expected**: File uploads with visible progress, appears in list with remove button.

### V6: File Attachment — Size Limit

**Steps**:
1. Open the issue creation form
2. Try to attach a file larger than 25 MB

**Expected**: Error message "File exceeds 25 MB limit" is shown. File is not uploaded.

### V7: Visibility Configuration

**Steps**:
1. Open the issue creation form
2. Click "Visible to" dropdown in the action bar
3. Select "Registered users"
4. Create the issue
5. Open the issue for editing
6. Verify visibility shows "Registered users"

**Expected**: Visibility setting persists and is displayed correctly.

### V8: Visibility — Select Specific Users

**Steps**:
1. Open the issue creation form
2. Click "Visible to" dropdown
3. Select "Select specific users"
4. A dialog opens with "Project team" and "Registered users" sections
5. Check two users from the list
6. Confirm selection

**Expected**: Dialog closes, visibility shows the selected users count or names.

### V9: Edit Existing Issue

**Steps**:
1. Open an existing issue in edit mode
2. Verify all fields are pre-populated with current values
3. Change the summary to "Updated summary"
4. Change Priority from "Normal" to "Critical"
5. Click "Create" (functions as Update)

**Expected**: Issue is updated, user navigates to detail view showing updated fields.

### V10: Delete Issue

**Steps**:
1. Open an existing issue in edit mode
2. Click the red "Delete" button
3. Confirm deletion in the dialog

**Expected**: Issue is deleted, user navigates back to issues list.

### V11: Cancel Issue Creation

**Steps**:
1. Start creating a new issue, fill in some fields
2. Click "Cancel"

**Expected**: Form closes without saving, user navigates back.

### V12: Responsive Layout

**Steps**:
1. Open the issue form on a wide screen (>800px)
2. Verify sidebar is to the right of the main content
3. Resize window to narrow (<800px)
4. Verify sidebar moves below the main content

**Expected**: Layout adapts correctly at the breakpoint.

### V13: Three-Dot Menu Actions

**Steps**:
1. Open the issue creation form
2. Click the three-dot overflow menu in the top bar
3. Verify "Copy issue link", "Export as markdown", "Create sub-issue" options are visible

**Expected**: Menu shows all three secondary actions.

### V14: Sub-Issue Creation

**Steps**:
1. Open an existing issue in edit mode
2. Click the three-dot menu
3. Select "Create sub-issue"

**Expected**: A new issue form opens with the parent issue pre-linked.

## Running Tests

```bash
# Unit tests for cubit
flutter test test/features/issues/presentation/cubits/issue_form_cubit_test.dart

# Widget tests for form
flutter test test/features/issues/presentation/widgets/issue_form_test.dart

# Domain use case tests
flutter test test/features/issues/domain/usecases/

# All issue feature tests
flutter test test/features/issues/
```

## Running the App

```bash
flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

Navigate to the issues section and tap the "New Issue" button (or use deep link `/issues/new-issue?project=DEM`).
