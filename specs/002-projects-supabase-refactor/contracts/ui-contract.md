# UI Contract: Projects Supabase Refactor

**Feature**: 002-projects-supabase-refactor
**Date**: 2026-07-25

## Contract Type

This is a **UI Contract** — it defines the data flow between the presentation layer (pages/cubits) and the data layer (repositories/data sources) for the projects feature.

## Projects List Page

### Input (Cubit → Page)
- **State**: `ProjectsListState`
  - `projects`: `List<ProjectEntity>` — all projects from Supabase
  - `isLoading`: `bool` — true while fetching
  - `errorMessage`: `String?` — null on success, error message on failure

### Actions (Page → Cubit)
- `loadProjects()` — fetch all projects from Supabase
- `toggleFavorite(ProjectEntity project)` — toggle favorite and persist to Supabase
- `archiveProject(String projectId)` — archive project in Supabase
- `deleteProject(String projectId)` — delete project from Supabase
- `searchProjects(String query)` — filter displayed projects by name or key (client-side)

### Data Source Contract
```
ProjectsRemoteDataSource.getProjects() → List<ProjectModel>
ProjectsRemoteDataSource.updateProject(ProjectModel) → ProjectModel
ProjectsRemoteDataSource.archiveProject(String id) → void
ProjectsRemoteDataSource.deleteProject(String id) → void
```

## Project View Page

### Input (Cubit → Page)
- **State**: `ProjectMembersState`
  - `members`: `List<ProjectMemberEntity>` — members from Supabase
  - `isLoading`: `bool`
  - `errorMessage`: `String?`

### Actions (Page → Cubit)
- `loadMembers(String projectId)` — fetch members from Supabase
- `addProjectMember(ProjectMemberEntity member)` — add member to Supabase

### Data Source Contract
```
ProjectsRemoteDataSource.getProjectMembers(String projectId) → List<ProjectMemberModel>
ProjectsRemoteDataSource.addProjectMember(ProjectMemberModel) → ProjectMemberModel
```

## Project Details Page

### Input (Cubit → Page)
- **State**: `ProjectDetailsState`
  - `project`: `ProjectEntity?` — project from Supabase
  - `isLoading`: `bool`
  - `errorMessage`: `String?`

### Actions (Page → Cubit)
- `loadProject(String projectId)` — fetch project by ID from Supabase

### Data Source Contract
```
ProjectsRemoteDataSource.getProjectById(String id) → ProjectModel
```

## Template Selection Page

### Input (Cubit → Page)
- **State**: `ProjectCreationState`
  - `templates`: `List<ProjectTemplateEntity>` — templates from Supabase
  - `isLoading`: `bool`
  - `errorMessage`: `String?`

### Actions (Page → Cubit)
- `loadTemplates()` — fetch all templates from Supabase

### Data Source Contract
```
ProjectsRemoteDataSource.getProjectTemplates() → List<ProjectTemplateModel>
```

## Error Contract

All data source methods must translate Supabase exceptions into `ServerFailure`:

| Supabase Error | Mapped Failure |
|----------------|----------------|
| Network error / timeout | `ServerFailure('Network error: ...')` |
| Auth error (401/403) | `ServerFailure('Authentication error: ...')` |
| Not found (404) | `ServerFailure('Resource not found: ...')` |
| Server error (500+) | `ServerFailure('Server error: ...')` |
| Validation error (400) | `ServerFailure('Validation error: ...')` |

The repository layer catches all exceptions and returns `Left(ServerFailure(...))` instead of `Left(LocalDatabaseFailure(...))`.
