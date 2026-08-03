# Feature Specification: Custom Fields Settings

**Feature Branch**: `003-custom-fields-settings`

**Created**: 2026-07-25

**Status**: Draft

**Input**: User description: "Build custom fields page inside project settings. UI: table with checkbox, drag handle, field name, type dropdown, default value. Drag & drop reordering. Field types from existing enums (IssueTypeEnum, IssuePriorityTypeEnum, IssueStateEnum, SubsystemEntity)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View and Reorder Custom Fields (Priority: P1)

As a project administrator, I want to access a Custom Fields page from the project settings so that I can view all custom fields configured for my project and rearrange their display order via drag-and-drop.

**Why this priority**: This is the primary entry point. Without access to the custom fields list, administrators cannot manage custom fields at all. The ability to reorder is fundamental because it controls how fields appear on issues and forms.

**Independent Test**: Can be fully tested by navigating to project settings, selecting Custom Fields, verifying the table loads with existing fields, and dragging a field to a new position.

**Acceptance Scenarios**:

1. **Given** the user is a project administrator on the project settings page, **When** they select "Custom Fields" from the settings menu, **Then** a page displaying all custom fields for the project is shown in a table layout
2. **Given** the custom fields table is displayed, **When** the user presses and holds the drag handle on a field row, **Then** the row becomes draggable and can be moved to a new position
3. **Given** the user drags a field row to a new position, **When** they release the row, **Then** the field is repositioned and the new order is saved
4. **Given** the user views the table, **When** the screen width changes, **Then** the columns adjust proportionally to maintain readability

---

### User Story 2 - Add a New Custom Field (Priority: P1)

As a project administrator, I want to add a new custom field by specifying its name, type, and optional default value so that I can capture additional project-specific data on issues.

**Why this priority**: Adding fields is the core value of this feature. Without it, administrators cannot extend issue tracking with project-specific data.

**Independent Test**: Can be tested by clicking "Add Field", filling in name/type/default value, saving, and verifying the new field appears in the table.

**Acceptance Scenarios**:

1. **Given** the user is on the Custom Fields page, **When** they press an "Add Field" button, **Then** a new row or dialog appears for entering field details
2. **Given** the user enters a field name and selects a type, **When** they save, **Then** the new field appears in the table with the specified name and type
3. **Given** the user sets a default value for the field, **When** they save, **Then** the default value is displayed in the table's "Default Value" column
4. **Given** the user tries to save a field with an empty name, **When** they press save, **Then** an error message is shown and the field is not created

---

### User Story 3 - Edit Existing Custom Fields (Priority: P2)

As a project administrator, I want to edit a custom field's name, type, or default value so that I can correct mistakes or adjust field configuration as project needs evolve.

**Why this priority**: Editing is important for ongoing maintenance but less critical than viewing/adding. Administrators can always delete and recreate if editing is temporarily unavailable.

**Independent Test**: Can be tested by selecting an existing field, changing its name/type/default value, saving, and verifying the table updates.

**Acceptance Scenarios**:

1. **Given** the user is on the Custom Fields page, **When** they click on a field name or an edit action, **Then** the field becomes editable
2. **Given** the user changes a field's type, **When** they save, **Then** the type is updated and the default value resets if incompatible with the new type
3. **Given** the user changes a field's default value, **When** they save, **Then** the updated default value is reflected in the table

---

### User Story 4 - Delete Custom Fields (Priority: P2)

As a project administrator, I want to delete custom fields that are no longer needed so that the issue form stays clean and relevant.

**Why this priority**: Deletion completes the CRUD lifecycle. While less frequent than add/edit, it prevents clutter buildup.

**Independent Test**: Can be tested by selecting one or more fields via checkboxes and deleting them, confirming the deletion, and verifying the field is removed from the table.

**Acceptance Scenarios**:

1. **Given** the user is on the Custom Fields page, **When** they check a field's checkbox and press "Delete", **Then** the field is removed after confirmation
2. **Given** the user checks multiple fields, **When** they press "Delete", **Then** all selected fields are removed after confirmation
3. **Given** the user attempts to delete a field that is in use by existing issues, **When** they confirm deletion, **Then** the field is removed and existing issue data for that field is handled appropriately (e.g., preserved but hidden)

---

### Edge Cases

- What happens when the user tries to reorder fields while offline? The reorder should work locally and sync when connectivity is restored, or show an appropriate error if immediate persistence is required.
- What happens when the type dropdown is changed and the current default value is not valid for the new type? The default value should reset to "no value" or the first available option.
- What happens when there are no custom fields configured? The table should display an empty state with a prompt to add the first field.
- What happens when a field is deleted that had data in existing issues? The field data in issues should be preserved (orphaned) so that historical data is not lost, but the field should no longer appear on the issue form.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The project settings MUST include a "Custom Fields" section accessible from the settings sidebar
- **FR-002**: The Custom Fields page MUST display a table with columns for checkbox selection, drag handle, field name, field type, and default value
- **FR-003**: The table MUST support horizontal and vertical scrolling when content exceeds the visible area
- **FR-004**: Column widths (type, default value) MUST distribute proportionally using available space
- **FR-005**: Each row MUST have a checkbox on the left for multi-select operations
- **FR-006**: Each row MUST display a drag handle icon for initiating drag-and-drop reordering
- **FR-007**: The type column MUST display a dropdown with available field types derived from existing project enums
- **FR-008**: The default value column MUST display a dropdown or input appropriate to the selected field type
- **FR-009**: Users MUST be able to reorder fields via drag-and-drop with visual feedback during the drag operation
- **FR-010**: The reordered field positions MUST be persisted and survive page refresh
- **FR-011**: Users MUST be able to add new custom fields by specifying name, type, and optional default value
- **FR-012**: Users MUST be able to edit existing custom fields (name, type, default value)
- **FR-013**: Users MUST be able to delete individual or multiple selected custom fields after confirmation
- **FR-014**: Deleting a field MUST NOT delete existing issue data associated with that field
- **FR-015**: The system MUST validate that field names are non-empty and unique within a project
- **FR-016**: The system MUST provide visual feedback (loading indicators, success/error messages) for all save operations

### Key Entities

- **CustomField**: Represents a project-specific field for issues; key attributes include id, project reference, name, field type (from existing enums), default value, and display order index
- **CustomFieldValue**: Represents the value of a custom field on a specific issue; key attributes include id, issue reference, custom field reference, and value

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Project administrators can view, add, edit, delete, and reorder custom fields in under 3 interactions (clicks/taps) per action
- **SC-002**: Drag-and-drop reordering completes and persists in under 2 seconds from drop
- **SC-003**: The custom fields table remains usable and readable across desktop and tablet screen sizes
- **SC-004**: Adding or editing a field with invalid data shows an error message within 1 second
- **SC-005**: 100% of field additions and edits are persisted and survive page refresh

## Assumptions

- The existing project settings page has a sidebar or tab navigation where "Custom Fields" can be added as a new section
- Custom fields are scoped per project (not global), following the existing project-based data model
- The existing enums (IssueTypeEnum, IssuePriorityTypeEnum, IssueStateEnum, SubsystemEntity) define the available field types
- Default value options depend on the selected field type (e.g., enum types show available enum values as defaults)
- Data persistence follows the same pattern as the existing project feature (currently Supabase-based)
- The user is already authenticated and has project administrator permissions to access settings
- Batch selection via checkboxes enables multi-delete operations
