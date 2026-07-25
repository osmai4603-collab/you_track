# Research: Projects Supabase Refactor

**Feature**: 002-projects-supabase-refactor
**Date**: 2026-07-25

## R1: Supabase Client API Patterns for CRUD Operations

**Decision**: Use the `supabase_flutter` PostgREST query builder pattern established by `DashboardRemoteDataSourceImpl`.

**Rationale**: The dashboards feature already demonstrates the exact pattern: `supabase.from('table').select()`, `.insert({...}).select().single()`, `.update({...}).eq('id', id).select().single()`, `.delete().eq('id', id)`. This is the project's established convention and requires no additional libraries or abstractions.

**Alternatives considered**:
- Supabase REST API via `http` package: More boilerplate, loses type safety, no real-time subscriptions. Rejected as unnecessarily low-level.
- Repository pattern with abstract remote source interface: Already exists in the codebase (`ProjectsRemoteDataSource` abstract class). This is the correct approach and matches the dashboard pattern.

## R2: Model Serialization for Supabase (snake_case vs camelCase)

**Decision**: Add `fromJson`/`toJson` methods with snake_case keys to all three project models. Keep existing `fromMap`/`toMap` methods with camelCase keys for backward compatibility with any local data source usage.

**Rationale**: Supabase PostgreSQL stores columns in snake_case by convention (e.g., `project_key`, `is_archived`, `created_at`). The `DashboardModel` already uses `fromJson`/`toJson` with snake_case. Adding dual serialization methods avoids breaking existing code that uses `fromMap`/`toMap` while enabling Supabase integration.

**Alternatives considered**:
- Replace `fromMap`/`toMap` entirely: Risky if any code path still depends on camelCase keys. Safer to keep both.
- Use a shared serialization utility: Over-engineering for three models with straightforward field mappings.

## R3: Supabase Table Schema Design

**Decision**: Three tables matching the existing entity structure, with foreign key relationships.

**Rationale**: The entities (`ProjectEntity`, `ProjectMemberEntity`, `ProjectTemplateEntity`) already define the data shape. The tables mirror these with PostgreSQL-native types (uuid, timestamptz, jsonb, boolean).

**Alternatives considered**:
- Single denormalized table: Violates normalization, makes member management complex. Rejected.
- Separate members table without project foreign key: Would require app-side filtering. Rejected.

## R4: Error Handling Strategy

**Decision**: Use `ServerFailure` for Supabase errors (network, auth, server), replacing `LocalDatabaseFailure` in the repository implementation.

**Rationale**: The `core/errors/failure.dart` already defines `ServerFailure`. The repository currently wraps all errors as `LocalDatabaseFailure` which is semantically incorrect for remote data sources. Switching to `ServerFailure` communicates the actual failure mode to the UI layer.

**Alternatives considered**:
- Create a new `SupabaseFailure`: Unnecessary granularization. `ServerFailure` is sufficient.
- Use raw exceptions: Violates the Either-based error handling pattern. Rejected.

## R5: ProjectView Page Mock Data Removal

**Decision**: Replace `_initMockData()` with cubit-driven data loading. The `ProjectView` page will receive a `projectId` and load members/issues through the existing `ProjectMembersCubit`.

**Rationale**: The `_initMockData()` method creates 4 hardcoded members and 6 hardcoded issues directly in the widget state, bypassing the entire Clean Architecture pipeline. The `ProjectMembersCubit` already exists and supports `loadMembers(projectId)`. Issues data will remain as-is (issues feature is out of scope for this refactoring) but members must come from Supabase.

**Alternatives considered**:
- Create a new `ProjectViewCubit`: Unnecessary when existing cubits cover the needed operations.
- Keep issues as mock data: Correct — issues feature is not part of this refactoring scope per the spec (FR-002 covers members only).

## R6: Dependency Injection Wiring

**Decision**: Register `ProjectsRemoteDataSourceImpl` with `SupabaseClient` in `_initProjectsFeature()`, update `ProjectsRepositoryImpl` to accept the remote data source instead of (or in addition to) the local data source.

**Rationale**: The `SupabaseClient` is already registered as a lazy singleton in `initDependencies()`. The dashboard feature demonstrates the exact wiring pattern. The local data source can optionally be retained for offline caching, but the primary data path must be remote.

**Alternatives considered**:
- Keep local as primary, sync from remote: Adds complexity for minimal benefit in this scope. The spec requires "every data display must come from supabase."
- Remove local data source entirely: Risky if any other code references it. Safer to keep but not use as primary.
