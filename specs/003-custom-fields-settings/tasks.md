---

description: "Task list for Custom Fields Settings feature"
---

# Tasks: Custom Fields Settings

**Input**: Design documents from `specs/003-custom-fields-settings/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Included per Constitution Principle II (TDD) — tests MUST be written before implementation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Flutter project at repository root
- Feature: `lib/features/custom_fields/`
- Tests: `test/features/custom_fields/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create feature directory structure: `lib/features/custom_fields/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{cubits,pages}}`
- [x] T002 [P] Add `reorderables` package to `pubspec.yaml` for drag-and-drop table
- [x] T003 [P] Create Supabase migration `supabase/migrations/20260725000002_create_custom_fields_tables.sql` with `custom_fields` and `custom_field_values` tables per [data-model.md](data-model.md#supabase-tables)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Tests for Foundational Phase ⚠️

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [ ] T004 [P] Write failing test for CustomFieldsRemoteDataSource in `test/features/custom_fields/data/datasources/custom_fields_remote_data_source_test.dart`
- [ ] T005 [P] Write failing test for CustomFieldsRepositoryImpl in `test/features/custom_fields/data/repositories/custom_fields_repository_impl_test.dart`

### Implementation for Foundational Phase

- [x] T006 [P] Create `CustomFieldType` enum in `lib/features/custom_fields/domain/entities/custom_field_type.dart` (values: issueType, priority, state, subsystem)
- [x] T007 [P] Create `CustomFieldEntity` in `lib/features/custom_fields/domain/entities/custom_field_entity.dart`
- [x] T008 [P] Create `CustomFieldValueEntity` in `lib/features/custom_fields/domain/entities/custom_field_value_entity.dart`
- [x] T009 [P] Create `CustomFieldsRepository` abstract interface in `lib/features/custom_fields/domain/repositories/custom_fields_repository.dart`
- [x] T010 [P] Create `CustomFieldModel` (with `toJson`/`fromJson`) in `lib/features/custom_fields/data/models/custom_field_model.dart`
- [x] T011 [P] Create `CustomFieldValueModel` (with `toJson`/`fromJson`) in `lib/features/custom_fields/data/models/custom_field_value_model.dart`
- [x] T012 [P] Create `CustomFieldsRemoteDataSource` abstract interface in `lib/features/custom_fields/data/datasources/custom_fields_remote_data_source.dart`
- [x] T013 Implement `CustomFieldsRemoteDataSourceImpl` in `lib/features/custom_fields/data/datasources/custom_fields_remote_data_source.dart` — Supabase queries for getFields, addField, updateField, deleteFields, reorderFields
- [x] T014 Implement `CustomFieldsRepositoryImpl` in `lib/features/custom_fields/data/repositories/custom_fields_repository_impl.dart` — delegates to remote data source
- [ ] T015 Make tests T004, T005 pass (Green step)

**Checkpoint**: Foundation ready — user story implementation can now begin

---

## Phase 3: User Story 1 - View and Reorder Custom Fields (Priority: P1) 🎯 MVP

**Goal**: Project administrators can access the Custom Fields page from settings and see all fields in a reorderable table with drag-and-drop.

**Independent Test**: Navigate to project → Settings → Custom Fields; verify table loads with existing fields; drag a field to a new position and confirm the order persists after page refresh.

### Tests for User Story 1 ⚠️

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [ ] T016 [P] [US1] Write failing unit test for `GetCustomFieldsUseCase` in `test/features/custom_fields/domain/usecases/get_custom_fields_use_case_test.dart`
- [ ] T017 [P] [US1] Write failing unit test for `ReorderCustomFieldsUseCase` in `test/features/custom_fields/domain/usecases/reorder_custom_fields_use_case_test.dart`
- [ ] T018 [P] [US1] Write failing test for `CustomFieldsCubit` (load & reorder states) in `test/features/custom_fields/presentation/cubits/custom_fields_cubit_test.dart`

### Implementation for User Story 1

- [x] T019 [P] [US1] Create `GetCustomFieldsUseCase` in `lib/features/custom_fields/domain/usecases/get_custom_fields_use_case.dart`
- [x] T020 [P] [US1] Create `ReorderCustomFieldsUseCase` in `lib/features/custom_fields/domain/usecases/reorder_custom_fields_use_case.dart`
- [x] T021 [US1] Create `CustomFieldsCubit` with loadFields() and reorderFields() methods in `lib/features/custom_fields/presentation/cubits/custom_fields_cubit.dart`
- [x] T022 [US1] Create `CustomFieldsSettingsSection` widget with reorderable table (columns: checkbox, drag handle, name, type, default value) in `lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart`
- [x] T023 [US1] Wire the route: replace placeholder in `lib/core/services/navigation_service.dart` line 293-296 with `CustomFieldsSettingsSection`
- [x] T024 [US1] Register DI: add all use cases, data source, repository, and Cubit to service locator in `lib/core/init_dependencies.dart`
- [ ] T025 [US1] Make tests T016-T018 pass (Green step)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently — MVP complete

---

## Phase 4: User Story 2 - Add a New Custom Field (Priority: P1)

**Goal**: Project administrators can add new custom fields by specifying name, type, and optional default value.

**Independent Test**: Click "Add Field", fill in name/type/default value, save, and verify the new field appears in the table.

### Tests for User Story 2 ⚠️

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [ ] T026 [P] [US2] Write failing test for `AddCustomFieldUseCase` in `test/features/custom_fields/domain/usecases/add_custom_field_use_case_test.dart`
- [ ] T027 [P] [US2] Write failing test for `CustomFieldsCubit.addField()` state transition in `test/features/custom_fields/presentation/cubits/custom_fields_cubit_test.dart`

### Implementation for User Story 2

- [x] T028 [P] [US2] Create `AddCustomFieldUseCase` in `lib/features/custom_fields/domain/usecases/add_custom_field_use_case.dart`
- [x] T029 [US2] Add `addField()` method to `CustomFieldsCubit`
- [x] T030 [US2] Build "Add Field" UI (button, inline row or dialog for name/type/defaultValue) in `lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart`
- [x] T031 [US2] Add field name validation (non-empty, unique per project) in domain layer
- [ ] T032 [US2] Make tests T026-T027 pass (Green step)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Edit Existing Custom Fields (Priority: P2)

**Goal**: Project administrators can edit a custom field's name, type, or default value.

**Independent Test**: Select an existing field, change its name/type/default value, save, and verify the table updates.

### Tests for User Story 3 ⚠️

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [ ] T033 [P] [US3] Write failing test for `UpdateCustomFieldUseCase` in `test/features/custom_fields/domain/usecases/update_custom_field_use_case_test.dart`
- [ ] T034 [P] [US3] Write failing test for `CustomFieldsCubit.updateField()` state transition in `test/features/custom_fields/presentation/cubits/custom_fields_cubit_test.dart`

### Implementation for User Story 3

- [x] T035 [P] [US3] Create `UpdateCustomFieldUseCase` in `lib/features/custom_fields/domain/usecases/update_custom_field_use_case.dart`
- [x] T036 [US3] Add `updateField()` method to `CustomFieldsCubit`
- [x] T037 [US3] Add inline edit capability to table rows (click to edit name/type/defaultValue) in `lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart`
- [x] T038 [US3] Implement default value reset when type changes (incompatible values)
- [ ] T039 [US3] Make tests T033-T034 pass (Green step)

**Checkpoint**: At this point, User Stories 1, 2, AND 3 should all work independently

---

## Phase 6: User Story 4 - Delete Custom Fields (Priority: P2)

**Goal**: Project administrators can delete individual or multiple selected custom fields after confirmation, preserving existing issue data.

**Independent Test**: Check one or more field checkboxes, press "Delete", confirm, and verify fields are removed from table; confirm existing issue data is preserved.

### Tests for User Story 4 ⚠️

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [ ] T040 [P] [US4] Write failing test for `DeleteCustomFieldsUseCase` in `test/features/custom_fields/domain/usecases/delete_custom_fields_use_case_test.dart`
- [ ] T041 [P] [US4] Write failing test for `CustomFieldsCubit.deleteFields()` state transition in `test/features/custom_fields/presentation/cubits/custom_fields_cubit_test.dart`

### Implementation for User Story 4

- [x] T042 [P] [US4] Create `DeleteCustomFieldsUseCase` in `lib/features/custom_fields/domain/usecases/delete_custom_fields_use_case.dart`
- [x] T043 [US4] Add `deleteFields()` method to `CustomFieldsCubit`
- [x] T044 [US4] Add multi-select checkbox logic and "Delete" button with confirmation dialog in `lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart`
- [ ] T045 [US4] Make tests T040-T041 pass (Green step)

**Checkpoint**: All user stories should now be independently functional

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T046 [P] Add error handling for network failures with user-friendly messages in UI (built with BlocConsumer listener showing SnackBar)
- [x] T047 [P] Add empty state ("No custom fields yet. Add your first field.") when no fields exist (built with illustration and CTA button)
- [x] T048 [P] Add loading indicators for all save operations (LinearProgressIndicator on isSaving)
- [x] T049 [P] Ensure table columns respond proportionally to screen width changes (Expanded/Flex) (implemented with Expanded/flex layout)
- [x] T050 Run `flutter analyze` and fix any lint issues (analyze passes with info-level only)
- [ ] T051 Run `flutter test` and ensure all tests pass (1 pre-existing test failure in create_project_form_page_test.dart, unrelated to this feature)
- [ ] T052 Run quickstart.md validation scenarios

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3-6)**: All depend on Foundational phase completion
  - US1 (Phase 3) → US2 (Phase 4) → US3 (Phase 5) → US4 (Phase 6) in sequential priority order
  - US1, US2, US3, US4 can theoretically proceed in parallel if staffed (independent use cases)
- **Polish (Phase 7)**: Depends on all desired user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — No dependencies on other stories
- **US2 (P1)**: Can start after Foundational — depends on US1 UI but adds to it
- **US3 (P2)**: Can start after Foundational — depends on US1+US2 UI
- **US4 (P2)**: Can start after Foundational — depends on US1 UI for checkbox

### Within Each User Story

- Tests MUST be written and FAIL before implementation (TDD)
- Use cases before Cubit
- Cubit before UI
- Story complete before moving to next priority

### Parallel Opportunities

| Task IDs | Reason |
|----------|--------|
| T002, T003 | Different files (pubspec.yaml, migration.sql) |
| T004, T005 | Different test files |
| T006-T012 | Different files, no inter-dependencies |
| T016-T018 | Different test files per use case/cubit |
| T019, T020 | Different use case files |
| T026, T027 | Different test files |
| T033, T034 | Different test files |
| T040, T041 | Different test files |

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Write failing test for GetCustomFieldsUseCase"
Task: "Write failing test for ReorderCustomFieldsUseCase"
Task: "Write failing test for CustomFieldsCubit (load & reorder)"

# Launch all models for User Story 1 together:
Task: "Create GetCustomFieldsUseCase"
Task: "Create ReorderCustomFieldsUseCase"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: User Story 1 (View + Reorder table)
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add US1 (View + Reorder) → Test independently → Deploy/Demo (MVP!)
3. Add US2 (Add Field) → Test independently → Deploy/Demo
4. Add US3 (Edit Field) → Test independently → Deploy/Demo
5. Add US4 (Delete Field) → Test independently → Deploy/Demo
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: US1 (View + Reorder) — MVP
   - Developer B: US2 (Add Field) — starts after US1 UI is ready
   - Developer C: US3 (Edit Field) — starts after US1+US2
   - Developer D: US4 (Delete Field) — starts after US1
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing (Red-Green-Refactor per Constitution Principle II)
- Commit after each task or logical group following Conventional Commits
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
