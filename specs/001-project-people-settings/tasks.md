# Tasks: Project People Settings Redesign

**Input**: Design documents from `/specs/001-project-people-settings/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are included per constitution Principle II (TDD) and quickstart.md validation scenarios.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Localization Keys)

**Purpose**: Add all new localization keys to ARB files before widget implementation

- [X] T001 [P] Add new English localization keys (searchMembersHint, teamRolesLabel, ownerLabel, projectOwnerBadge, removeMemberAction, removeMemberConfirmTitle, removeMemberConfirmBody, emptyMembersTitle, accessDeniedTitle, accessDeniedBody) to lib/core/localization/app_en.arb
- [X] T002 [P] Add matching Arabic localization keys to lib/core/localization/app_ar.arb
- [X] T003 Run `flutter gen-l10n` to regenerate localization files

---

## Phase 2: Foundational (Cubit Search State)

**Purpose**: Add searchQuery to ProjectMembersCubit — must complete before any UI work

**⚠️ CRITICAL**: No widget work can begin until this phase is complete

- [X] T004 Add `searchQuery` field (default: `''`) to `ProjectMembersState` in lib/features/projects/presentation/cubits/project_members_cubit.dart
- [X] T005 Add `updateSearchQuery(String query)` method to `ProjectMembersCubit` in lib/features/projects/presentation/cubits/project_members_cubit.dart
- [X] T006 Update `copyWith` method in `ProjectMembersState` to include `searchQuery` parameter

**Checkpoint**: Cubit supports search state — widget implementation can begin

---

## Phase 3: User Story 1 — View Team Members Table (Priority: P1) 🎯 MVP

**Goal**: Display a YouTrack-style table with member avatars, names, emails, and role chips, with owner badge

**Independent Test**: Widget renders team members in a table with Name/Roles columns, avatars, and owner badge visible

### Implementation for User Story 1

- [X] T007 [P] [US1] Define role color mapping constant (`_roleColors` map) in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T008 [P] [US1] Implement `_buildProjectTeamHeader` method showing "Project Team" title with member count badge and owner info in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T009 [P] [US1] Implement `_buildTeamRolesFilter` dropdown in the header area that filters members by their assigned role in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T010 [P] [US1] Implement `_buildMembersTableHeader` method with "Name" and "Roles" column headers in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T011 [US1] Implement `_buildMemberRow` method displaying avatar (initials), name, email, owner badge, and role chips in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T012 [US1] Implement `_buildRoleChip` method rendering individual role chips with color mapping in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T013 [US1] Implement `_buildEmptyState` method with illustration icon and "No team members yet" message in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T014 [US1] Wire up `BlocBuilder<ProjectMembersCubit, ProjectMembersState>` to render team members in the table in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart

**Checkpoint**: Team members table displays correctly with avatars, names, emails, role chips, owner badge, and team roles filter

---

## Phase 4: User Story 2 — Search and Filter (Priority: P1)

**Goal**: Real-time search filtering across member names and emails

**Independent Test**: Typing in the search bar instantly filters the member list; clearing restores full list

### Implementation for User Story 2

- [X] T015 [US2] Implement `_buildSearchFilterBar` method with TextField, "+" button (placeholder), and search icon in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T016 [US2] Connect search TextField `onChanged` to `context.read<ProjectMembersCubit>().updateSearchQuery()` in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T017 [US2] Implement client-side filtering logic: split `members` into `teamMembers` (roles.isNotEmpty) and `otherPeople` (roles.isEmpty) based on `searchQuery` in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart

**Checkpoint**: Search bar filters members in real-time by name and email

---

## Phase 5: User Story 3 — Role Chip Interaction (Priority: P2)

**Goal**: Clicking a role chip opens a dropdown to assign/remove roles

**Independent Test**: Tapping a role chip shows a popup with available roles; toggling a role updates the chip display

### Implementation for User Story 3

- [X] T018 [US3] Implement role editor `PopupMenuButton` with multi-select checkboxes for available roles in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T019 [US3] Add role toggle logic: update member's roles list locally within StatefulWidget state when a role is checked/unchecked in the dropdown (no cubit call) in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart

**Checkpoint**: Role chips are interactive; clicking opens dropdown; role changes update local state only

---

## Phase 6: User Story 4 — Other People with Access (Priority: P2)

**Goal**: Display members with empty roles in a separate section below the team table

**Independent Test**: Members with no roles appear in "Other People with Access" section; members with roles appear in team table

### Implementation for User Story 4

- [X] T020 [US4] Implement `_buildOtherPeopleSection` method with "Other People with Access" header and member list in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T021 [US4] Filter `members` list: `roles.isEmpty` → display in "Other People" section in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T022 [US4] Render "Other People" rows with checkbox, avatar, name, and "None" role indicator in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart

**Checkpoint**: Two distinct sections render: "Project Team" (roles.isNotEmpty) and "Other People with Access" (roles.isEmpty)

---

## Phase 7: User Story 5 — Member Row Context Menu (Priority: P2)

**Goal**: Three-dot menu on each row with "Remove member" action and confirmation dialog

**Independent Test**: Clicking "..." shows "Remove member"; confirming removes member from list; owner row has no menu

### Implementation for User Story 5

- [X] T023 [US5] Implement `_buildMemberContextMenu` method using `PopupMenuButton` with "Remove member" option; removal updates local StatefulWidget state only (no cubit call) in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T024 [US5] Implement confirmation `AlertDialog` for member removal with title, body, and Cancel/Remove buttons in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T025 [US5] Hide or disable context menu for project owner (`isOwner == true`) in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart

**Checkpoint**: Context menu works for non-owner members; owner has no menu; removal updates local state only

---

## Phase 8: User Story 6 — Access Control Gate (Priority: P1)

**Goal**: Only Project Admins and System Admins can view the page

**Independent Test**: Non-admin users see "Access Denied" message instead of the settings content

### Implementation for User Story 6

- [X] T026 [US6] Implement `_buildAccessDeniedView` method with "Access Denied" title and permission message in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T027 [US6] Add admin role check logic using `ProjectDetailsCubit` state to determine if current user is admin in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T028 [US6] Conditionally render `_buildAccessDeniedView` or main content based on admin status in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart

**Checkpoint**: Access control gate prevents non-admin users from seeing the settings content

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Widget file cleanup, accessibility, performance validation, and final validation

- [X] T029 Ensure total widget file stays under 300 lines per constitution Principle V; split into separate widget files if exceeded in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T030 [P] Add `Semantics` labels to all interactive elements (search, chips, context menu, checkboxes) in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T031 [P] Add visual feedback on hover/tap for all interactive elements in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T032 [P] Implement loading indicator (CircularProgressIndicator) and error message display for member list states per SC-003 in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T033 [P] Verify search/filter responds within 500ms for 100 members per SC-001 in lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart
- [X] T034 Run `flutter analyze` and fix any lint issues
- [X] T035 Run `flutter test test/features/projects/presentation/widgets/settings_sections/project_people_settings_section_test.dart` and verify all tests pass
- [X] T036 Run quickstart.md validation scenarios manually

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 completion — BLOCKS all user stories
- **Phases 3-8 (User Stories)**: All depend on Phase 2 completion
  - US1 (View Table) — P1 MVP, start first
  - US2 (Search) — P1, depends on US1 table structure
  - US3 (Role Chips) — P2, depends on US1 role chip rendering
  - US4 (Other People) — P2, depends on US1 table structure
  - US5 (Context Menu) — P2, depends on US1 member row structure
  - US6 (Access Control) — P1, independent of other stories
- **Phase 9 (Polish)**: Depends on all desired user stories being complete

### User Story Dependencies

- **US1 (View Table)**: Can start after Phase 2 — No dependencies on other stories
- **US2 (Search)**: Depends on US1 (needs table structure to filter)
- **US3 (Role Chips)**: Depends on US1 (needs role chip rendering)
- **US4 (Other People)**: Depends on US1 (needs table structure)
- **US5 (Context Menu)**: Depends on US1 (needs member row structure)
- **US6 (Access Control)**: Can start after Phase 2 — Independent

### Within Each User Story

- Implementation tasks within a story can proceed sequentially
- Different files (cubit vs widget) can be worked on in parallel

### Parallel Opportunities

- Phase 1: T001 and T002 can run in parallel (different ARB files)
- Phase 3: T007, T008, T009, T010 can run in parallel (different helper methods)
- Phase 9: T030, T031, T032, T033 can run in parallel (different concerns)
- US6 is independent of US1-US5 and can be implemented in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all parallel tasks for US1 together:
Task: "Define role color mapping constant in project_people_settings_section.dart"
Task: "Implement _buildProjectTeamHeader method in project_people_settings_section.dart"
Task: "Implement _buildTeamRolesFilter dropdown in project_people_settings_section.dart"
Task: "Implement _buildMembersTableHeader method in project_people_settings_section.dart"

# Then sequential tasks:
Task: "Implement _buildMemberRow method in project_people_settings_section.dart"
Task: "Implement _buildRoleChip method in project_people_settings_section.dart"
Task: "Implement _buildEmptyState method in project_people_settings_section.dart"
Task: "Wire up BlocBuilder to render team members in project_people_settings_section.dart"
```

---

## Implementation Strategy

### MVP First (US1 + US2 + US6)

1. Complete Phase 1: Setup (localization keys)
2. Complete Phase 2: Foundational (cubit search state)
3. Complete Phase 3: US1 — View Team Members Table
4. Complete Phase 4: US2 — Search and Filter
5. Complete Phase 8: US6 — Access Control Gate
6. **STOP and VALIDATE**: Run quickstart.md scenarios V1, V2, V6
7. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (View Table) → Test independently → Deploy/Demo (MVP!)
3. Add US2 (Search) → Test independently → Deploy/Demo
4. Add US3 (Role Chips) → Test independently → Deploy/Demo
5. Add US4 (Other People) → Test independently → Deploy/Demo
6. Add US5 (Context Menu) → Test independently → Deploy/Demo
7. Add US6 (Access Control) → Test independently → Deploy/Demo
8. Polish → Final validation → Release

---

## Notes

- [P] tasks = different files or methods, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Constitution Principle V: Keep widget file under 300 lines; split if exceeded
- Role toggle (US3) and member removal (US5) are local UI-only state — no cubit methods
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
