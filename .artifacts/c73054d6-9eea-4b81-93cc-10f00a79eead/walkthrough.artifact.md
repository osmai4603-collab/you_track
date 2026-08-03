# Walkthrough - Fix AddSubsystemUseCase Registration

I have fixed the `Bad state: GetIt: Object/factory with type AddSubsystemUseCase is not registered` error by registering the use case in the dependency injection container.

## Changes Made

### Core Dependency Injection

I updated `lib/core/init_dependencies.dart` to include `AddSubsystemUseCase` in the `_initProjectsFeature` registration block.

render_diffs(file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/init_dependencies.dart)

## Verification Results

- Verified that `AddSubsystemUseCase` is now registered as a lazy singleton using `get_it`.
- The `IssueFormSidebar` will now be able to resolve `AddSubsystemUseCase` from `get_it` when the user attempts to add a new subsystem.
