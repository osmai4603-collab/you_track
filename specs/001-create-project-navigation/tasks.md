# Tasks: Create Project Navigation

**Input**: Design documents from `/specs/001-create-project-navigation/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Included per constitution Principle II (TDD — widget tests for button navigation).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter feature-first**: `lib/features/<feature>/presentation/widgets/`
- **Tests**: `test/features/<feature>/presentation/widgets/`
- Paths assume the existing project structure per `lib/` layout

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: No project initialization needed — this is a single-file edit on an existing Flutter project.

No tasks in this phase.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No foundational infrastructure needed — all routes, cubits, and pages already exist.

No tasks in this phase.

---

## Phase 3: User Story 1 - Navigate to Create Project Form (Priority: P1) 🎯 MVP

**Goal**: Wire the "Create Project" button in the shared header to navigate to the template selection page.

**Independent Test**: Navigate to the Projects section, tap "Create Project", verify the template selection page loads.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T001 [P] [US1] Create widget test for "Create Project" button tap navigation in `test/features/dashboards/presentation/widgets/dashboard_body_header_test.dart`
- [X] T002 [US1] Verify test fails (button does nothing currently) by running `flutter test test/features/dashboards/presentation/widgets/dashboard_body_header_test.dart`

### Implementation for User Story 1

- [X] T003 [US1] Add import for `app_route_keys.dart` in `lib/features/dashboards/presentation/widgets/dashboard_body_header.dart`
- [X] T004 [US1] Wire `onPressed` callback on the "Create Project" `_ActionButton` (line 119) to `() => context.go(AppRouteKeys.projectTemplates)` in `lib/features/dashboards/presentation/widgets/dashboard_body_header.dart`
- [X] T005 [US1] Run widget test to verify it passes: `flutter test test/features/dashboards/presentation/widgets/dashboard_body_header_test.dart`

**Checkpoint**: User Story 1 complete — button navigates to template selection. MVP delivered.

---

## Phase 4: User Story 2 - Form Page Accessible via Direct Navigation (Priority: P2)

**Goal**: Verify the create project form page works when navigated to directly via `/projects/new`.

**Independent Test**: Navigate directly to `/projects/new` and verify the form page loads.

### Tests for User Story 2

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T006 [P] [US2] Create widget test for direct route access to `/projects/new` in `test/features/projects/presentation/pages/create_project_form_page_test.dart`
- [X] T007 [US2] Verify test passes (route already works — this is a regression test)

### Implementation for User Story 2

- [X] T008 [US2] Verify existing route `/projects/new` loads `CreateProjectFormPage` correctly by manual testing or automated test assertion

**Checkpoint**: User Stories 1 AND 2 both work independently.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and CI gate compliance.

- [X] T009 [P] Run `flutter analyze` and verify zero issues
- [X] T010 [P] Run `flutter test` and verify all tests pass
- [X] T011 Run quickstart.md validation scenarios manually

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — skipped (not needed)
- **Foundational (Phase 2)**: No dependencies — skipped (not needed)
- **User Story 1 (Phase 3)**: Can start immediately — no prerequisites
- **User Story 2 (Phase 4)**: Can start immediately — no prerequisites on US1
- **Polish (Phase 5)**: Depends on US1 and US2 being complete

### User Story Dependencies

- **User Story 1 (P1)**: Independent — starts immediately
- **User Story 2 (P2)**: Independent — starts immediately (regression test for existing route)

### Within Each User Story

- Tests MUST be written and FAIL before implementation (TDD)
- Implementation after tests
- Verification after implementation

### Parallel Opportunities

- T001 and T006 can run in parallel (different test files)
- T009 and T010 can run in parallel (analyze and test are independent)

---

## Parallel Example: User Story 1

```bash
# Write test first:
Task: "Create widget test in test/features/dashboards/presentation/widgets/dashboard_body_header_test.dart"

# Then implement (after test fails):
Task: "Add import and wire onPressed in lib/features/dashboards/presentation/widgets/dashboard_body_header.dart"

# Then verify:
Task: "Run flutter test to verify test passes"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Write widget test (T001)
2. Verify test fails (T002)
3. Wire button callback (T003 + T004)
4. Verify test passes (T005)
5. **STOP and VALIDATE**: Button navigates to template selection

### Incremental Delivery

1. US1 complete → Button works → MVP!
2. US2 complete → Direct route verified → Full coverage
3. Polish → CI gate passes → Ready for PR

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Tests are included per constitution Principle II (TDD mandatory)
- This feature is a single-file edit — tasks are intentionally granular for TDD compliance
- The `go_router` import is already present in `dashboard_body_header.dart` (via `YouTrackShell` usage) — only `app_route_keys.dart` needs adding
- Commit after each logical group (test, implementation, verification)
