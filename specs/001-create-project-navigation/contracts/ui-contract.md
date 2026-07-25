# Contracts: Create Project Navigation

**Date**: 2026-07-25
**Feature**: 001-create-project-navigation

## UI Contract

This feature has no external API contracts. It is a pure client-side navigation change.

### Navigation Contract

**Trigger**: User taps the "Create Project" button in `YouTrackContentHeader`
**Action**: `context.go('/projects/templates')`
**Expected Result**: `ProjectTemplateSelectionPage` renders inside the projects shell

**Preconditions**:
- User is authenticated
- Current path contains "projects" (header is visible)

**Postconditions**:
- Route changes to `/projects/templates`
- Breadcrumbs update to show "Projects > Select Template"
- `ProjectCreationCubit` is available (provided by shell route)
