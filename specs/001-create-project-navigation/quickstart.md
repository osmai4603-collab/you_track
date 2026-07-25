# Quickstart: Create Project Navigation

**Date**: 2026-07-25
**Feature**: 001-create-project-navigation

## Prerequisites

- Flutter SDK installed and on PATH
- Project dependencies installed (`flutter pub get`)
- Supabase local instance or test environment configured (for full integration)

## Validation Scenarios

### Scenario 1: Button Navigation (P1)

**What**: Verify the "Create Project" button navigates to template selection.

**Steps**:
1. Run the app: `flutter run`
2. Navigate to the Projects section via the sidebar
3. Verify the "Create Project" button appears in the header
4. Tap the "Create Project" button

**Expected**: The app navigates to `/projects/templates` and the `ProjectTemplateSelectionPage` renders with a grid of project templates.

### Scenario 2: Full Creation Flow (P1)

**What**: Verify end-to-end project creation from button to form.

**Steps**:
1. Run the app: `flutter run`
2. Navigate to Projects
3. Tap "Create Project"
4. Select a template from the grid
5. Review template details, tap "Use this template"
6. Enter a project name and key on the form page
7. Tap "Create Project"

**Expected**: The project is created, the user is navigated to `/projects/:id/add-members`.

### Scenario 3: Widget Test (P2)

**What**: Automated test for button tap → navigation.

**Command**: `flutter test test/features/dashboards/presentation/widgets/dashboard_body_header_test.dart`

**Expected**: Test passes — button tap triggers navigation to `/projects/templates`.

### Scenario 4: Static Analysis (CI Gate)

**What**: Verify no lint violations.

**Command**: `flutter analyze`

**Expected**: No issues found.
