# Tasks: YouTrack Issue Form Rebuild

**Input**: Design documents from `/specs/001-youtrack-issue-form/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Migration and entity extension that all user stories depend on

- [x] T001 Create Supabase migration `supabase/migrations/20260727000000_add_issue_visibility.sql` with visibility jsonb column, GIN index, and RLS policy per data-model.md
- [x] T002 Extend `Issue` entity with `visibility` field (`List<String>`, default `['team']`) and update `copyWith`/`props` in `lib/features/issues/domain/entities/issue.dart`
- [x] T003 Extend `IssueModel` with visibility field, update `fromJson`/`toJson` serialization in `lib/features/issues/data/models/issue_model.dart`
- [x] T004 Create new enums in `lib/features/issues/presentation/cubits/`: `DescriptionFormat` (visual, markdown) and `AttachmentStatus` (pending, uploading, uploaded, error)
- [x] T005 Create `IssueAttachment` model in `lib/features/issues/domain/entities/issue_attachment.dart` with fields: id, fileName, fileSize, mimeType, uploadProgress, storagePath, status

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Repository/data source contracts and cubit that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T006 Extend `IssuesRepository` abstract class with `createIssue`, `updateIssue`, `deleteIssue`, `uploadAttachment`, `deleteAttachment`, `getAttachments` method signatures in `lib/features/issues/domain/repositories/issues_repository.dart`
- [x] T007 Extend `IssuesRemoteDataSource` abstract class with CRUD and upload method signatures in `lib/features/issues/data/datasources/issues_remote_data_source.dart`
- [x] T008 Implement `createIssue` in `IssuesRepositoryImpl` — insert into Supabase `issues` table with all fields including visibility in `lib/features/issues/data/repositories/issues_repository_impl.dart`
- [x] T009 Implement `updateIssue` in `IssuesRepositoryImpl` — Supabase update with partial fields in `lib/features/issues/data/repositories/issues_repository_impl.dart`
- [x] T010 Implement `deleteIssue` in `IssuesRepositoryImpl` — Supabase delete by ID in `lib/features/issues/data/repositories/issues_repository_impl.dart`
- [x] T011 Implement `uploadAttachment` in `IssuesRemoteDataSourceImpl` — Supabase Storage `uploadBinary` with progress callback, path `issues/{issue_id}/{filename}` in `lib/features/issues/data/datasources/issues_remote_data_source.dart`
- [x] T012 Implement `uploadAttachment` in `IssuesRepositoryImpl` wrapping data source in `lib/features/issues/data/repositories/issues_repository_impl.dart`
- [x] T013 Create `IssueFormState` class extending Equatable with all form fields (summary, description, descriptionFormat, priority, state, issueType, assigneeId, subsystem, fixVersions, fixedInBuild, estimation, spentTime, visibility, attachments, validationErrors, isSubmitting, isEditing, issueId, projectKey, errorMessage) and `copyWith` in `lib/features/issues/presentation/cubits/issue_form_state.dart`
- [x] T014 Create `IssueFormCubit` with all field update methods, `submit` (create/update), `delete`, `cancel`, validation logic in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T015 Register `IssueFormCubit` as factory in `lib/core/init_dependencies.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Create Issue with Rich Editor (Priority: P1) 🎯 MVP

**Goal**: User can create a new issue with summary, rich text description, file attachments, and sidebar properties

**Independent Test**: Navigate to `/issues/new-issue?project=DEM`, fill summary, format description, attach a file, set properties, click Create — issue is created and detail view is shown

### Implementation for User Story 1

- [x] T016 [P] [US1] Create `IssueFormTopBar` widget with summary input field (max 255, character count), lightbulb/paperclip/@/three-dot/star icons in `lib/features/issues/presentation/widgets/issue_form_top_bar.dart`
- [x] T017 [P] [US1] Create `IssueFormToolbar` widget with FleatherToolbar.basic plus custom buttons (heading dropdown, text color, table, image embed) in `lib/features/issues/presentation/widgets/issue_form_toolbar.dart`
- [x] T018 [P] [US1] Create `IssueFormAttachmentZone` widget with drop zone, file picker, attached files list with remove button, upload progress indicators in `lib/features/issues/presentation/widgets/issue_form_attachment_zone.dart`
- [x] T019 [P] [US1] Create `IssueFormSidebar` widget with all 10 compact property fields (Project read-only, Priority, State, Type, Assignee, Subsystem, Fix Versions, Fixed in Build, Estimation, Spent Time) using existing `CompactFieldWidget` pattern in `lib/features/issues/presentation/widgets/issue_form_sidebar.dart`
- [x] T020 [P] [US1] Create `IssueFormActionBar` widget with Create button (blue), Cancel button (outline), Visible to dropdown, Delete button (red, edit-mode only) in `lib/features/issues/presentation/widgets/issue_form_action_bar.dart`
- [x] T021 [US1] Create `IssueVisibilityPicker` dialog with grouped checkbox list (Project team / Registered users sections) in `lib/features/issues/presentation/widgets/issue_visibility_picker.dart`
- [x] T022 [US1] Rebuild `IssueForm` page as StatefulWidget with LayoutBuilder for responsive layout, BlocProvider<IssueFormCubit>, assembling top bar, toolbar, editor (FleatherEditor), attachment zone, sidebar, action bar in `lib/features/issues/presentation/pages/issue_form.dart`
- [x] T023 [US1] Add route for issue creation (`/issues/new-issue?project=:projectKey`) wrapping IssueForm in BlocProvider in `lib/core/services/navigation_service.dart`

**Checkpoint**: User Story 1 should be fully functional — user can create an issue with rich text, attachments, and properties

---

## Phase 4: User Story 2 - Visual/Markdown Toggle (Priority: P2)

**Goal**: User can switch between WYSIWYG and Markdown editing modes with content preservation

**Independent Test**: Open form, type in Visual mode, switch to Markdown — raw markdown shown. Switch back — formatting preserved. Create issue — description persists correctly.

### Implementation for User Story 2

- [x] T024 [US2] Add Visual/Markdown toggle buttons to `IssueFormToolbar` widget with mode indicator in `lib/features/issues/presentation/widgets/issue_form_toolbar.dart`
- [x] T025 [US2] Implement format conversion logic in `IssueFormCubit`: `updateDescriptionFormat` converts Fleather document to markdown and back without data loss in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T026 [US2] Add conditional editor rendering in `IssueForm` page: show FleatherEditor in visual mode, show TextField with markdown in markdown mode in `lib/features/issues/presentation/pages/issue_form.dart`

**Checkpoint**: Visual/Markdown toggle works without content loss

---

## Phase 5: User Story 3 - Edit Existing Issue (Priority: P1)

**Goal**: User can open an existing issue in the form, modify fields, and save changes

**Independent Test**: Open an existing issue — all fields pre-populated. Change summary and priority. Click Create (Update). Verify issue is updated in detail view.

### Implementation for User Story 3

- [x] T027 [US3] Add `initWithIssue(Issue issue)` method to `IssueFormCubit` that populates all form fields from existing issue data in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T028 [US3] Update `IssueForm` page to accept optional `issueId` parameter, call `initWithIssue` when in edit mode in `lib/features/issues/presentation/pages/issue_form.dart`
- [x] T029 [US3] Add edit route (`/issues/:issueId/edit`) wrapping IssueForm with BlocProvider in `lib/core/services/navigation_service.dart`
- [x] T030 [US3] Update action bar to show "Update" label instead of "Create" in edit mode in `lib/features/issues/presentation/widgets/issue_form_action_bar.dart`

**Checkpoint**: Edit mode fully functional with pre-populated fields and update flow

---

## Phase 6: User Story 4 - Cancel & Delete (Priority: P2)

**Goal**: User can cancel issue creation (discard changes) and delete existing issues

**Independent Test**: Start creating issue, click Cancel — navigates back without saving. Open existing issue, click Delete — confirmation dialog appears, confirm — issue is deleted.

### Implementation for User Story 4

- [x] T031 [US4] Implement `cancel()` method in `IssueFormCubit` — checks for unsaved changes, shows confirmation if dirty, navigates back in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T032 [US4] Implement `delete()` method in `IssueFormCubit` — calls repository deleteIssue, handles success/error in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T033 [US4] Add unsaved changes detection (WillPopScope) to `IssueForm` page with discard/keep editing dialog in `lib/features/issues/presentation/pages/issue_form.dart`

**Checkpoint**: Cancel and delete flows work with proper confirmations

---

## Phase 7: User Story 5 - Visibility Configuration (Priority: P2)

**Goal**: User can configure issue visibility to team, registered users, or specific individuals

**Independent Test**: Open form, click "Visible to", select "Registered users" — visibility saved. Select "Select specific users" — picker dialog opens, select users — saved correctly.

### Implementation for User Story 5

- [x] T034 [US5] Create `IssueVisibilityPicker` dialog with grouped checkbox list (Project team / Registered users sections) in `lib/features/issues/presentation/widgets/issue_visibility_picker.dart`
- [x] T035 [US5] Integrate visibility picker with `IssueFormCubit.updateVisibility` in action bar dropdown in `lib/features/issues/presentation/widgets/issue_form_action_bar.dart`

**Checkpoint**: Visibility configuration fully functional

---

## Phase 8: User Story 6 - Responsive Layout (Priority: P2)

**Goal**: Form layout adapts between desktop (side-by-side) and mobile (stacked) layouts

**Independent Test**: Open form on wide screen (>800px) — sidebar to the right. Resize to narrow (<800px) — sidebar below content. All fields remain accessible.

### Implementation for User Story 6

- [x] T036 [US6] Implement `LayoutBuilder` breakpoint logic (800px) in `IssueForm` page — Row layout for wide, Column layout for narrow in `lib/features/issues/presentation/pages/issue_form.dart`
- [x] T037 [US6] Ensure sidebar widget fills width on narrow screens and has fixed width (~280px) on wide screens in `lib/features/issues/presentation/widgets/issue_form_sidebar.dart`

**Checkpoint**: Responsive layout works at all breakpoints

---

## Phase 9: User Story 7 - Top Bar Quick Actions (Priority: P3)

**Goal**: Quick action icons (lightbulb, paperclip, @, three-dot menu, star) are functional

**Independent Test**: Click paperclip — file picker opens. Click @ — team member picker shows. Three-dot menu shows copy link, export markdown, create sub-issue options.

### Implementation for User Story 7

- [x] T038 [P] [US7] Implement paperclip icon action — triggers file attachment picker in `lib/features/issues/presentation/widgets/issue_form_top_bar.dart`
- [x] T039 [P] [US7] Implement @ mention icon — shows team member picker dropdown in `lib/features/issues/presentation/widgets/issue_form_top_bar.dart`
- [x] T040 [P] [US7] Implement three-dot overflow menu with "Copy issue link", "Export as markdown", "Create sub-issue" actions in `lib/features/issues/presentation/widgets/issue_form_top_bar.dart`
- [x] T041 [P] [US7] Implement star icon toggle — calls cubit to toggle isStarred in `lib/features/issues/presentation/widgets/issue_form_top_bar.dart`

**Checkpoint**: All quick action icons functional

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Final touches, validation, and cleanup

- [x] T042 [P] Add input validation to `IssueFormCubit` — summary required (non-empty, max 255), attachment size/type limits per data-model.md validation rules in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T043 [P] Add error handling for network failures during submit — show SnackBar notification, preserve form data in `lib/features/issues/presentation/cubits/issue_form_cubit.dart`
- [x] T044 [P] Add localization strings for all new UI text to ARB files in `lib/core/localization/app_en.arb` and `lib/core/localization/app_ar.arb`
- [x] T045 Run `flutter analyze` and fix any lint issues
- [x] T046 Run quickstart.md validation scenarios V1–V14 to verify end-to-end functionality

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 completion — BLOCKS all user stories
- **Phases 3–9 (User Stories)**: All depend on Phase 2 completion
  - Phase 3 (US1) and Phase 5 (US3) are P1 — highest priority
  - Phase 4 (US2), Phase 6 (US4), Phase 7 (US5), Phase 8 (US6) are P2
  - Phase 9 (US7) is P3 — lowest priority
- **Phase 10 (Polish)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (Create Issue)**: Can start after Phase 2 — No dependencies on other stories
- **US2 (Visual/Markdown)**: Can start after Phase 2 — Extends US1 toolbar but independently testable
- **US3 (Edit Issue)**: Can start after Phase 2 — Extends US1 form but independently testable
- **US4 (Cancel/Delete)**: Can start after Phase 2 — Extends US1/US3 but independently testable
- **US5 (Visibility)**: Can start after Phase 2 — Uses US1 action bar but independently testable
- **US6 (Responsive)**: Can start after Phase 2 — Modifies US1 layout but independently testable
- **US7 (Quick Actions)**: Can start after Phase 2 — Extends US1 top bar but independently testable

### Within Each User Story

- Models/entities before widgets
- Cubit logic before UI wiring
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Phase 1 tasks are sequential (entity changes depend on each other)
- Phase 2 tasks T008–T012 (repository/data source implementations) can run in parallel
- Phase 3 widgets T016–T020 can all run in parallel (different files, no dependencies)
- Phase 9 icons T038–T041 can all run in parallel (different files)
- Different user stories can be worked on in parallel by different team members after Phase 2

---

## Parallel Example: User Story 1

```bash
# Launch all Phase 3 widgets in parallel:
Task: "Create IssueFormTopBar widget in lib/features/issues/presentation/widgets/issue_form_top_bar.dart"
Task: "Create IssueFormToolbar widget in lib/features/issues/presentation/widgets/issue_form_toolbar.dart"
Task: "Create IssueFormAttachmentZone widget in lib/features/issues/presentation/widgets/issue_form_attachment_zone.dart"
Task: "Create IssueFormSidebar widget in lib/features/issues/presentation/widgets/issue_form_sidebar.dart"
Task: "Create IssueFormActionBar widget in lib/features/issues/presentation/widgets/issue_form_action_bar.dart"

# After widgets complete, wire up the page:
Task: "Rebuild IssueForm page in lib/features/issues/presentation/pages/issue_form.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (migration, entity extension)
2. Complete Phase 2: Foundational (repository, cubit)
3. Complete Phase 3: User Story 1 (create issue with rich editor)
4. **STOP and VALIDATE**: Run quickstart V1, V2, V3, V5, V12
5. Deploy/demo if ready

### Incremental Delivery

1. Phase 1 + Phase 2 → Foundation ready
2. Phase 3 (US1) → Test independently → Deploy/Demo (MVP!)
3. Phase 4 (US2) + Phase 5 (US3) → Test independently → Deploy/Demo
4. Phase 6 (US4) + Phase 7 (US5) → Test independently → Deploy/Demo
5. Phase 8 (US6) + Phase 9 (US7) → Test independently → Deploy/Demo
6. Phase 10 → Polish → Final release

### Parallel Team Strategy

With multiple developers:
1. Team completes Phase 1 + Phase 2 together
2. Once Phase 2 is done:
   - Developer A: Phase 3 (US1) — Create Issue
   - Developer B: Phase 5 (US3) — Edit Issue
   - Developer C: Phase 7 + Phase 8 (US5 + US6) — Visibility + Responsive
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
