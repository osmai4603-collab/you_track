# Feature Specification: Time Tracking Settings

**Feature Branch**: `008-time-tracking-settings`

**Created**: 2026-07-26

**Status**: Draft

**Input**: User description: "Build Time Tracking settings page within the Projects feature, following YouTrack's design. The page enables project administrators to activate time tracking, configure estimation and spent-time fields, set up subtask time aggregation, manage work types (e.g., Development, Testing, Design, Documentation), and define custom work item attributes."

## Clarifications

### Session 2026-07-26

- Q: How should the system handle save failures? → A: Show error snackbar with "Retry" button; unsaved changes remain editable
- Q: How should concurrent admin edits be handled? → A: Last-write-wins; show a warning banner if settings changed since page load
- Q: How should work types be ordered? → A: Admin can drag to reorder; order persists and reflects in logging form

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Toggle Time Tracking On/Off (Priority: P1)

As a project administrator, I want to enable or disable time tracking for my project using a single toggle switch, so that I can control whether the team logs time against tasks.

**Why this priority**: The toggle is the gate for the entire feature. Without it, no other time tracking settings are relevant. It must be implemented first.

**Actor Constraint**: Only project owners and administrators can access and modify time tracking settings. Non-admin members cannot see or interact with this page.

**Independent Test**: Navigate to Time Tracking settings, toggle time tracking ON, verify all sub-settings appear; toggle OFF, verify sub-settings disappear and time tracking is deactivated for the project.

**Acceptance Scenarios**:

1. **Given** the user is on the Time Tracking settings page, **When** the page loads, **Then** a toggle switch labeled "Time Tracking" is displayed at the top of the page
2. **Given** time tracking is currently disabled, **When** the user toggles it ON, **Then** all configuration sections below the toggle become visible and editable (Field Configuration, Aggregation, Work Types)
3. **Given** time tracking is currently enabled, **When** the user toggles it OFF, **Then** a confirmation dialog appears warning that disabling will stop time logging for all project members
4. **Given** the user confirms disabling, **When** the confirmation is accepted, **Then** all configuration sections are hidden and time tracking is deactivated
5. **Given** time tracking is disabled, **When** the user views a task, **Then** the "Log Time" action is not available

---

### User Story 2 - Configure Estimation and Spent Time Fields (Priority: P1)

As a project administrator, I want to select which fields are used for estimation and spent time from dropdown menus, so that time tracking data is mapped to the correct project fields.

**Why this priority**: Field mapping is the core data configuration. Without it, the system cannot store or display time values correctly.

**Independent Test**: Open Field Configuration section, select an estimation field from the dropdown, select a spent time field from the dropdown, save, and verify the fields are correctly associated.

**Acceptance Scenarios**:

1. **Given** time tracking is enabled, **When** the Field Configuration section is visible, **Then** two dropdown fields are displayed: "Estimation Field" and "Spent Time Field"
2. **Given** the Estimation Field dropdown is displayed, **When** the user opens it, **Then** a list of available fields of "Period" type is shown, with the currently selected field highlighted
3. **Given** no Period-type field exists for estimation, **When** the user views the Estimation Field dropdown, **Then** an "Add Estimation Field" option is available that allows creating and linking a new field
4. **Given** the Spent Time Field dropdown is displayed, **When** the user opens it, **Then** a list of available fields of "Period" type is shown, with the currently selected field highlighted
5. **Given** no Period-type field exists for spent time, **When** the user views the Spent Time Field dropdown, **Then** an "Add Spent Time Field" option is available that allows creating and linking a new field
6. **Given** the user selects a field for Estimation, **When** the selection changes, **Then** the dropdown reflects the new selection and the change is staged (not yet persisted until Save)
7. **Given** the user has made field selections, **When** they click Save, **Then** the configuration is persisted and a success notification is shown

---

### User Story 3 - Configure Subtask Time Aggregation (Priority: P2)

As a project administrator, I want to configure whether time logged on subtasks is automatically aggregated into parent tasks, so that the team gets accurate total time views without manual re-entry.

**Why this priority**: Aggregation settings affect how time data rolls up across the task hierarchy. Important for accurate reporting but not essential for basic time logging.

**Independent Test**: Enable subtask aggregation, log time on a child task, verify the parent task's spent time and estimation update automatically; disable aggregation, verify parent is unaffected.

**Acceptance Scenarios**:

1. **Given** time tracking is enabled, **When** the Aggregation section is visible, **Then** two toggle options are displayed: "Aggregate Spent Time from Subtasks" and "Aggregate Estimation from Subtasks"
2. **Given** "Aggregate Spent Time from Subtasks" is toggled ON, **When** a team member logs time on a subtask, **Then** the parent task's spent time field automatically updates to include the subtask's time
3. **Given** "Aggregate Estimation from Subtasks" is toggled ON, **When** subtask estimations are set, **Then** the parent task's estimation field automatically reflects the sum of subtask estimations
4. **Given** aggregation is enabled, **When** a subtask's logged time is edited or deleted, **Then** the parent task's aggregated time updates accordingly
5. **Given** aggregation is toggled OFF, **When** time is logged on a subtask, **Then** the parent task's time fields remain unchanged

---

### User Story 4 - Manage Work Types (Priority: P2)

As a project administrator, I want to add, edit, and remove work type classifications (e.g., Development, Testing, Design, Documentation), so that team members can categorize their logged time by activity type.

**Why this priority**: Work types add structure and reporting value to time logs, but basic time logging works without them.

**Independent Test**: Add a new work type, verify it appears in the list; edit an existing work type's name; remove a work type, verify it is removed from the list and from any existing time entries that referenced it.

**Acceptance Scenarios**:

1. **Given** time tracking is enabled, **When** the Work Types section is visible, **Then** a list of configured work types is displayed with name and status (active/inactive) for each
2. **Given** the work types list is displayed, **When** the user clicks "Add Work Type", **Then** a form appears (inline or dialog) with a name field and an optional description field
3. **Given** the user fills in the work type name, **When** they click Save, **Then** the new work type is added to the list and available for selection when logging time
4. **Given** an existing work type is displayed, **When** the user clicks the edit action, **Then** the name and description become editable inline
5. **Given** a work type is edited, **When** the user saves changes, **Then** the updated name is reflected across all existing time entries that reference this work type
6. **Given** a work type is displayed, **When** the user clicks the delete action, **Then** a confirmation dialog appears; if confirmed, the work type is removed
7. **Given** a work type is deleted, **When** existing time entries referenced it, **Then** those entries retain a null/empty work type (no data loss on time entries)
8. **Given** the work types list is empty, **When** the user views the section, **Then** an empty state message encourages adding the first work type

---

### User Story 5 - Manage Custom Work Item Attributes (Priority: P3)

As a project administrator, I want to define custom fields that team members must fill when logging time (e.g., billing category, client name), so that time entries carry additional business context.

**Why this priority**: Custom attributes are an advanced feature for organizations that need billing or client-level reporting on time. Less critical than core time tracking.

**Independent Test**: Add a custom work item attribute, verify it appears in the time logging form; fill it in when logging time, verify it is saved with the time entry.

**Acceptance Scenarios**:

1. **Given** time tracking is enabled, **When** the Custom Work Item Attributes section is visible, **Then** a list of configured custom attributes is displayed with name, type, and required/optional status
2. **Given** the user clicks "Add Custom Attribute", **Then** a form appears with fields for: attribute name, field type (text, number, date, dropdown), and a required/optional toggle
3. **Given** a custom attribute is configured as required, **When** a team member logs time, **Then** they must fill in this attribute before submitting the time entry
4. **Given** a custom attribute of type "dropdown" is configured, **When** the user defines options for it, **Then** those options appear as a selectable list in the time logging form
5. **Given** custom attributes are defined, **When** a team member logs time, **Then** all custom attribute fields are displayed in the time entry form alongside the standard fields (date, duration, work type, comment)

---

### User Story 6 - Save and Discard Configuration Changes (Priority: P1)

As a project administrator, I want to save or discard all configuration changes made on the Time Tracking settings page, so that I can review my changes before committing them.

**Why this priority**: Proper save/discard flow prevents accidental configuration changes that affect the entire team.

**Independent Test**: Make multiple changes across sections, click Discard, verify all changes are reverted; make changes, click Save, verify changes persist after page reload.

**Acceptance Scenarios**:

1. **Given** the user has made changes to any time tracking setting, **When** they view the page bottom, **Then** a sticky action bar with "Save" and "Discard" buttons is visible
2. **Given** the user has made no changes, **When** they view the action bar, **Then** both Save and Discard buttons are disabled
3. **Given** the user clicks "Discard", **When** there are unsaved changes, **Then** a confirmation dialog appears asking to confirm discarding
4. **Given** the user confirms discard, **When** the action completes, **Then** all settings revert to their last saved state
5. **Given** the user clicks "Save", **When** the action completes, **Then** a success snackbar notification is shown and the page reflects the saved state

---

### Edge Cases

- What happens when the user toggles time tracking OFF while there are unsaved changes to other settings? (The unsaved changes are discarded; the toggle takes effect immediately)
- What happens when the selected Estimation field is deleted from the project's custom fields? (The dropdown resets to "None selected" and a warning banner informs the admin)
- What happens when the selected Spent Time field is deleted from the project's custom fields? (Same as above -- reset to "None selected" with warning)
- What happens when the user tries to delete a work type that is actively assigned to time entries? (Allow deletion; the time entries retain a null work type -- no hard block)
- What happens when a custom attribute of type "dropdown" has its options changed after time entries used the old options? (Existing entries keep their original value; the dropdown reflects the updated options for new entries)
- What happens when the user tries to save with the Estimation field and Spent Time field set to the same field? (Show a validation error -- they must be different fields)
- What happens when the page loads and no Period-type fields exist in the project? (Show guidance text prompting the user to create Period-type fields first, or offer inline creation)
- What happens when the save operation fails due to a network or backend error? (Show error snackbar with Retry button; form remains editable with all changes preserved)
- What happens when two admins edit settings simultaneously? (Last-write-wins; a warning banner is shown if settings changed since page load, prompting the other admin to reload)
- What happens when work types are reordered? (Admin drags to reorder; sort_order is updated in bulk; the new order is reflected in the time logging form)
- What happens when subtask aggregation is enabled but the project has no subtask relationships? (The setting is saved but has no visible effect until subtasks exist)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a toggle switch at the top of the Time Tracking settings page to enable/disable time tracking for the project
- **FR-002**: System MUST show all configuration sections (Field Configuration, Aggregation, Work Types, Custom Attributes) ONLY when the time tracking toggle is ON
- **FR-003**: System MUST hide all configuration sections when the time tracking toggle is OFF
- **FR-004**: System MUST display a confirmation dialog when the user attempts to disable time tracking
- **FR-005**: System MUST provide an "Estimation Field" dropdown that lists all available Period-type fields in the project
- **FR-006**: System MUST provide a "Spent Time Field" dropdown that lists all available Period-type fields in the project
- **FR-007**: System MUST allow creating a new Period-type field inline from the Estimation or Spent Time dropdowns when no suitable field exists
- **FR-008**: System MUST validate that Estimation Field and Spent Time Field are not the same field
- **FR-009**: System MUST provide toggle switches for "Aggregate Spent Time from Subtasks" and "Aggregate Estimation from Subtasks"
- **FR-010**: System MUST automatically sum subtask spent time into the parent task's spent time field when aggregation is enabled
- **FR-011**: System MUST automatically sum subtask estimations into the parent task's estimation field when aggregation is enabled
- **FR-012**: System MUST update parent task aggregated values in real-time when subtask entries are added, edited, or deleted
- **FR-013**: System MUST provide a work types management list with add, edit, and delete capabilities
- **FR-014**: System MUST allow each work type to have a name and an optional description
- **FR-015**: System MUST allow work types to be marked as active or inactive
- **FR-016**: System MUST preserve existing time entries when a work type is deleted (entries retain null work type)
- **FR-017**: System MUST provide a custom work item attributes management list with add, edit, and delete capabilities
- **FR-018**: System MUST support custom attribute field types: text, number, date, and dropdown
- **FR-019**: System MUST allow marking custom attributes as required or optional
- **FR-020**: System MUST display custom attribute fields in the time logging form when configured
- **FR-021**: System MUST enforce required custom attributes during time entry submission
- **FR-022**: System MUST provide a sticky bottom action bar with "Save" and "Discard" buttons
- **FR-023**: System MUST disable Save and Discard buttons when no changes have been made
- **FR-024**: System MUST show a confirmation dialog before discarding unsaved changes
- **FR-025**: System MUST display a success notification after saving configuration
- **FR-026**: System MUST restrict Time Tracking settings page access to project owners and administrators only
- **FR-027**: System MUST persist all time tracking configuration to the backend (toggle state, field mappings, aggregation settings, work types, custom attributes)
- **FR-028**: System MUST display time values in a dynamic format (weeks, days, hours, minutes) based on the configured server time format
- **FR-029**: System MUST make the "Spent Time" field read-only on tasks when time tracking is enabled (auto-populated from logged time entries)
- **FR-030**: System MUST replace any manually entered text values in the Spent Time field with auto-calculated values when time tracking is activated
- **FR-031**: System MUST display an error snackbar with a "Retry" button when the save operation fails, keeping all unsaved changes editable
- **FR-032**: System MUST detect if time tracking settings were modified by another admin since the page was loaded and display a warning banner prompting reload
- **FR-033**: System MUST allow administrators to drag-to-reorder work types, persisting the order and reflecting it in the time logging form

### Key Entities

- **TimeTrackingConfig**: The project-level time tracking configuration. Fields: project_id (UUID FK), enabled (boolean), estimation_field_id (UUID FK, nullable), spent_time_field_id (UUID FK, nullable), aggregate_spent_time (boolean), aggregate_estimation (boolean)
- **WorkType**: A classification for time entries. Fields: id (UUID), project_id (UUID FK), name (text), description (text, nullable), is_active (boolean), sort_order (integer), created_at (datetime), updated_at (datetime)
- **CustomWorkItemAttribute**: A custom field for time entry forms. Fields: id (UUID), project_id (UUID FK), name (text), field_type (enum: text/number/date/dropdown), is_required (boolean), options (JSON, nullable -- for dropdown type), sort_order (integer)
- **TimeEntry**: An individual time log record. Fields: id (UUID), task_id (UUID FK), user_id (UUID FK), work_type_id (UUID FK, nullable), duration_minutes (integer), date (date), comment (text, nullable), custom_attribute_values (JSON, nullable), created_at (datetime), updated_at (datetime)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Project administrators can enable time tracking and configure all settings in under 5 minutes
- **SC-002**: The Time Tracking settings page loads and renders all sections within 2 seconds
- **SC-003**: All form interactions (dropdown opens, toggle switches, inline edits) respond within 500 milliseconds
- **SC-004**: Subtask time aggregation updates parent task values within 3 seconds of a subtask time entry change
- **SC-005**: 100% of configuration changes are persisted correctly and reflected after page reload
- **SC-006**: Non-admin project members cannot access or view the Time Tracking settings page (0% access rate)
- **SC-007**: Work type additions, edits, and deletions complete within 2 seconds
- **SC-008**: The time logging form correctly displays all configured custom attributes for 100% of time entries

## Assumptions

- The existing project settings navigation already includes a "Time Tracking" tab (sidebar item and route already exist at index 6)
- The project already has a custom fields system with Period-type fields that can be referenced for estimation and spent time
- The Issue entity already contains `estimation` (Duration?) and `spent_time` (Duration?) fields stored as minutes
- The Supabase backend is the persistence layer, following the existing remote data source pattern
- The feature follows the existing Clean Architecture pattern (domain/data/presentation) within the projects feature module
- Time logging UI (the form used by team members to log time) is a separate feature -- this specification covers only the settings/configuration page
- Work types and custom attributes are project-scoped (not organization-wide)
- The "Spent Time" field becomes read-only on tasks when time tracking is enabled (auto-calculated from time entries)
- Default work types will be pre-populated: Development, Testing, Design, Documentation
- The UI follows the existing project settings page patterns (SingleChildScrollView + Column layout, AppSpacing.large padding, BlocBuilder/BlocConsumer pattern)
- Dropdown-type custom attributes support a finite list of options defined by the admin
