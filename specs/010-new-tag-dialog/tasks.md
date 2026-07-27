# Tasks: New Tag Dialog

**Input**: Design documents from `/specs/010-new-tag-dialog/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the feature specification — test tasks omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

**Note on new_tag_form.dart**: This file is a hotspot (modified by T020, T025, T029, T034). All modifications MUST be executed sequentially by a single developer to avoid merge conflicts.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create enums, base entities, and shared widgets needed by all user stories

- [ ] T001 Create TagPermissionScope enum in lib/core/enums/tag_permission_scope_enum.dart
- [ ] T002 [P] Create TagPermissionType enum in lib/core/enums/tag_permission_type_enum.dart
- [ ] T003 [P] Create TagSubscriptionEvent enum in lib/core/enums/tag_subscription_event_enum.dart
- [ ] T004 [P] Create Tag entity in lib/features/issues/domain/entities/tag.dart
- [ ] T005 [P] Create TagPermission entity in lib/features/issues/domain/entities/tag_permission.dart
- [ ] T006 [P] Create TagSubscription entity in lib/features/issues/domain/entities/tag_subscription.dart
- [ ] T007 [P] Create ProjectMember entity in lib/features/issues/domain/entities/project_member.dart
- [ ] T008 [P] Create skeleton shimmer widget in lib/core/widgets/skeleton_shimmer.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Repository interface, data layer, and use case that ALL user stories depend on

**CRITICAL**: No user story work can begin until this phase is complete

- [ ] T009 Create TagsRepository abstract class in lib/features/issues/domain/repositories/tags_repository.dart
- [ ] T010 [P] Create TagModel (fromJson/toJson) in lib/features/issues/data/models/tag_model.dart
- [ ] T011 [P] Create TagRemoteDatasource in lib/features/issues/data/datasources/tag_remote_datasource.dart
- [ ] T012 Create TagsRepositoryImpl in lib/features/issues/data/repositories/tags_repository_impl.dart (depends on T009, T010, T011)
- [ ] T013 Create CreateTag use case in lib/features/issues/domain/usecases/create_tag.dart (depends on T009)
- [ ] T014 [P] Create GetProjectMembers use case in lib/features/issues/domain/usecases/get_project_members.dart (depends on T009)
- [ ] T015 [P] Create IsTagNameUnique use case in lib/features/issues/domain/usecases/is_tag_name_unique.dart (depends on T009)
- [ ] T016 [P] Create AssociateTagWithIssue use case in lib/features/issues/domain/usecases/associate_tag_with_issue.dart (depends on T009)
- [ ] T017 Register TagsRepository in dependency injection in lib/core/init_dependencies.dart

**Checkpoint**: Foundation ready — user story implementation can now begin

---

## Phase 3: User Story 1 — Create a Tag with Default Settings (Priority: P1) MVP

**Goal**: User can open the New Tag dialog, enter a name, click Create, and the tag is created with defaults and associated with the current issue.

**Independent Test**: Open dialog → type name → click Create → verify tag appears in tag list and is linked to the issue.

### Implementation for User Story 1

- [ ] T018 [US1] Create NewTagState in lib/features/issues/presentation/cubits/new_tag_state.dart
- [ ] T019 [US1] Create NewTagCubit in lib/features/issues/presentation/cubits/new_tag_cubit.dart (depends on T018, T013, T014, T015, T016)
- [ ] T020 [US1] Create NewTagForm widget in lib/features/issues/presentation/widgets/new_tag_form.dart (depends on T018, T019)
- [ ] T021 [US1] Create NewTagDialog widget in lib/features/issues/presentation/widgets/new_tag_dialog.dart (depends on T020)
- [ ] T022 [US1] Integrate NewTagDialog into issue form sidebar trigger in lib/features/issues/presentation/widgets/issue_form_sidebar.dart

**Checkpoint**: User Story 1 fully functional — dialog opens, creates tag with defaults, associates with issue

---

## Phase 4: User Story 2 — Configure Tag Permissions (Priority: P2)

**Goal**: User can configure Owner, Can view, Can use, Can edit dropdowns with hybrid permission model, including "Specific Users" secondary picker.

**Independent Test**: Open dialog → change permission dropdowns → select "Specific Users" → pick users → Create → verify permissions saved.

### Implementation for User Story 2

- [ ] T023 [P] [US2] Create TagPermissionsSection widget in lib/features/issues/presentation/widgets/tag_permissions_section.dart (depends on T001, T002, T007)
- [ ] T024 [US2] Create SpecificUsersPicker dialog widget in lib/features/issues/presentation/widgets/specific_users_picker.dart (depends on T007)
- [ ] T025 [US2] Integrate TagPermissionsSection into NewTagForm in lib/features/issues/presentation/widgets/new_tag_form.dart (depends on T023, T024)
- [ ] T026 [US2] Add permission state fields to NewTagState and update cubit logic in lib/features/issues/presentation/cubits/new_tag_cubit.dart (depends on T023)

**Checkpoint**: User Stories 1 AND 2 both functional — permissions configurable and saved on create

---

## Phase 5: User Story 3 — Configure Tag Options and Subscriptions (Priority: P2)

**Goal**: User can toggle Remove on resolution, Shared, Favorite options and select notification subscription events.

**Independent Test**: Open dialog → toggle options → expand Subscriptions → select events → Create → verify all settings saved.

### Implementation for User Story 3

- [ ] T027 [US3] Create TagSubscriptionsSection widget in lib/features/issues/presentation/widgets/tag_subscriptions_section.dart (depends on T003)
- [ ] T028 [US3] Add options and subscription state fields to NewTagState in lib/features/issues/presentation/cubits/new_tag_state.dart (depends on T001, T003)
- [ ] T029 [US3] Integrate TagSubscriptionsSection and options into NewTagForm in lib/features/issues/presentation/widgets/new_tag_form.dart (depends on T027, T028)
- [ ] T030 [US3] Add validation logic for empty/duplicate name in NewTagCubit in lib/features/issues/presentation/cubits/new_tag_cubit.dart (depends on T015, T019)

**Checkpoint**: User Stories 1, 2, AND 3 all functional — full dialog with all options working

---

## Phase 6: User Story 4 — Cancel Tag Creation (Priority: P3)

**Goal**: User can dismiss the dialog via Cancel button, close (X) button, or clicking outside without creating a tag.

**Independent Test**: Open dialog → enter data → click Cancel/close/outside → verify dialog closes and no tag is created.

### Implementation for User Story 4

- [ ] T031 [US4] Add dismiss handling (Cancel, close button, tap outside) to NewTagDialog in lib/features/issues/presentation/widgets/new_tag_dialog.dart
- [ ] T032 [US4] Add scrollable behavior for small screens to NewTagDialog in lib/features/issues/presentation/widgets/new_tag_dialog.dart

**Checkpoint**: All user stories complete — full dialog with cancel/dismiss and responsive scroll

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting multiple user stories

- [ ] T033 Add skeleton/shimmer loading state to Owner dropdown in lib/features/issues/presentation/widgets/tag_permissions_section.dart (depends on T008)
- [ ] T034 Add inline validation error display and help icon tooltip for "Remove on resolution" to NewTagForm in lib/features/issues/presentation/widgets/new_tag_form.dart (sequential — modifies same file as T020/T025/T029)
- [ ] T035 Run quickstart.md validation scenarios and fix any issues

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational (Phase 2)
- **User Story 2 (Phase 4)**: Depends on Foundational (Phase 2) — can run parallel with US1
- **User Story 3 (Phase 5)**: Depends on Foundational (Phase 2) — can run parallel with US1/US2
- **User Story 4 (Phase 6)**: Depends on Phase 3 (US1 dialog exists)
- **Polish (Phase 7)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) — May run parallel with US1
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) — May run parallel with US1/US2
- **User Story 4 (P3)**: Depends on US1 dialog widget existing

### Parallel Opportunities

- T002, T003, T004, T005, T006, T007, T008 (Setup phase — all [P])
- T010, T011, T014, T015, T016 (Foundational phase — [P] items)
- T023 (US2 permissions section) can start immediately after Phase 2
- T027 (US3 subscriptions section) can start immediately after Phase 2
- Different user stories (US1, US2, US3) can be worked on in parallel after Phase 2

---

## Parallel Example: User Story 1

```bash
# Launch all entity creation together:
Task: "Create Tag entity in lib/features/issues/domain/entities/tag.dart"
Task: "Create TagPermission entity in lib/features/issues/domain/entities/tag_permission.dart"
Task: "Create TagSubscription entity in lib/features/issues/domain/entities/tag_subscription.dart"

# Then cubit and form:
Task: "Create NewTagState in lib/features/issues/presentation/cubits/new_tag_state.dart"
Task: "Create NewTagCubit in lib/features/issues/presentation/cubits/new_tag_cubit.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (enums, entities, skeleton widget)
2. Complete Phase 2: Foundational (repository, use cases, DI registration)
3. Complete Phase 3: User Story 1 (dialog with defaults, create tag, associate with issue)
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo (permissions working)
4. Add User Story 3 → Test independently → Deploy/Demo (full options)
5. Add User Story 4 → Test independently → Deploy/Demo (cancel/dismiss)
6. Polish → Final quality pass

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (core dialog + create)
   - Developer B: User Story 2 (permissions section + picker)
   - Developer C: User Story 3 (options + subscriptions section)
3. Stories complete and integrate into shared form

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
