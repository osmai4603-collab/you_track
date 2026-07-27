# Tasks: Custom Fields Table Redesign

**Input**: Design documents from `/specs/006-custom-fields-table-redesign/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Not included in this task list. Tests are optional and can be added in a future iteration.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Database migration and entity extensions for visibility and access control

- [X] T001 Create Supabase migration to add visibility and access_control columns to custom_fields table in supabase/migrations/
- [X] T002 Add RLS policy for field visibility based on access_control in supabase/migrations/
- [X] T003 [P] Extend CustomFieldEntity with visibility and accessControl properties in lib/features/custom_fields/domain/entities/custom_field_entity.dart
- [X] T004 [P] Extend CustomFieldModel with visibility and accessControl fields in lib/features/custom_fields/data/models/custom_field_model.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Data layer and use cases that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 Extend CustomFieldsRepository interface with updateVisibility() and updateAccessControl() methods in lib/features/custom_fields/domain/repositories/custom_fields_repository.dart
- [X] T006 Extend CustomFieldsRemoteDataSource with updateVisibility() and updateAccessControl() methods in lib/features/custom_fields/data/datasources/custom_fields_remote_data_source.dart
- [X] T007 Extend CustomFieldsRepositoryImpl with updateVisibility() and updateAccessControl() implementations in lib/features/custom_fields/data/repositories/custom_fields_repository_impl.dart
- [X] T008 Create UpdateFieldVisibilityUseCase in lib/features/custom_fields/domain/usecases/update_field_visibility_use_case.dart
- [X] T009 Create UpdateFieldAccessControlUseCase in lib/features/custom_fields/domain/usecases/update_field_access_control_use_case.dart
- [X] T010 Extend CustomFieldsCubit with updateVisibility() and updateAccessControl() methods in lib/features/custom_fields/presentation/cubits/custom_fields_cubit.dart

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - View Custom Fields in Table Layout (Priority: P1) 🎯 MVP

**Goal**: Display all custom fields in a structured table with detailed metadata columns

**Independent Test**: Navigate to Custom Fields settings and verify all fields appear in a table with columns: checkbox, drag handle, Field in Projects, Type, Default Value(s), Empty Value, Default Visibility

### Implementation for User Story 1

- [X] T011 [P] [US1] Create FieldTableRow widget in lib/features/custom_fields/presentation/widgets/field_table_row.dart
- [X] T012 [P] [US1] Create FieldTableHeader widget in lib/features/custom_fields/presentation/widgets/field_table_header.dart
- [X] T013 [US1] Rebuild CustomFieldsSettingsSection with table layout in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T014 [US1] Implement empty state UI when no fields exist in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T015 [US1] Add field type display formatting logic in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Toolbar Actions for Field Management (Priority: P1)

**Goal**: Display a toolbar with action buttons (Add, Edit, Delete, Replace, Make Private) that respond to selection state

**Independent Test**: Verify the toolbar displays all action buttons and they respond correctly to selection state

### Implementation for User Story 2

- [X] T016 [P] [US2] Create FieldToolbar widget in lib/features/custom_fields/presentation/widgets/field_toolbar.dart
- [X] T017 [US2] Integrate FieldToolbar with CustomFieldsSettingsSection in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T018 [US2] Implement toolbar button state management (enabled/disabled based on selection) in lib/features/custom_fields/presentation/widgets/field_toolbar.dart
- [X] T019 [US2] Connect Add field button to existing SlidingPanel in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T020 [US2] Connect Edit button to existing EditFieldDialog in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T021 [US2] Connect Delete button to existing DeleteConfirmationDialog in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Field Selection and Bulk Operations (Priority: P1)

**Goal**: Select multiple fields using checkboxes for bulk operations like delete

**Independent Test**: Select multiple fields via checkboxes and perform a bulk delete operation

### Implementation for User Story 3

- [X] T022 [P] [US3] Implement checkbox selection state management in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T023 [US3] Implement header checkbox for select-all functionality in lib/features/custom_fields/presentation/widgets/field_table_header.dart
- [X] T024 [US3] Implement row checkbox for individual selection in lib/features/custom_fields/presentation/widgets/field_table_row.dart
- [X] T025 [US3] Update DeleteConfirmationDialog to show count of selected fields in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart

**Checkpoint**: All user stories P1 should now be independently functional

---

## Phase 6: User Story 4 - Drag-and-Drop Reordering (Priority: P2)

**Goal**: Reorder fields by dragging them to control display order in issues

**Independent Test**: Drag a field row to a new position and verify the order is persisted

### Implementation for User Story 4

- [X] T026 [P] [US4] Implement ReorderableColumn with ReorderableDragStartListener in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T027 [US4] Connect drag-and-drop reorder to reorderField() cubit method in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T028 [US4] Add visual feedback during drag operation in lib/features/custom_fields/presentation/widgets/field_table_row.dart

**Checkpoint**: User Story 4 complete

---

## Phase 7: User Story 5 - Field Visibility Control (Priority: P2)

**Goal**: Control whether each field is visible in the issues list

**Independent Test**: Toggle a field's visibility and verify the change is reflected in the issues list

### Implementation for User Story 5

- [X] T029 [P] [US5] Implement visibility toggle UI in FieldTableRow widget in lib/features/custom_fields/presentation/widgets/field_table_row.dart
- [X] T030 [US5] Connect visibility toggle to updateVisibility() cubit method in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T031 [US5] Display visibility status as "Show" or "Hide" text in lib/features/custom_fields/presentation/widgets/field_table_row.dart

**Checkpoint**: User Story 5 complete

---

## Phase 8: User Story 6 - Show/Hide Details Toggle (Priority: P3)

**Goal**: Expand or collapse additional column information (Empty Value, Default Visibility)

**Independent Test**: Toggle the "Show details" button and verify columns expand/collapse

### Implementation for User Story 6

- [X] T032 [P] [US6] Implement ValueNotifier<bool> for _showDetails state in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T033 [US6] Add Show details toggle button to FieldToolbar in lib/features/custom_fields/presentation/widgets/field_toolbar.dart
- [X] T034 [US6] Implement conditional column rendering based on _showDetails state in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart

**Checkpoint**: User Story 6 complete

---

## Phase 9: User Story 7 - Replace Field Values (Priority: P3)

**Goal**: Replace field values across issues using PopupButton with TextField

**Independent Test**: Select a field, click Replace, and verify the replacement workflow opens

### Implementation for User Story 7

- [X] T035 [P] [US7] Create ReplaceValuePopup widget with PopupMenuButton and TextField in lib/features/custom_fields/presentation/widgets/replace_value_popup.dart
- [X] T036 [US7] Connect Replace button to ReplaceValuePopup in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T037 [US7] Implement value filtering logic in TextField within ReplaceValuePopup in lib/features/custom_fields/presentation/widgets/replace_value_popup.dart

**Checkpoint**: User Story 7 complete

---

## Phase 10: User Story 8 - Make Private with Access Control (Priority: P2)

**Goal**: Implement "Make private" with admin-only access control and group/user selection via dialog

**Independent Test**: Select a field, click Make private, and verify access control options work correctly

### Implementation for User Story 8

- [X] T038 [P] [US8] Create MakePrivateDialog widget with overlay and checkboxes in lib/features/custom_fields/presentation/widgets/make_private_dialog.dart
- [X] T039 [US8] Implement radio buttons for Everyone / Admins only / Custom options in lib/features/custom_fields/presentation/widgets/make_private_dialog.dart
- [X] T040 [US8] Implement groups and users selection sections with checkboxes in lib/features/custom_fields/presentation/widgets/make_private_dialog.dart
- [X] T041 [US8] Connect Make private button to MakePrivateDialog in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart
- [X] T042 [US8] Connect MakePrivateDialog save to updateAccessControl() cubit method in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart

**Checkpoint**: All user stories should now be independently functional

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T043 Add localization strings for new UI elements in lib/core/localization/app_en.arb and lib/core/localization/app_ar.arb
- [X] T044 Run flutter analyze to fix any linting issues
- [X] T045 Run flutter test to verify no regressions
- [X] T046 Run quickstart.md validation scenarios to verify end-to-end functionality

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - US1, US2, US3 (P1): Can proceed in parallel after Foundational
  - US4, US5, US8 (P2): Can proceed in parallel after Foundational
  - US6, US7 (P3): Can proceed in parallel after Foundational
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - Integrates with US1 but should be independently testable
- **User Story 3 (P1)**: Can start after Foundational (Phase 2) - Integrates with US1/US2 but should be independently testable
- **User Story 4 (P2)**: Can start after Foundational (Phase 2) - Integrates with US1 but should be independently testable
- **User Story 5 (P2)**: Can start after Foundational (Phase 2) - Integrates with US1 but should be independently testable
- **User Story 6 (P3)**: Can start after Foundational (Phase 2) - Integrates with US1/US2 but should be independently testable
- **User Story 7 (P3)**: Can start after Foundational (Phase 2) - Integrates with US1/US2 but should be independently testable
- **User Story 8 (P2)**: Can start after Foundational (Phase 2) - Integrates with US1/US2 but should be independently testable

### Within Each User Story

- Models/entities before services
- Services before use cases
- Use cases before cubits
- Cubits before UI widgets
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all models for User Story 1 together:
Task: "Create FieldTableRow widget in lib/features/custom_fields/presentation/widgets/field_table_row.dart"
Task: "Create FieldTableHeader widget in lib/features/custom_fields/presentation/widgets/field_table_header.dart"

# Then implement the page:
Task: "Rebuild CustomFieldsSettingsSection with table layout in lib/features/custom_fields/presentation/pages/custom_fields_settings_section.dart"
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
7. Add User Story 6 → Test independently → Deploy/Demo
8. Add User Story 7 → Test independently → Deploy/Demo
9. Add User Story 8 → Test independently → Deploy/Demo
10. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1, 2, 3 (P1 - Table layout, toolbar, selection)
   - Developer B: User Story 4, 5, 8 (P2 - Reorder, visibility, make private)
   - Developer C: User Story 6, 7 (P3 - Details toggle, replace)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
