# Quickstart: Add Members Dialog Redesign

**Date**: Sun Jul 26 2026  
**Feature**: 005-add-members-dialog-redesign

## Prerequisites

- Flutter SDK installed and configured
- Project dependencies installed (`flutter pub get`)
- Existing `ProjectMembersCubit` and `AddProjectMemberUseCase` working

## Validation Scenarios

### Scenario 1: Dialog Opens with Table

**Steps**:
1. Navigate to project settings or team members page
2. Click "Add People" button
3. Verify dialog opens with search field and table card

**Expected**:
- Dialog titled "Add People" appears
- Search field with placeholder text visible
- Table card with columns: Name, Add to team, Roles
- Groups (Registered Users, All Users) listed
- Users from project members listed

### Scenario 2: Search Filters Table

**Steps**:
1. Open Add People dialog
2. Type "osmai" in search field

**Expected**:
- Table filters in real-time
- Only rows matching "osmai" displayed
- Groups and users both filtered

### Scenario 3: Toggle Adds User to Team

**Steps**:
1. Open Add People dialog
2. Toggle ON for a user row (e.g., osmai4603)
3. Click "Invite" button

**Expected**:
- Toggle turns blue (ON state)
- User is added to project team
- Dialog closes

### Scenario 4: Role Selection

**Steps**:
1. Open Add People dialog
2. Click role dropdown for a user row
3. Select "Project Admin"

**Expected**:
- Dropdown shows role options
- Selected role displayed in column
- Role saved when Invite clicked

### Scenario 5: Remove Row

**Steps**:
1. Open Add People dialog
2. Click X button on a user row

**Expected**:
- Row removed from table
- User no longer available for selection in this session

### Scenario 6: Cancel Dialog

**Steps**:
1. Open Add People dialog
2. Toggle ON for a user
3. Click "Cancel" button

**Expected**:
- Dialog closes
- No changes made to project members

### Scenario 7: Email Invitation

**Steps**:
1. Open Add People dialog
2. Type "newuser@example.com" in search field
3. Click "Invite"

**Expected**:
- Email recognized as new user
- Invitation sent to email address

## Test Commands

```bash
# Run unit tests
flutter test

# Run widget tests for the dialog
flutter test test/features/projects/presentation/pages/add_project_members_page_test.dart

# Run integration tests
flutter test integration_test/
```

## Expected Test Results

- All existing tests pass
- New widget tests for dialog interactions pass
- No regressions in related features

## Links

- [UI Contract](./contracts/ui-contract.md)
- [Data Model](./data-model.md)
- [Research](./research.md)
