# Data Model: Create Project Navigation

**Date**: 2026-07-25
**Feature**: 001-create-project-navigation

## Entities

This feature involves **no new entities or data model changes**. It is a pure navigation/wiring feature.

### Existing Entities (reused, not modified)

| Entity | Location | Reused As |
|--------|----------|-----------|
| `ProjectCreationState` | `lib/features/projects/presentation/cubits/project_creation_cubit.dart` | State for the creation form (name, key, status, errors) |
| `YouTrackShellState` | `lib/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart` | Tracks current path for header visibility |

## State Transitions

No new state transitions. The existing flow:

```
User taps "Create Project"
  → context.go('/projects/templates')
  → ProjectTemplateSelectionPage loads
  → User selects template
  → context.go('/projects/templates/:id')
  → ProjectTemplateDetailsPage loads
  → User taps "Use this template"
  → context.go('/projects/new')
  → CreateProjectFormPage loads
  → User fills form, taps "Create Project"
  → ProjectCreationCubit.submitCreateProject()
  → On success: context.go('/projects/:id/add-members')
```

## Validation Rules

None added. Existing form validation in `CreateProjectFormPage` is unchanged.
