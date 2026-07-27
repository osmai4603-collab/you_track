# Quickstart: Version Control Settings

**Feature**: 007-version-control-settings
**Date**: 2026-07-26

## Prerequisites

- Flutter project running with Supabase backend
- Supabase migration applied (007_version_control_settings)
- Admin/Owner role in at least one project
- Test VCS provider account (GitHub personal account recommended)

## Validation Scenarios

### Scenario 1: View Empty VCS Settings Page

**Steps**:
1. Navigate to Project Settings → Version Control
2. Verify empty state is displayed with "Connect to Repository" button

**Expected**: Empty state message + CTA button visible, no table rows

---

### Scenario 2: Add GitHub Integration (Token Auth)

**Steps**:
1. Click "Connect to Repository"
2. Select "GitHub" provider card
3. Select "Token" auth mode
4. Enter a valid GitHub Personal Access Token
5. Click "Test Connection" → verify success message
6. Select organization from dropdown
7. Select repository from dropdown
8. Leave branch spec as default (+:*)
9. Enable "Parse commits for commands"
10. Select a group for command executors
11. Click "Save"

**Expected**: Dialog closes, new row appears in table with green "Connected" badge

---

### Scenario 3: Add Custom Git Integration (SSH Auth)

**Steps**:
1. Click "Connect to Repository"
2. Select "Custom Git" provider card
3. Verify Server URL field appears and is required
4. Enter server URL (e.g., `https://git.example.com`)
5. Select "SSH Key" auth mode
6. Verify Token field hides, SSH Key textarea appears
7. Paste SSH private key
8. Enter optional passphrase
9. Click "Test Connection"
10. Enter organization and repository manually (no dropdown for Custom Git)
11. Click "Save"

**Expected**: Integration saved with SSH auth, row shows in table

---

### Scenario 4: Conditional Field Behavior

**Steps**:
1. Open add dialog
2. Select "GitHub" → verify Server URL hidden, OAuth button visible
3. Switch to "Bitbucket Server" → verify Server URL appears (required)
4. Select "Token" auth mode → verify Token field visible, SSH hidden
5. Switch to "SSH Key" → verify Token field hides, SSH fields appear
6. Switch back to "Token" → verify SSH fields hide, Token reappears

**Expected**: Fields show/hide dynamically based on provider and auth mode

---

### Scenario 5: Disable/Enable Integration

**Steps**:
1. Find a connected integration in the table
2. Click the toggle/disable action
3. Verify status changes to "Disabled" (gray badge)
4. Verify commits stop processing (no task updates)
5. Click enable action
6. Verify status returns to "Connected" (green badge)

**Expected**: Toggle works without losing settings

---

### Scenario 6: Delete Integration

**Steps**:
1. Click delete action on an integration
2. Verify confirmation dialog appears
3. Confirm deletion
4. Verify row removed from table

**Expected**: Integration permanently removed

---

### Scenario 7: Commit Parsing (End-to-End)

**Prerequisites**: Integration connected with parse_commits enabled

**Steps**:
1. Push a commit with message: `DEMO-101 #Fixed`
2. Wait for webhook/polling to process
3. Navigate to task DEMO-101
4. Verify status changed to "Fixed"
5. Verify VCS Changes tab shows the commit

**Expected**: Task status updated, commit recorded in history

---

### Scenario 8: PR Automation (End-to-End)

**Prerequisites**: Integration connected with PR automation enabled

**Steps**:
1. Open a PR with title: "DEMO-102 Fix login bug"
2. Wait for webhook to process
3. Navigate to task DEMO-102
4. Verify status changed to "In Review"
5. Merge the PR
6. Verify task status changed to "Merged" or "Fixed"

**Expected**: Task transitions follow PR lifecycle

---

### Scenario 9: User Mapping

**Steps**:
1. Open an integration's settings
2. Navigate to User Mapping section
3. Click "Add Mapping"
4. Enter VCS email: `developer@example.com`
5. Select YouTrack user from dropdown
6. Save mapping
7. Push a commit from that VCS email
8. Verify commit is attributed to the correct YouTrack user

**Expected**: Manual mapping overrides automatic email matching

---

### Scenario 10: Access Control

**Steps**:
1. Log in as a non-admin project member
2. Navigate to Project Settings
3. Verify "Version Control" is either hidden or shows 403
4. Log in as admin
5. Verify full access to VCS settings

**Expected**: Non-admins cannot access VCS configuration

---

### Scenario 11: Connection Test Failure

**Steps**:
1. Open add dialog
2. Enter invalid token
3. Click "Test Connection"
4. Verify loading spinner appears
5. Verify error message displayed (red snackbar)
6. Verify "Save" button remains disabled

**Expected**: Failed test prevents saving, clear error feedback

---

### Scenario 12: Branch Specification

**Steps**:
1. Open add dialog, complete auth
2. Clear default branch spec
3. Type `main` + Enter → token chip created
4. Type `develop` + Enter → second token chip
5. Click X on `develop` chip → removed
6. Save integration

**Expected**: Branch spec stored as `+:refs/heads/main, +:refs/heads/develop`

## Test Commands

```bash
# Run unit tests for VCS feature
flutter test test/features/version_control/

# Run widget tests
flutter test test/features/version_control/presentation/

# Run integration tests
flutter test integration_test/vcs_settings_test.dart

# Run all tests
flutter test
```

## Key Validation Points

| Check | Method |
|-------|--------|
| Table renders correctly | Widget test: verify columns, rows, badges |
| Conditional fields work | Widget test: verify field visibility per provider/auth |
| Connection test | Integration test: mock API, verify loading/success/error states |
| CRUD operations | Unit test: cubit state transitions |
| Encryption | Unit test: encrypt/decrypt roundtrip |
| Branch spec validation | Unit test: regex pattern matching |
| Access control | Integration test: admin vs non-admin navigation |
