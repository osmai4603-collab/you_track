# Quickstart: Projects Supabase Refactor

**Feature**: 002-projects-supabase-refactor
**Date**: 2026-07-25

## Prerequisites

- Flutter SDK installed and configured
- Supabase project with tables created: `projects`, `project_members`, `project_templates`
- Anonymous authentication enabled in Supabase
- App configured with valid Supabase URL and anon key (already in `main.dart`)

## Validation Scenarios

### Scenario 1: Projects List Fetches from Supabase

1. Ensure the `projects` table in Supabase has at least one row
2. Run the app: `flutter run`
3. Navigate to the projects list page (`/projects`)
4. **Expected**: Projects listed match the rows in the Supabase `projects` table (name, key, favorite status)
5. **Verify**: No hardcoded "Demo Project", "fingerprint", or "Test project" appears unless those rows exist in Supabase

### Scenario 2: New Project Persists to Supabase

1. On the projects list page, tap "Create Project"
2. Enter a project name (e.g., "My Test Project") and key (e.g., "MTP")
3. Submit the form
4. **Expected**: The new project appears in the projects list
5. **Verify**: Query the Supabase `projects` table directly — the new row exists with correct values
6. Restart the app and navigate to projects list
7. **Expected**: The project still appears (persisted, not lost on restart)

### Scenario 3: Project Members Come from Supabase

1. Navigate to a project view page (`/projects/:projectId`)
2. **Expected**: The "Team Members" card shows members fetched from the `project_members` table in Supabase
3. **Verify**: If the project has no members in Supabase, an empty state is shown (not hardcoded "Omar Khaled", "Sara Ali", etc.)

### Scenario 4: Template Selection Fetches from Supabase

1. Navigate to project creation and reach the template selection step
2. **Expected**: Templates displayed match the rows in the `project_templates` table in Supabase
3. **Verify**: No hardcoded 8-template grid unless those rows exist in Supabase

### Scenario 5: Error State Display

1. Disconnect from the internet (airplane mode or disable network)
2. Navigate to the projects list page
3. **Expected**: An error message is displayed (e.g., "Network error. Please check your connection.")
4. **Verify**: No hardcoded/mock project data is shown as a fallback

### Scenario 6: Favorite Toggle Persists

1. On the projects list page, tap the favorite star on a project
2. **Expected**: The star toggles state
3. **Verify**: Query the Supabase `projects` table — the `is_favorite` column is updated
4. Restart the app — the favorite state persists

## Run Commands

```bash
# Run the app
flutter run

# Run existing tests
flutter test

# Query Supabase tables directly (via Supabase dashboard or CLI)
# - projects table: verify rows match displayed data
# - project_members table: verify rows match displayed members
# - project_templates table: verify rows match displayed templates
```

## Success Indicators

- All data on the projects list, project view, project details, and template pages matches Supabase tables
- Zero hardcoded or mock data in the UI (no `_initMockData()`, no in-memory lists)
- CRUD operations persist to Supabase and survive app restart
- Error states display for network/auth/server failures
