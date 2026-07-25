# Quickstart Validation Guide: Project People Settings Redesign

**Date**: Sun Jul 26 2026  
**Feature**: 001-project-people-settings

## Prerequisites

- Flutter SDK installed (`flutter --version`)
- Project dependencies installed (`flutter pub get`)
- Supabase local instance running (or mock data configured)

## Validation Scenarios

### V1: Page Renders with Team Members

**Command**: `flutter test test/features/projects/presentation/widgets/settings_sections/project_people_settings_section_test.dart`

**Expected**: Widget test passes. The page displays:
- "Project Team" header with member count badge
- Table with Name and Roles columns
- Member rows showing avatar, name, email, role chips
- Owner badge on the project owner

### V2: Search Filtering Works

**Command**: Same test file (included in test suite)

**Expected**: When search text is entered:
- Members list filters in real-time
- Only members matching name or email are displayed
- Empty search restores full list
- "Other People with Access" section also filters

### V3: Role Chips Are Interactive

**Command**: Same test file

**Expected**: When a role chip is tapped:
- PopupMenuButton opens with available roles
- Checked roles match member's current roles
- Toggling a role updates the chip display

### V4: Context Menu Shows Remove Action

**Command**: Same test file

**Expected**: When "..." button is tapped:
- PopupMenuButton opens with "Remove member" option
- Tapping "Remove member" shows confirmation dialog
- Confirming removes the member from the list
- Owner row does not show context menu (or menu is disabled)

### V5: Empty State Displays

**Command**: Same test file

**Expected**: When no team members exist:
- Large icon illustration is displayed
- "No team members yet" text is shown
- No table headers or rows are rendered

### V6: Access Control Blocks Non-Admins

**Command**: Same test file

**Expected**: When current user is not a Project Admin:
- "Access Denied" message is displayed
- No member table or settings content is shown

### V7: Localization Renders Correctly

**Command**: `flutter test` (full test suite)

**Expected**: No localization errors. All strings resolve via `AppLocalizations`.

## Running All Tests

```bash
flutter test test/features/projects/presentation/widgets/settings_sections/
```

## Manual Verification (Optional)

1. Run the app: `flutter run`
2. Navigate to a project → Settings → People
3. Verify the YouTrack-style layout matches the screenshot
4. Test search, role chips, context menu, empty state
