# Tasks: Version Control Settings

**Input**: Design documents from `/specs/007-version-control-settings/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ui-contract.md

**Tests**: Not explicitly requested — test tasks omitted per spec.

**Organization**: Tasks grouped by user story for independent implementation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US7)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Enums, base entities, DI registration, Supabase migration

- [ ] T001 Create VCS enums in lib/core/enums/vcs_provider_type_enum.dart, lib/core/enums/vcs_auth_mode_enum.dart, lib/core/enums/vcs_connection_status_enum.dart, lib/core/enums/vcs_pr_state_enum.dart
- [ ] T002 Create VcsIntegrationEntity in lib/features/version_control/domain/entities/vcs_integration_entity.dart
- [ ] T003 [P] Create VcsUserMappingEntity in lib/features/version_control/domain/entities/vcs_user_mapping_entity.dart
- [ ] T004 [P] Create VcsCommitEntity in lib/features/version_control/domain/entities/vcs_commit_entity.dart
- [ ] T005 [P] Create VcsPullRequestEntity in lib/features/version_control/domain/entities/vcs_pull_request_entity.dart
- [ ] T006 Create VcsIntegrationModel with fromJson/toJson/toInsertJson in lib/features/version_control/data/models/vcs_integration_model.dart
- [ ] T007 [P] Create VcsUserMappingModel in lib/features/version_control/data/models/vcs_user_mapping_model.dart
- [ ] T008 [P] Create VcsCommitModel in lib/features/version_control/data/models/vcs_commit_model.dart
- [ ] T009 [P] Create VcsPullRequestModel in lib/features/version_control/data/models/vcs_pull_request_model.dart
- [ ] T010 Apply Supabase SQL migration (4 tables, indexes, RLS policies) per data-model.md

**Checkpoint**: Entities, models, and database ready — data layer can begin

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Repository interface, remote data source, base use cases, DI wiring — MUST complete before any user story

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T011 Define VcsRepository abstract interface in lib/features/version_control/domain/repositories/vcs_repository.dart
- [ ] T012 Implement VcsRemoteDataSource (Supabase CRUD for vcs_integrations) in lib/features/version_control/data/datasources/vcs_remote_data_source.dart
- [ ] T013 Implement VcsRepositoryImpl wrapping remote data source with Either<Failure, T> in lib/features/version_control/data/repositories/vcs_repository_impl.dart
- [ ] T014 Implement encryption utility (AES-256-GCM encrypt/decrypt) in lib/core/utils/encryption_util.dart
- [ ] T015 Register VCS feature in GetIt DI (data sources, repositories, use cases, cubits) in lib/core/init_dependencies.dart
- [ ] T016 Create base use cases: GetVcsIntegrations, AddVcsIntegration, UpdateVcsIntegration, DeleteVcsIntegration in lib/features/version_control/domain/usecases/
- [ ] T017 [P] Create TestVcsConnection use case in lib/features/version_control/domain/usecases/test_vcs_connection.dart
- [ ] T018 [P] Create ToggleVcsIntegrationStatus use case in lib/features/version_control/domain/usecases/toggle_vcs_integration_status.dart
- [ ] T019 [P] Create VcsIntegrationsCubit (load, add, update, delete, toggle) in lib/features/version_control/presentation/cubits/vcs_integrations_cubit.dart
- [ ] T020 [P] Create VcsConnectionTestCubit in lib/features/version_control/presentation/cubits/vcs_connection_test_cubit.dart
- [ ] T021 Replace placeholder in project_vcs_settings_section.dart to route to VcsSettingsPage in lib/features/projects/presentation/widgets/settings_sections/project_vcs_settings_section.dart

**Checkpoint**: Foundation ready — user story implementation can begin

---

## Phase 3: User Story 1 — View Connected Repositories Table (Priority: P1) 🎯 MVP

**Goal**: Project admin sees all connected repositories in a table with status badges and empty state

**Independent Test**: Navigate to Version Control settings → verify table renders with columns (repo name, service, branches, status, actions) or empty state with CTA

### Implementation for User Story 1

- [ ] T022 [P] [US1] Create VcsStatusBadge widget (green/gray/red/yellow pills) in lib/features/version_control/presentation/widgets/vcs_status_badge.dart
- [ ] T023 [P] [US1] Create VcsRepositoryTable widget with: header row, body rows with hover elevation effect, quick action buttons (edit/toggle/delete) appearing on row hover, checkbox selection, horizontal scroll on small screens in lib/features/version_control/presentation/widgets/vcs_repository_table.dart
- [ ] T024 [US1] Create VcsSettingsPage with BlocConsumer, loading/error/empty/loaded states in lib/features/version_control/presentation/pages/vcs_settings_page.dart
- [ ] T025 [US1] Wire VcsSettingsPage into navigation service at /settings/vcs route in lib/core/services/navigation_service.dart
- [ ] T026 [US1] Add horizontal scrolling wrapper for VcsRepositoryTable on screens below 768px width

**Checkpoint**: User Story 1 fully functional — table displays integrations with status

---

## Phase 4: User Story 2 — Add New Repository Connection (Priority: P1)

**Goal**: Admin can connect a new VCS repo through multi-step dialog with conditional fields

**Independent Test**: Click "Connect to Repository" → select provider → verify conditional fields → authenticate → save → verify row appears in table

### Implementation for User Story 2

- [ ] T027 [P] [US2] Create VcsProviderSelector widget (card grid with logos for 6 providers) in lib/features/version_control/presentation/widgets/vcs_provider_selector.dart
- [ ] T028 [P] [US2] Create VcsAuthFields widget (dynamic fields: OAuth button, Token input, SSH textarea, Passphrase) in lib/features/version_control/presentation/widgets/vcs_auth_fields.dart
- [ ] T029 [P] [US2] Create VcsBranchSpecificationInput widget (tokenized chip input) in lib/features/version_control/presentation/widgets/vcs_branch_specification_input.dart
- [ ] T030 [US2] Create VcsIntegrationFormCubit (provider selection, auth mode, conditional field state, validation) in lib/features/version_control/presentation/cubits/vcs_integration_form_cubit.dart
- [ ] T031 [US2] Create VcsMappingFields widget (org/repo dropdowns populated after auth) in lib/features/version_control/presentation/widgets/vcs_mapping_fields.dart
- [ ] T032 [US2] Create VcsAutomationFields widget (toggle switches for parse commits, silent processing, PR automation, auto user mapping + collapsible command executors section) in lib/features/version_control/presentation/widgets/vcs_automation_fields.dart
- [ ] T033 [US2] Create VcsAddDialog (full dialog: provider selector → auth fields → mapping fields → automation fields → bottom action bar with Test/Save/Cancel) in lib/features/version_control/presentation/widgets/vcs_add_dialog.dart
- [ ] T034 [US2] Implement conditional field logic: server_url visible only for self-hosted providers; token/ssh mutual exclusion; command executors section visible only when parse_commits enabled
- [ ] T035 [US2] Implement Test Connection flow (loading spinner, success/failure snackbar, Save button enable/disable)

**Checkpoint**: User Stories 1 AND 2 both functional — can view table and add integrations

---

## Phase 5: User Story 3 — Configure Commit Parsing (Priority: P1)

**Goal**: Admin can enable commit parsing and select authorized command executor groups

**Independent Test**: Enable parse commits toggle → verify command executors section appears → disable toggle → verify section hides and groups cleared

### Implementation for User Story 3

- [ ] T036 [US3] Implement commit message parser (regex: TASK-ID #Command @username) in lib/features/version_control/domain/utils/commit_parser.dart
- [ ] T037 [US3] Implement command executor group validation (check committer membership before executing commands)
- [ ] T038 [US3] Wire commit parser into webhook/push handler to process incoming commits and update task states
- [ ] T039 [US3] Add VcsCommit persistence (store commit records for VCS Changes tab history)

**Checkpoint**: Commit parsing functional — commits update task states when parsed

---

## Phase 6: User Story 4 — Configure Pull Request Automation (Priority: P1)

**Goal**: Tasks auto-transition on PR open/merge/close events

**Independent Test**: Open PR with task ID in title → task moves to "In Review" → merge PR → task moves to "Merged/Fixed"

### Implementation for User Story 4

- [ ] T040 [US4] Implement PR-to-task linking (auto-parse task ID from PR title/description)
- [ ] T041 [US4] Implement PR state transition logic (onOpen → In Review, onMerge → Merged/Fixed, onClose → revert)
- [ ] T042 [US4] Wire PR webhook handler to process open/merge/close events and trigger transitions
- [ ] T043 [US4] Add VcsPullRequest persistence (store PR records for history)
- [ ] T043a [US4] Create VcsChangesTab widget displaying commit and PR history for a linked task (ordered by most recent first) in lib/features/version_control/presentation/widgets/vcs_changes_tab.dart
- [ ] T043b [US4] Wire VcsChangesTab into the issue detail page as a new tab, respecting visible_to_roles visibility check

**Checkpoint**: PR automation functional — tasks follow PR lifecycle, VCS Changes tab displays history

---

## Phase 7: User Story 5 — Visibility & User Mapping (Priority: P2)

**Goal**: Admin controls VCS Changes tab visibility and configures user mapping

**Independent Test**: Set visibility to specific group → verify non-members can't see VCS Changes tab; add manual mapping → verify commit attribution

### Implementation for User Story 5

- [ ] T044 [P] [US5] Create VcsUserMappingsCubit (load, add, delete mappings) in lib/features/version_control/presentation/cubits/vcs_user_mappings_cubit.dart
- [ ] T045 [P] [US5] Create VcsUserMappingTable widget (email/user columns, add/delete actions) in lib/features/version_control/presentation/widgets/vcs_user_mapping_table.dart
- [ ] T046 [US5] Create use cases: GetVcsUserMappings, AddVcsUserMapping, DeleteVcsUserMapping in lib/features/version_control/domain/usecases/
- [ ] T047 [US5] Implement user mapping resolution (manual override → auto email match fallback)
- [ ] T048 [US5] Implement visibility filtering (check visible_to_roles against user's groups before showing VCS Changes tab)

**Checkpoint**: User mapping and visibility controls functional

---

## Phase 8: User Story 6 — Connection Status & Actions (Priority: P2)

**Goal**: Status badges reflect health; admin can disable/enable/delete integrations

**Independent Test**: Disable integration → verify gray badge and sync stops → enable → verify green badge and sync resumes → delete → verify removed

### Implementation for User Story 6

- [ ] T049 [US6] Implement disable/enable toggle (update status field, preserve all settings)
- [ ] T050 [US6] Implement delete with confirmation dialog
- [ ] T051 [US6] Implement API failure resilience (retry 3x exponential backoff, mark Sync Error status after failures)

**Checkpoint**: Connection management fully functional

---

## Phase 9: User Story 7 — Synchronization Settings (Priority: P2)

**Goal**: Silent processing and branch specification controls work correctly

**Independent Test**: Enable silent processing → push commits → verify no emails sent; set branch spec → verify only matching branches trigger updates

### Implementation for User Story 7

- [ ] T052 [US7] Implement silent processing toggle (suppress email notifications when enabled)
- [ ] T053 [US7] Implement branch specification matching (validate git ref patterns, filter incoming events by branch)
- [ ] T054 [US7] Wire branch specification into commit/PR event handlers to filter by watched branches

**Checkpoint**: All 7 user stories functional

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting multiple stories

- [ ] T055 Implement access control check (admin/owner only for VCS settings page; non-admin sees 403 or hidden)
- [ ] T057 Add snackbar notifications for all CRUD operations (success/error feedback)
- [ ] T058 Run quickstart.md validation scenarios end-to-end
- [ ] T059 Code cleanup and refactoring pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — BLOCKS all user stories
- **Phases 3–9 (User Stories)**: All depend on Phase 2 completion
  - US1, US2, US3, US4 are P1 — implement sequentially for MVP
  - US5, US6, US7 are P2 — can be parallelized after P1 stories
- **Phase 10 (Polish)**: Depends on all desired stories complete

### User Story Dependencies

- **US1 (View Table)**: Independent after Foundational
- **US2 (Add Connection)**: Independent after Foundational — uses US1 table
- **US3 (Commit Parsing)**: Independent after Foundational — requires US2 integration exists
- **US4 (PR Automation)**: Independent after Foundational — requires US2 integration exists
- **US5 (Visibility/Mapping)**: Independent after Foundational — requires US2 integration exists
- **US6 (Status/Actions)**: Extends US1 table — depends on US1
- **US7 (Sync Settings)**: Independent after Foundational — uses US2 form fields

### Parallel Opportunities

```
Phase 1: T001, T002, T003, T004, T005 → parallel
          T006, T007, T008, T009 → parallel
Phase 2: T017, T018, T019, T020 → parallel (different files)
Phase 3: T022, T023 → parallel (different widgets)
Phase 4: T027, T028, T029 → parallel (different widgets)
Phase 7: T044, T045 → parallel (cubit + widget)
```

---

## Implementation Strategy

### MVP First (User Stories 1–4)

1. Complete Phase 1: Setup (enums, entities, models, migration)
2. Complete Phase 2: Foundational (repository, data source, DI)
3. Complete Phase 3: US1 — View Table
4. Complete Phase 4: US2 — Add Connection
5. **STOP and VALIDATE**: Can view table + add integrations
6. Complete Phase 5: US3 — Commit Parsing
7. Complete Phase 6: US4 — PR Automation
8. **STOP and VALIDATE**: Full P1 functionality working

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. US1 → Table view working (MVP checkpoint)
3. US2 → Add dialog working (core flow complete)
4. US3 → Commit parsing working (automation begins)
5. US5 → User mapping working (accuracy improves)
6. US6 → Status management working (operational)
7. US7 → Sync settings working (full feature)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story independently completable after Foundational phase
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
