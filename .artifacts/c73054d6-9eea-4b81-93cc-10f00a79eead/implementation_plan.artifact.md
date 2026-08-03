# Fix IssuesBloc State Casting Crash

The `IssuesBloc` crashes when `UpdateFilter` is dispatched before the issues are loaded, due to an unsafe cast from `IssuesInitial` to `IssuesLoaded`.

## User Review Required

> [!NOTE]
> I will be fixing the unsafe cast in `_onUpdateFilter`. I will also take the opportunity to fix some typos in method names within `IssuesBloc` to match the event names and standard spelling.

## Proposed Changes

### [Issues Feature]

#### [MODIFY] [issues_bloc.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/bloc/issues_bloc.dart)

- Fix `_onUpdateFilter` to handle cases where the current state is not `IssuesLoaded`.
- Fix typos in method names:
    - `_onLayouyTypeChanged` -> `_onLayoutTypeChanged`
    - `_onStrcutureTypeChanged` -> `_onStructureTypeChanged`
    - `_onPreviewTypeChnaged` -> `_onPreviewTypeChanged`
- Update the constructor to use the corrected method names.

## Verification Plan

### Automated Tests
- Verify that the code compiles.
- Check that the logic in `_onUpdateFilter` correctly handles both `IssuesLoaded` and non-loaded states.

### Manual Verification
- The user can verify that triggering a filter update (e.g., searching) immediately after app start no longer crashes the app.
