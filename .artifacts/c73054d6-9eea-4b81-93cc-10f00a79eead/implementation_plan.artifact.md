# Fix GetIt registration for AddSubsystemUseCase

The app crashes when trying to add a new subsystem from the Issue Form because `AddSubsystemUseCase` is not registered in the service locator.

## Proposed Changes

### [Core]

#### [MODIFY] [init_dependencies.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/init_dependencies.dart)

- Register `AddSubsystemUseCase` in `_initProjectsFeature`.

## Verification Plan

### Automated Tests
- Verify that the code compiles.
- I'll check if there are any other subsystem-related use cases that might be missing (e.g., Update/Delete).

### Manual Verification
- The user can verify that clicking "New Subsystem" and saving it no longer crashes the app.
