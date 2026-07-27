# Tasks: Time Tracking Settings

**Input**: Design documents from `/specs/008-time-tracking-settings/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the feature specification. Test tasks omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create feature module directory structure, enums, and DI registration

- [x] T001 Create time_tracking feature module directory structure: `lib/features/time_tracking/data/datasources/`, `lib/features/time_tracking/data/models/`, `lib/features/time_tracking/data/repositories/`, `lib/features/time_tracking/domain/entities/`, `lib/features/time_tracking/domain/repositories/`, `lib/features/time_tracking/domain/usecases/`, `lib/features/time_tracking/presentation/cubits/`, `lib/features/time_tracking/presentation/widgets/`
- [x] T002 [P] Create `TimeTrackingFieldType` enum in `lib/core/enums/time_tracking_field_type_enum.dart` with values: text, number, date, dropdown
- [x] T003 [P] Create `TimeTrackingWidgetType` enum in `lib/core/enums/time_tracking_widget_enum.dart` with values: personalTimeTracking, timeTrackingReport, workItemExporter (verify existing `project_widget_enum.dart` covers these — if so, skip creation)
- [x] T004 Register time tracking feature in GetIt DI container by adding `_initTimeTrackingFeature()` method in `lib/core/init_dependencies.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core domain entities, repository interface, remote data source, and repository implementation that ALL user stories depend on

**CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 [P] Create `TimeTrackingConfigEntity` in `lib/features/time_tracking/domain/entities/time_tracking_config_entity.dart` with fields: projectId, enabled, estimationFieldId, spentTimeFieldId, aggregateSpentTime, aggregateEstimation, updatedAt (extends Entity, Equatable)
- [x] T006 [P] Create `WorkTypeEntity` in `lib/features/time_tracking/domain/entities/work_type_entity.dart` with fields: id, projectId, name, description, isActive, sortOrder, createdAt, updatedAt
- [x] T007 [P] Create `CustomWorkItemAttributeEntity` in `lib/features/time_tracking/domain/entities/custom_work_item_attribute_entity.dart` with fields: id, projectId, name, fieldType, isRequired, options, sortOrder, createdAt, updatedAt
- [x] T008 [P] Create `TimeEntryEntity` in `lib/features/time_tracking/domain/entities/time_entry_entity.dart` with fields: id, taskId, userId, workTypeId, durationMinutes, date, comment, customAttributeValues, createdAt, updatedAt
- [x] T009 [P] Create `TimeTrackingConfigModel` in `lib/features/time_tracking/data/models/time_tracking_config_model.dart` with fromJson/toJson and copyWith (maps to `time_tracking_configs` Supabase table)
- [x] T010 [P] Create `WorkTypeModel` in `lib/features/time_tracking/data/models/work_type_model.dart` with fromJson/toJson and copyWith (maps to `work_types` Supabase table)
- [x] T011 [P] Create `CustomWorkItemAttributeModel` in `lib/features/time_tracking/data/models/custom_work_item_attribute_model.dart` with fromJson/toJson and copyWith (maps to `custom_work_item_attributes` Supabase table)
- [x] T012 [P] Create `TimeEntryModel` in `lib/features/time_tracking/data/models/time_entry_model.dart` with fromJson/toJson (maps to `time_entries` Supabase table)
- [x] T013 Define abstract `TimeTrackingRepository` interface in `lib/features/time_tracking/domain/repositories/time_tracking_repository.dart` with methods: getTimeTrackingConfig, saveTimeTrackingConfig, getWorkTypes, addWorkType, updateWorkType, deleteWorkType, reorderWorkTypes, getCustomAttributes, addCustomAttribute, updateCustomAttribute, deleteCustomAttribute
- [x] T014 Create `TimeTrackingRemoteDataSource` in `lib/features/time_tracking/data/datasources/time_tracking_remote_data_source.dart` with Supabase CRUD methods for all 4 tables (time_tracking_configs, work_types, custom_work_item_attributes, time_entries)
- [x] T015 Implement `TimeTrackingRepositoryImpl` in `lib/features/time_tracking/data/repositories/time_tracking_repository_impl.dart` composing remote data source with Either<Failure, T> error handling pattern
- [x] T016 Register all time tracking singletons (repository, data source, use cases) in `lib/core/init_dependencies.dart` within `_initTimeTrackingFeature()`

**Checkpoint**: Foundation ready — all entities, models, repository, and data source are in place. User story implementation can now begin.

---

## Phase 3: User Story 1 — Toggle Time Tracking On/Off (Priority: P1) MVP

**Goal**: Admin can enable/disable time tracking for the project via a toggle switch. When disabled, all sub-settings are hidden.

**Independent Test**: Navigate to Time Tracking settings, toggle ON → sections appear; toggle OFF → confirmation dialog → sections hide.

### Implementation for User Story 1

- [x] T017 [P] [US1] Create `GetTimeTrackingConfig` use case in `lib/features/time_tracking/domain/usecases/get_time_tracking_config.dart`
- [x] T018 [P] [US1] Create `SaveTimeTrackingConfig` use case in `lib/features/time_tracking/domain/usecases/save_time_tracking_config.dart`
- [x] T019 [US1] Create `TimeTrackingConfigCubit` in `lib/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart` with states: Initial, Loaded, Saved, Error, Stale; methods: loadConfig, toggleEnabled, setEstimationField, setSpentTimeField, setAggregateSpentTime, setAggregateEstimation, save, discard
- [x] T020 [US1] Create `TimeTrackingToggle` widget in `lib/features/time_tracking/presentation/widgets/time_tracking_toggle.dart` — SwitchListTile with confirmation dialog on disable (FR-001, FR-004)
- [x] T021 [US1] Create placeholder section widgets in `lib/features/time_tracking/presentation/widgets/`: `field_configuration_section.dart` (empty Column), `aggregation_section.dart` (empty Column), `work_types_section.dart` (empty Column), `custom_attributes_section.dart` (empty Column) — these will be filled in later stories
- [x] T022 [US1] Replace placeholder in `lib/core/services/navigation_service.dart` (line ~310) from `Center(child: Text('Time Tracking Settings'))` to the new `ProjectTimeTrackingSettingsSection` widget
- [x] T023 [US1] Create `ProjectTimeTrackingSettingsSection` in `lib/features/projects/presentation/widgets/settings_sections/project_time_tracking_settings_section.dart` — StatefulWidget with BlocProvider for TimeTrackingConfigCubit, LayoutBuilder for AnimatedSize show/hide based on toggle state, includes toggle + all section placeholders + save bar (FR-002, FR-003)

**Checkpoint**: Toggle works end-to-end. Admin can enable/disable time tracking. Sections show/hide based on toggle state.

---

## Phase 4: User Story 2 — Configure Estimation and Spent Time Fields (Priority: P1)

**Goal**: Admin can select Estimation and Spent Time fields from dropdowns listing Period-type custom fields.

**Independent Test**: Open Field Configuration, select fields from dropdowns, save, verify persistence.

### Implementation for User Story 2

- [x] T024 [P] [US2] Create `GetAvailablePeriodFields` use case in `lib/features/time_tracking/domain/usecases/get_available_period_fields.dart` — queries custom_fields table for Period-type fields
- [x] T025 [US2] Update `TimeTrackingConfigCubit` to load available Period-type fields and expose `availableFields`, `selectedEstimationFieldId`, `selectedSpentTimeFieldId` state (FR-005, FR-006)
- [x] T026 [US2] Implement `FieldConfigurationSection` widget in `lib/features/time_tracking/presentation/widgets/field_configuration_section.dart` — two DropdownButtonFormField widgets for Estimation and Spent Time fields, "Add Field" option when no Period fields exist (FR-005, FR-006, FR-007), validation that estimation ≠ spent time (FR-008), warning banner if selected field was deleted externally
- [x] T027 [US2] Wire `FieldConfigurationSection` into `ProjectTimeTrackingSettingsSection` (replaces placeholder from T021)

**Checkpoint**: Admin can select Estimation and Spent Time fields. Dropdowns show Period-type fields. Validation prevents same-field selection.

---

## Phase 5: User Story 3 — Configure Subtask Time Aggregation (Priority: P2)

**Goal**: Admin can toggle subtask time aggregation for spent time and estimation independently.

**Independent Test**: Enable aggregation toggles, save, verify persistence; disable, verify parent task values unaffected.

### Implementation for User Story 3

- [x] T028 [US3] Implement `AggregationSection` widget in `lib/features/time_tracking/presentation/widgets/aggregation_section.dart` — two SwitchListTile widgets for "Aggregate Spent Time from Subtasks" and "Aggregate Estimation from Subtasks" (FR-009), wired to TimeTrackingConfigCubit
- [x] T029 [US3] Wire `AggregationSection` into `ProjectTimeTrackingSettingsSection` (replaces placeholder from T021)

**Checkpoint**: Aggregation toggles work. Settings persist on save.

---

## Phase 6: User Story 4 — Manage Work Types (Priority: P2)

**Goal**: Admin can add, edit, delete, and reorder work type classifications with drag-to-reorder.

**Independent Test**: Add a work type, verify it appears; edit name; delete with confirmation; drag to reorder; verify order persists.

### Implementation for User Story 4

- [x] T030 [P] [US4] Create `GetWorkTypes` use case in `lib/features/time_tracking/domain/usecases/get_work_types.dart`
- [x] T031 [P] [US4] Create `AddWorkType` use case in `lib/features/time_tracking/domain/usecases/add_work_type.dart`
- [x] T032 [P] [US4] Create `UpdateWorkType` use case in `lib/features/time_tracking/domain/usecases/update_work_type.dart`
- [x] T033 [P] [US4] Create `DeleteWorkType` use case in `lib/features/time_tracking/domain/usecases/delete_work_type.dart`
- [x] T034 [P] [US4] Create `ReorderWorkTypes` use case in `lib/features/time_tracking/domain/usecases/reorder_work_types.dart`
- [x] T035 [US4] Create `WorkTypesCubit` in `lib/features/time_tracking/presentation/cubits/work_types_cubit.dart` with states: Initial, Loaded, Error; methods: loadWorkTypes, addWorkType, updateWorkType, deleteWorkType, reorderWorkTypes
- [x] T036 [US4] Implement `WorkTypesSection` widget in `lib/features/time_tracking/presentation/widgets/work_types_section.dart` — ReorderableListView with drag handles (FR-033), each row shows name + active/inactive badge + edit/delete actions, empty state message, "Add Work Type" button (FR-013, FR-014, FR-015)
- [x] T037 [US4] Create `WorkTypeFormDialog` in `lib/features/time_tracking/presentation/widgets/work_type_form_dialog.dart` — AlertDialog with name (required), description (optional) fields, used for both add and edit modes
- [x] T038 [US4] Add delete confirmation dialog to `WorkTypesSection` — AlertDialog confirming deletion, noting time entries will retain null work type (FR-016)
- [x] T039 [US4] Implement default work type seeding in `TimeTrackingRemoteDataSource` — when time tracking is first enabled (toggle ON), batch insert 4 default work types: Development, Testing, Design, Documentation with sort_order 0-3
- [x] T040 [US4] Wire `WorkTypesSection` into `ProjectTimeTrackingSettingsSection` with `BlocProvider<WorkTypesCubit>` (replaces placeholder from T021)

**Checkpoint**: Work type CRUD works. Drag-to-reorder persists. Defaults seeded on first enable.

---

## Phase 7: User Story 5 — Manage Custom Work Item Attributes (Priority: P3)

**Goal**: Admin can add, edit, and delete custom attributes (text, number, date, dropdown) for time entry forms.

**Independent Test**: Add a custom attribute, verify it appears in list; edit it; delete with confirmation; verify dropdown options are configurable.

### Implementation for User Story 5

- [x] T041 [P] [US5] Create `GetCustomAttributes` use case in `lib/features/time_tracking/domain/usecases/get_custom_work_item_attributes.dart`
- [x] T042 [P] [US5] Create `AddCustomAttribute` use case in `lib/features/time_tracking/domain/usecases/add_custom_work_item_attribute.dart`
- [x] T043 [P] [US5] Create `UpdateCustomAttribute` use case in `lib/features/time_tracking/domain/usecases/update_custom_work_item_attribute.dart`
- [x] T044 [P] [US5] Create `DeleteCustomAttribute` use case in `lib/features/time_tracking/domain/usecases/delete_custom_work_item_attribute.dart`
- [x] T045 [US5] Create `CustomAttributesCubit` in `lib/features/time_tracking/presentation/cubits/custom_attributes_cubit.dart` with states: Initial, Loaded, Error; methods: loadAttributes, addAttribute, updateAttribute, deleteAttribute
- [x] T046 [US5] Implement `CustomAttributesSection` widget in `lib/features/time_tracking/presentation/widgets/custom_attributes_section.dart` — list view with name + type badge + required/optional badge + edit/delete actions, empty state, "Add Custom Attribute" button (FR-017, FR-018, FR-019)
- [x] T047 [US5] Create `CustomAttributeFormDialog` in `lib/features/time_tracking/presentation/widgets/custom_attribute_form_dialog.dart` — AlertDialog with name (required), field type dropdown (text/number/date/dropdown), required/optional toggle, conditional options list editor for dropdown type
- [x] T048 [US5] Add delete confirmation dialog to `CustomAttributesSection` — AlertDialog confirming deletion
- [x] T049 [US5] Wire `CustomAttributesSection` into `ProjectTimeTrackingSettingsSection` with `BlocProvider<CustomAttributesCubit>` (replaces placeholder from T021)

**Checkpoint**: Custom attribute CRUD works. Dropdown type supports options editor. Required/optional toggle functions.

---

## Phase 8: User Story 6 — Save and Discard Configuration Changes (Priority: P1)

**Goal**: Admin can save or discard all configuration changes with proper feedback (success, error, concurrent edit detection).

**Independent Test**: Make changes → Save → success snackbar → reload → verify persistence. Make changes → Discard → confirm → revert. Simulate save failure → error snackbar with retry.

### Implementation for User Story 6

- [x] T050 [US6] Implement `TimeTrackingSaveBar` widget in `lib/features/time_tracking/presentation/widgets/time_tracking_save_bar.dart` — sticky Positioned bar at bottom with Save + Discard buttons, disabled when no changes (FR-022, FR-023)
- [x] T051 [US6] Add discard confirmation dialog to `TimeTrackingSaveBar` — AlertDialog before reverting (FR-024)
- [x] T052 [US6] Add success SnackBar notification on save completion in `TimeTrackingConfigCubit.save()` (FR-025)
- [x] T053 [US6] Add error SnackBar with "Retry" button on save failure in `TimeTrackingConfigCubit.save()` — keeps unsaved changes editable (FR-031)
- [x] T054 [US6] Implement concurrent edit detection in `TimeTrackingConfigCubit.save()` — compare captured `updatedAt` timestamp with current DB value; if mismatch, emit `Stale` state → show warning banner prompting reload (FR-032)
- [x] T055 [US6] Add `hasChanges` tracking to `TimeTrackingConfigCubit` — compare current state against last saved snapshot to enable/disable save bar buttons (FR-023)
- [x] T056 [US6] Wire `TimeTrackingSaveBar` into `ProjectTimeTrackingSettingsSection` at bottom of layout (replaces placeholder from T023)

**Checkpoint**: Save/discard flow complete. Error handling with retry works. Concurrent edit detection shows warning banner.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Admin-only access, localization, final integration, and validation

- [x] T057 [P] Add admin-only access guard to `ProjectTimeTrackingSettingsSection` — check `project?.owner == 'admin'` or equivalent role check; show access denied if not admin (FR-026), consistent with `ProjectPeopleSettingsSection` pattern
- [ ] T058 [P] Add localization keys for all time tracking strings in `lib/core/localization/app_localizations_en.dart` and `lib/core/localization/app_localizations_ar.dart` — toggle label, section headers, button labels, confirmation dialogs, error messages, empty states
- [x] T059 Verify `AppRouteKeys.projectSettingsTimeTracking` route key exists and maps correctly in `lib/core/constants/app_route_keys.dart`
- [ ] T060 Run full quickstart.md validation scenarios (10 scenarios) to verify end-to-end functionality
- [x] T061 Run `flutter analyze` to verify no lint warnings or errors across all new files
- [x] T062 Code cleanup — verify consistent code style, remove any TODO comments, ensure all files follow existing project conventions

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3-8)**: All depend on Foundational phase completion
  - US1 (Toggle) and US2 (Fields) are P1 — implement first, can be parallel
  - US6 (Save/Discard) is P1 — depends on US1 for the page structure
  - US3 (Aggregation) is P2 — independent after Foundational
  - US4 (Work Types) is P2 — independent after Foundational
  - US5 (Custom Attributes) is P3 — independent after Foundational
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (Toggle, P1)**: Can start after Foundational (Phase 2) — No dependencies on other stories
- **US2 (Fields, P1)**: Can start after Foundational — Depends on US1 for page structure but can be developed in parallel
- **US6 (Save/Discard, P1)**: Can start after Foundational — Depends on US1 for page structure; integrates with all other stories' state
- **US3 (Aggregation, P2)**: Can start after Foundational — Independent, uses TimeTrackingConfigCubit from US1
- **US4 (Work Types, P2)**: Can start after Foundational — Independent, creates own cubit
- **US5 (Custom Attributes, P3)**: Can start after Foundational — Independent, creates own cubit

### Within Each User Story

- Use cases before cubits
- Cubits before widgets
- Widgets before integration into settings section
- Core implementation before polish

### Parallel Opportunities

- T002 + T003 (enum files) — parallel in Setup
- T005 + T006 + T007 + T008 (entities) — parallel in Foundational
- T009 + T010 + T011 + T012 (models) — parallel in Foundational
- T017 + T018 (use cases for US1) — parallel
- T024 (use case for US2) — parallel with US1 tasks
- T030 + T031 + T032 + T033 + T034 (use cases for US4) — parallel
- T041 + T042 + T043 + T044 (use cases for US5) — parallel
- T057 + T058 (polish tasks) — parallel
- Different user stories can be worked on in parallel by different team members after Foundational completes

---

## Parallel Example: User Story 4 (Work Types)

```text
# Launch all use cases together:
Task T030: "Create GetWorkTypes use case in lib/features/time_tracking/domain/usecases/get_work_types.dart"
Task T031: "Create AddWorkType use case in lib/features/time_tracking/domain/usecases/add_work_type.dart"
Task T032: "Create UpdateWorkType use case in lib/features/time_tracking/domain/usecases/update_work_type.dart"
Task T033: "Create DeleteWorkType use case in lib/features/time_tracking/domain/usecases/delete_work_type.dart"
Task T034: "Create ReorderWorkTypes use case in lib/features/time_tracking/domain/usecases/reorder_work_types.dart"

# Then cubit (depends on use cases):
Task T035: "Create WorkTypesCubit in lib/features/time_tracking/presentation/cubits/work_types_cubit.dart"

# Then widgets (depends on cubit):
Task T036: "Implement WorkTypesSection widget in lib/features/time_tracking/presentation/widgets/work_types_section.dart"
Task T037: "Create WorkTypeFormDialog in lib/features/time_tracking/presentation/widgets/work_type_form_dialog.dart"
```

---

## Implementation Strategy

### MVP First (User Stories 1 + 2 + 6)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: US1 (Toggle)
4. Complete Phase 4: US2 (Field Configuration)
5. Complete Phase 8: US6 (Save/Discard)
6. **STOP and VALIDATE**: Admin can enable time tracking, configure fields, save/discard — core workflow works
7. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 + US2 + US6 → Test independently → Deploy/Demo (MVP!)
3. Add US3 (Aggregation) → Test independently → Deploy/Demo
4. Add US4 (Work Types) → Test independently → Deploy/Demo
5. Add US5 (Custom Attributes) → Test independently → Deploy/Demo
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: US1 (Toggle) → US2 (Fields) → US6 (Save/Discard)
   - Developer B: US3 (Aggregation) → US4 (Work Types)
   - Developer C: US5 (Custom Attributes)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- The `time_entries` table schema is defined but the time logging UI is out of scope — only settings/configuration is implemented
- Supabase table creation (RLS policies, indexes) should be done via Supabase dashboard or migration scripts — not covered in these tasks
