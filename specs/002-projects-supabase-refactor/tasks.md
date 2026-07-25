# Tasks: Projects Supabase Refactor

**Feature**: 002-projects-supabase-refactor
**Date**: 2026-07-25

## Phase 1: Model Serialization (snake_case for Supabase)

- [X] T1.1: Add `fromJson`/`toJson` methods with snake_case keys to `ProjectModel`
- [X] T1.2: Add `fromJson`/`toJson` methods with snake_case keys to `ProjectMemberModel`
- [X] T1.3: Add `fromJson`/`toJson` methods with snake_case keys to `ProjectTemplateModel`

## Phase 2: Remote Data Source

- [X] T2.1: Create `ProjectsRemoteDataSource` abstract class
- [X] T2.2: Create `ProjectsRemoteDataSourceImpl` with Supabase CRUD operations

## Phase 3: Repository & DI Wiring

- [X] T3.1: Update `ProjectsRepositoryImpl` to use `ProjectsRemoteDataSource` instead of `ProjectsLocalDataSource`
- [X] T3.2: Update `_initProjectsFeature()` in `init_dependencies.dart` to register remote data source and wire SupabaseClient

## Phase 4: Presentation Layer Cleanup

- [X] T4.1: Remove `_initMockData()` from `project_view_page.dart` and wire members through `ProjectMembersCubit`

## Phase 5: Validation

- [X] T5.1: Run `flutter analyze` to verify no errors
