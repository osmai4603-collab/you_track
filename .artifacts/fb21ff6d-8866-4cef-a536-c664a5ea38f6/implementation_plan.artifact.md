# Implementation Plan - Verify and Fix Issues Data Fetching and Display

The goal is to ensure that data is correctly fetched from the SQLite database and displayed on the `IssuesPage`, handling both project-specific and global views.

## User Review Required

> [!IMPORTANT]
> I will be uncommenting the search bar in `IssuesPage`. Please verify if this was intentionally commented out for some reason.
> I will also be ensuring that `IssuesBloc` loads all tags when loading issues, as this is currently commented out in the Bloc.

## Proposed Changes

### [Issues Feature]

#### [MODIFY] [issues_page.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/pages/issues_page.dart)
- Update `initState` to trigger `LoadIssues` when `projectId` is null.
- Uncomment `_buildTextField(state)` and the associated `SizedBox` to show the search/filter bar.

#### [MODIFY] [issues_bloc.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/bloc/issues_bloc.dart)
- Uncomment and implement tags fetching in `_onLoadIssues`.
- Ensure tags are also fetched or preserved in `_onUpdateFilter`.

## Verification Plan

### Manual Verification
- Navigate to the global Issues page and verify that all issues are loaded.
- Navigate to a specific project's issues and verify that only that project's issues are shown.
- Verify that tags are displayed on the issue cards/rows.
- Verify that the search bar is visible and functional (triggers filter updates).
