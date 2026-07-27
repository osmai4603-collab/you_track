# Tasks: Add Members Dialog Redesign

**Input**: Design documents from `/specs/005-add-members-dialog-redesign/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Required by Constitution Principle II (TDD). Widget tests MUST be written before implementation for each user story.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter project**: `lib/features/projects/` at repository root
- **Single file modification**: `lib/features/projects/presentation/pages/add_project_members_page.dart`
- **Test file**: `test/features/projects/presentation/pages/add_project_members_page_test.dart`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Verify existing project structure and dependencies are in place

- [x] T001 Verify ProjectMembersCubit exists in lib/features/projects/presentation/cubits/project_members_cubit.dart
- [x] T002 Verify AddProjectMemberUseCase exists in lib/features/projects/domain/usecases/add_project_member_use_case.dart
- [x] T003 Verify AppRadius constants exist in lib/core/constants/app_radius.dart
- [x] T004 Verify ProjectMemberEntity exists in lib/features/projects/domain/entities/project_member_entity.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 Read current add_project_members_page.dart and document existing overlay-based implementation structure
- [x] T006 Review UI contract at specs/005-add-members-dialog-redesign/contracts/ui-contract.md for target widget tree
- [x] T007 Create test file at test/features/projects/presentation/pages/add_project_members_page_test.dart with basic test setup

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Dialog Layout and Table Structure (Priority: P1) 🎯 MVP

**Goal**: Create the basic dialog layout with search field, table card, and column headers

**Independent Test**: Dialog opens with correct structure, search field visible, table headers displayed

### Tests for User Story 1

- [x] T008 [P] [US1] Write widget test for dialog opens with title "Add People" in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T009 [P] [US1] Write widget test for search field with placeholder text in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T010 [P] [US1] Write widget test for table headers (Name, Add to team, Roles) in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T011 [P] [US1] Verify tests FAIL before implementation (Red phase)

### Implementation for User Story 1

- [x] T012 [P] [US1] Remove overlay-based suggestion system from add_project_members_page.dart (delete _showOverlay, _removeOverlay, _overlayEntry, Overlay.of, CompositedTransformTarget/Follower, _layerLink)
- [x] T013 [P] [US1] Add _selectedMembers Map<String, _SelectedMember> state variable in add_project_members_page.dart
- [x] T014 [US1] Create _buildMembersTableCard() method in add_project_members_page.dart for the table container with border and rounded corners
- [x] T015 [US1] Create _buildTableHeader() method in add_project_members_page.dart for column headers (Name, Add to team, Roles)
- [x] T016 [US1] Create _buildUserRow(ProjectMemberEntity member) method in add_project_members_page.dart for user table rows with avatar, name, email
- [x] T017 [US1] Create _buildGroupRow(String groupName) method in add_project_members_page.dart for group table rows with icon and label
- [x] T018 [US1] Update build() method in add_project_members_page.dart to use new table layout instead of overlay
- [x] T019 [US1] Verify tests PASS (Green phase)

**Checkpoint**: Dialog opens with table structure, headers visible, rows displayed

---

## Phase 4: User Story 2 - Search and Filter Functionality (Priority: P2)

**Goal**: Implement real-time search filtering for users and groups

**Independent Test**: Typing in search field filters the table rows in real-time

### Tests for User Story 2

- [x] T020 [P] [US2] Write widget test for search filters users by name in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T021 [P] [US2] Write widget test for search filters users by email in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T022 [P] [US2] Write widget test for search filters groups by name in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T023 [P] [US2] Verify tests FAIL before implementation (Red phase)

### Implementation for User Story 2

- [x] T024 [US2] Create _filteredUsers getter in add_project_members_page.dart to filter members by search query
- [x] T025 [US2] Create _filteredGroups getter in add_project_members_page.dart to filter groups by search query
- [x] T026 [US2] Update _updateSuggestions() method in add_project_members_page.dart to use new filtering logic
- [x] T027 [US2] Connect search field onChanged to trigger setState with filtered results in add_project_members_page.dart
- [x] T028 [US2] Verify tests PASS (Green phase)

**Checkpoint**: Search filters table rows in real-time

---

## Phase 5: User Story 3 - Toggle Switch and Selection State (Priority: P3)

**Goal**: Implement toggle switches for "Add to team" column with selection state management

**Independent Test**: Toggle switches turn ON/OFF, state updates correctly

### Tests for User Story 3

- [x] T029 [P] [US3] Write widget test for toggle switch appears for each user row in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T030 [P] [US3] Write widget test for toggle switch appears for each group row in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T031 [P] [US3] Write widget test for toggle ON updates selection state in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T032 [P] [US3] Verify tests FAIL before implementation (Red phase)

### Implementation for User Story 3

- [x] T033 [P] [US3] Create _SelectedMember class in add_project_members_page.dart with isSelected, role, isGroup fields and copyWith method
- [x] T034 [US3] Add Switch widget to _buildUserRow() method in add_project_members_page.dart with blue/grey colors
- [x] T035 [US3] Add Switch widget to _buildGroupRow() method in add_project_members_page.dart with blue/grey colors
- [x] T036 [US3] Create _toggleMember(String id, bool isGroup) method in add_project_members_page.dart to update _selectedMembers map
- [x] T037 [US3] Initialize _selectedMembers with all users/groups toggled OFF in initState() of add_project_members_page.dart
- [x] T038 [US3] Verify tests PASS (Green phase)

**Checkpoint**: Toggle switches functional, selection state managed correctly

---

## Phase 6: User Story 4 - Role Selection Dropdown (Priority: P4)

**Goal**: Implement role dropdown in the "Roles" column for each row

**Independent Test**: Dropdown shows role options, selection updates displayed role

### Tests for User Story 4

- [x] T039 [P] [US4] Write widget test for role dropdown appears for each row in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T040 [P] [US4] Write widget test for role dropdown shows available roles in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T041 [P] [US4] Write widget test for role selection updates display in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T042 [P] [US4] Verify tests FAIL before implementation (Red phase)

### Implementation for User Story 4

- [x] T043 [US4] Create _buildRoleDropdown(String memberId) method in add_project_members_page.dart for role selection
- [x] T044 [US4] Define _availableRoles list in add_project_members_page.dart (None, Contributor, Project Admin, System Admin)
- [x] T045 [US4] Create _updateRole(String memberId, String newRole) method in add_project_members_page.dart to update _selectedMembers
- [x] T046 [US4] Add DropdownButton widget to _buildUserRow() and _buildGroupRow() in add_project_members_page.dart
- [x] T047 [US4] Display selected role text in dropdown button in add_project_members_page.dart
- [x] T048 [US4] Verify tests PASS (Green phase)

**Checkpoint**: Role dropdowns functional, selections persisted in state

---

## Phase 7: User Story 5 - Remove Button (Priority: P5)

**Goal**: Implement X button to remove rows from the table

**Independent Test**: Clicking X removes the row from display

### Tests for User Story 5

- [x] T049 [P] [US5] Write widget test for X button appears for each row in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T050 [P] [US5] Write widget test for clicking X removes row from display in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T051 [P] [US5] Verify tests FAIL before implementation (Red phase)

### Implementation for User Story 5

- [x] T052 [US5] Add IconButton with X icon to _buildUserRow() method in add_project_members_page.dart
- [x] T053 [US5] Add IconButton with X icon to _buildGroupRow() method in add_project_members_page.dart
- [x] T054 [US5] Create _removeMember(String id, bool isGroup) method in add_project_members_page.dart to remove from _selectedMembers
- [x] T055 [US5] Create _removedRows Set<String> in add_project_members_page.dart to track removed items
- [x] T056 [US5] Update _filteredUsers and _filteredGroups to exclude removed rows in add_project_members_page.dart
- [x] T057 [US5] Verify tests PASS (Green phase)

**Checkpoint**: Remove buttons functional, rows removed from table

---

## Phase 8: User Story 6 - Action Buttons and Email Invitation (Priority: P6)

**Goal**: Implement Invite/Cancel buttons and email-based invitation

**Independent Test**: Invite adds selected members, Cancel closes dialog, email invitation works

### Tests for User Story 6

- [x] T058 [P] [US6] Write widget test for Invite button appears in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T059 [P] [US6] Write widget test for Cancel button closes dialog in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T060 [P] [US6] Write widget test for license count display in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T061 [P] [US6] Write widget test for empty state message in test/features/projects/presentation/pages/add_project_members_page_test.dart
- [x] T062 [P] [US6] Verify tests FAIL before implementation (Red phase)

### Implementation for User Story 6

- [x] T063 [US6] Update _invite() method in add_project_members_page.dart to iterate _selectedMembers and call addMember() for each toggled-ON member
- [x] T064 [US6] Add FilledButton "Invite" with blue color in action buttons Row in add_project_members_page.dart
- [x] T065 [US6] Add OutlinedButton "Cancel" that calls Navigator.pop() in add_project_members_page.dart
- [x] T066 [US6] Add Text widget for license count "Standard user licenses: 8" in action buttons Row in add_project_members_page.dart
- [x] T067 [US6] Implement email detection in _invite() method - if text contains '@', treat as new user invitation in add_project_members_page.dart
- [x] T068 [US6] Add empty state message "No members found" when search returns no results in add_project_members_page.dart
- [x] T069 [US6] Add empty state message "No members available to add" when table is empty in add_project_members_page.dart
- [x] T070 [US6] Add empty state message "Type to see more relevant options" when typing with no results in add_project_members_page.dart
- [x] T071 [US6] Verify tests PASS (Green phase)

**Checkpoint**: All action buttons functional, email invitation working

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T072 [P] Add Semantics labels to TextField search field in add_project_members_page.dart
- [x] T073 [P] Add Semantics labels to all Switch widgets in add_project_members_page.dart
- [x] T074 [P] Add Semantics labels to all DropdownButton widgets in add_project_members_page.dart
- [x] T075 [P] Add Semantics labels to all IconButton widgets in add_project_members_page.dart
- [x] T076 [P] Add visual feedback (ink splash) on hover/tap for table rows in add_project_members_page.dart
- [x] T077 Run flutter analyze to verify no linting errors
- [x] T078 Run flutter test to verify all tests pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: All depend on Foundational phase completion
  - US1 must complete first (creates table structure)
  - US2-US6 depend on US1 (use table rows)
  - US2-US5 can run in parallel after US1
  - US6 depends on US3 (needs selection state)
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Requires US1 table structure - Can run parallel with US3, US4, US5
- **User Story 3 (P3)**: Requires US1 table structure - Can run parallel with US2, US4, US5
- **User Story 4 (P4)**: Requires US1 table structure - Can run parallel with US2, US3, US5
- **User Story 5 (P5)**: Requires US1 table structure - Can run parallel with US2, US3, US4
- **User Story 6 (P6)**: Requires US1 (table) + US3 (selection state) - Must wait for US1 and US3

### Within Each User Story

- Tests FIRST (Red phase) before any implementation
- Models/state classes before widgets
- Widgets before callbacks
- Callbacks before integration
- Implementation complete before verification (Green phase)

### Parallel Opportunities

- All Setup tasks (T001-T004) can run in parallel
- All Foundational tasks (T005-T007) can run in parallel
- All tests within a story (e.g., T008-T010) can run in parallel
- US2, US3, US4, US5 can run in parallel after US1 completes
- All Polish tasks marked [P] (T072-T076) can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Write widget test for dialog opens with title"
Task: "Write widget test for search field with placeholder text"
Task: "Write widget test for table headers"

# Verify tests FAIL (Red phase):
Task: "Verify tests FAIL before implementation"

# Launch implementation tasks:
Task: "Remove overlay-based suggestion system"
Task: "Add _selectedMembers Map state variable"

# Sequential implementation:
Task: "Create _buildMembersTableCard() method"
Task: "Create _buildTableHeader() method"
Task: "Create _buildUserRow() method"
Task: "Create _buildGroupRow() method"
Task: "Update build() method"

# Verify tests PASS (Green phase):
Task: "Verify tests PASS"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T004)
2. Complete Phase 2: Foundational (T005-T007)
3. Complete Phase 3: User Story 1 (T008-T019)
4. **STOP and VALIDATE**: Run `flutter test` - all US1 tests should pass
5. Demo: Dialog opens with table structure

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. US1 (Dialog Layout) → Test → Deploy/Demo (MVP!)
3. US2 (Search) → Test → Deploy/Demo
4. US3 (Toggle) → Test → Deploy/Demo
5. US4 (Role Dropdown) → Test → Deploy/Demo
6. US5 (Remove Button) → Test → Deploy/Demo
7. US6 (Action Buttons) → Test → Deploy/Demo
8. Polish → Final verification

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. After Foundational:
   - Developer A: US1 tests + implementation
3. After US1 completes:
   - Developer A: US2 (Search)
   - Developer B: US3 (Toggle)
   - Developer C: US4 (Role Dropdown)
   - Developer D: US5 (Remove Button)
4. After US3 completes:
   - Developer A: US6 (Action Buttons)
5. All developers: Polish phase

---

## Notes

- [P] tasks = can run in parallel (different concerns, no dependencies)
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Write tests FIRST, verify they FAIL, then implement, then verify they PASS
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- All implementation tasks modify: `lib/features/projects/presentation/pages/add_project_members_page.dart`
- All test tasks modify: `test/features/projects/presentation/pages/add_project_members_page_test.dart`
