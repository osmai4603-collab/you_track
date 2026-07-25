# Tasks: Add Custom Field Page

**Input**: Design documents from `/specs/004-add-custom-field/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Test tasks are included due to constitution's Test-First Development requirement.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter mobile app**: `lib/features/custom_field/` for new feature code
- **Tests**: `test/unit/`, `test/widget/`, `test/integration/`
- **Supabase migrations**: `supabase/migrations/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure for custom field creation feature

- [X] T001 Create feature directory structure: `lib/features/custom_field/data/`, `lib/features/custom_field/domain/`, `lib/features/custom_field/presentation/`
- [X] T002 [P] Create Supabase migration file for custom_fields table: `supabase/migrations/YYYYMMDDHHMMSS_create_custom_fields.sql`
- [X] T003 [P] Create base CustomField entity in domain layer: `lib/features/custom_field/domain/entities/custom_field.dart`
- [X] T004 [P] Create FieldType enum in domain layer: `lib/features/custom_field/domain/entities/field_type.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 Implement CustomFieldRepository interface in domain layer: `lib/features/custom_field/domain/repositories/custom_field_repository.dart`
- [X] T006 [P] Implement CustomFieldRepositoryImpl in data layer: `lib/features/custom_field/data/repositories/custom_field_repository_impl.dart`
- [X] T007 [P] Create CustomFieldModel in data layer: `lib/features/custom_field/data/models/custom_field_model.dart`
- [X] T008 [P] Create Supabase datasource for custom fields: `lib/features/custom_field/data/datasources/custom_field_remote_data_source.dart`
- [X] T009 Setup dependency injection for custom field feature: `lib/core/di/injection_container.dart` (extend existing)
- [X] T010 Create validation use cases for custom field: `lib/features/custom_field/domain/usecases/validate_custom_field_name.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Open Add Custom Field Panel (Priority: P1) 🎯 MVP

**Goal**: Implement sliding panel animation with overlay for adding custom fields

**Independent Test**: Can be fully tested by tapping the "Add field" button and verifying the panel slides in from the right with a dark overlay.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T011 [P] [US1] Widget test for sliding panel animation: `test/widget/custom_field/custom_field_panel_test.dart`
- [X] T012 [P] [US1] Unit test for panel state cubit: `test/unit/custom_field/panel_cubit_test.dart`

### Implementation for User Story 1

- [X] T013 [P] [US1] Create CustomFieldPanelCubit for panel state: `lib/features/custom_field/presentation/cubits/custom_field_panel_cubit.dart`
- [X] T014 [P] [US1] Create sliding panel widget: `lib/features/custom_field/presentation/widgets/sliding_panel.dart`
- [X] T015 [P] [US1] Create overlay widget with AnimatedOpacity: `lib/features/custom_field/presentation/widgets/panel_overlay.dart`
- [X] T016 [US1] Implement AddCustomFieldPage: `lib/features/custom_field/presentation/pages/add_custom_field_page.dart`
- [X] T017 [US1] Integrate panel with project settings page: `lib/features/projects/presentation/pages/project_settings_page.dart` (modify existing)
- [X] T018 [US1] Add navigation route for add custom field page: `lib/core/router/app_router.dart` (extend existing)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Configure Custom Field Type (Priority: P2)

**Goal**: Implement tabbed interface for selecting custom field type with visual indicators

**Independent Test**: Can be fully tested by opening the panel and switching between tabs, verifying the active tab indicator changes.

### Tests for User Story 2

- [X] T019 [P] [US2] Widget test for custom tabs: `test/widget/custom_field/custom_tabs_test.dart`
- [X] T020 [P] [US2] Unit test for tab selection cubit: `test/unit/custom_field/tab_selection_cubit_test.dart`

### Implementation for User Story 2

- [X] T021 [P] [US2] Create TabSelectionCubit for tab state: `lib/features/custom_field/presentation/cubits/tab_selection_cubit.dart`
- [X] T022 [P] [US2] Create custom tab bar widget: `lib/features/custom_field/presentation/widgets/custom_tab_bar.dart`
- [X] T023 [P] [US2] Create tab indicator widget: `lib/features/custom_field/presentation/widgets/tab_indicator.dart`
- [ ] T024 [US2] Integrate tabs with add custom field page: `lib/features/custom_field/presentation/pages/add_custom_field_page.dart` (modify existing)
- [ ] T025 [US2] Add tab selection logic to panel cubit: `lib/features/custom_field/presentation/cubits/custom_field_panel_cubit.dart` (modify existing)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Fill Field Details (Priority: P3)

**Goal**: Implement form inputs for field name and description with validation

**Independent Test**: Can be fully tested by entering text in name and description fields and verifying they are captured.

### Tests for User Story 3

- [ ] T026 [P] [US3] Widget test for form inputs: `test/widget/custom_field/custom_field_form_test.dart`
- [ ] T027 [P] [US3] Unit test for form validation: `test/unit/custom_field/form_validation_test.dart`

### Implementation for User Story 3

- [ ] T028 [P] [US3] Create form state cubit: `lib/features/custom_field/presentation/cubits/form_state_cubit.dart`
- [ ] T029 [P] [US3] Create field name input widget: `lib/features/custom_field/presentation/widgets/field_name_input.dart`
- [ ] T030 [P] [US3] Create description input widget: `lib/features/custom_field/presentation/widgets/description_input.dart`
- [ ] T031 [US3] Integrate form with add custom field page: `lib/features/custom_field/presentation/pages/add_custom_field_page.dart` (modify existing)
- [ ] T032 [US3] Add form validation logic to form state cubit: `lib/features/custom_field/presentation/cubits/form_state_cubit.dart` (modify existing)

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: User Story 4 - Set Field Privacy (Priority: P4)

**Goal**: Implement privacy checkbox with custom styling

**Independent Test**: Can be fully tested by toggling the "Make private" checkbox and verifying the field's private status.

### Tests for User Story 4

- [ ] T033 [P] [US4] Widget test for privacy checkbox: `test/widget/custom_field/privacy_checkbox_test.dart`
- [ ] T034 [P] [US4] Unit test for privacy state: `test/unit/custom_field/privacy_state_test.dart`

### Implementation for User Story 4

- [ ] T035 [P] [US4] Create privacy state cubit: `lib/features/custom_field/presentation/cubits/privacy_state_cubit.dart`
- [ ] T036 [P] [US4] Create custom privacy checkbox widget: `lib/features/custom_field/presentation/widgets/privacy_checkbox.dart`
- [ ] T037 [US4] Integrate privacy checkbox with add custom field page: `lib/features/custom_field/presentation/pages/add_custom_field_page.dart` (modify existing)

---

## Phase 7: User Story 5 - Submit Custom Field (Priority: P5)

**Goal**: Implement form submission with backend integration and validation

**Independent Test**: Can be fully tested by filling all required fields and tapping "Add field" button.

### Tests for User Story 5

- [ ] T038 [P] [US5] Widget test for form submission: `test/widget/custom_field/form_submission_test.dart`
- [ ] T039 [P] [US5] Integration test for custom field creation: `test/integration/custom_field_creation_test.dart`
- [ ] T040 [P] [US5] Unit test for create custom field use case: `test/unit/custom_field/create_custom_field_test.dart`

### Implementation for User Story 5

- [ ] T041 [P] [US5] Create CreateCustomFieldUseCase: `lib/features/custom_field/domain/usecases/create_custom_field.dart`
- [ ] T042 [P] [US5] Create network error handling utility: `lib/core/utils/network_error_handler.dart`
- [ ] T043 [US5] Implement form submission logic in form state cubit: `lib/features/custom_field/presentation/cubits/form_state_cubit.dart` (modify existing)
- [ ] T044 [US5] Add success/error feedback to add custom field page: `lib/features/custom_field/presentation/pages/add_custom_field_page.dart` (modify existing)
- [ ] T045 [US5] Update project settings to refresh custom fields list: `lib/features/projects/presentation/pages/project_settings_page.dart` (modify existing)

**Checkpoint**: All user stories should now be independently functional

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T046 [P] Add localization support for custom field strings: `lib/core/l10n/` (extend existing)
- [ ] T047 [P] Add accessibility labels to all widgets
- [ ] T048 Performance optimization for animations
- [ ] T049 [P] Additional unit tests for edge cases: `test/unit/custom_field/edge_cases_test.dart`
- [ ] T050 Security hardening for RLS policies: `supabase/migrations/` (verify policies)
- [ ] T051 Run quickstart.md validation scenarios
- [ ] T052 Code cleanup and refactoring
- [ ] T053 Update documentation in docs/

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3 → P4 → P5)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable
- **User Story 4 (P4)**: Can start after Foundational (Phase 2) - May integrate with US1/US2/US3 but should be independently testable
- **User Story 5 (P5)**: Can start after Foundational (Phase 2) - May integrate with US1/US2/US3/US4 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Widget test for sliding panel animation: test/widget/custom_field/custom_field_panel_test.dart"
Task: "Unit test for panel state cubit: test/unit/custom_field/panel_cubit_test.dart"

# Launch all widgets for User Story 1 together:
Task: "Create CustomFieldPanelCubit for panel state: lib/features/custom_field/presentation/cubits/custom_field_panel_cubit.dart"
Task: "Create sliding panel widget: lib/features/custom_field/presentation/widgets/sliding_panel.dart"
Task: "Create overlay widget with AnimatedOpacity: lib/features/custom_field/presentation/widgets/panel_overlay.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Add User Story 4 → Test independently → Deploy/Demo
6. Add User Story 5 → Test independently → Deploy/Demo
7. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
   - Developer D: User Story 4
   - Developer E: User Story 5
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence