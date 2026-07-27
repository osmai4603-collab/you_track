# Feature Specification: Custom Fields Table Redesign

**Feature Branch**: `006-custom-fields-table-redesign`

**Created**: 2026-07-26

**Status**: Draft

**Input**: User description: "Rebuild the Custom Fields settings page to match YouTrack's table-based layout with enhanced field metadata display, toolbar actions, and visibility controls."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Custom Fields in Table Layout (Priority: P1)

As a project administrator, I want to view all custom fields in a structured table with detailed metadata columns so that I can quickly assess field configurations at a glance.

**Why this priority**: This is the foundational view that all other interactions depend on. Without a proper table layout, users cannot efficiently manage fields.

**Independent Test**: Navigate to Custom Fields settings and verify all fields appear in a table with columns: checkbox, drag handle, Field in Projects, Type, Default Value(s), Empty Value, Default Visibility in Issues List.

**Acceptance Scenarios**:

1. **Given** the user is on the Custom Fields settings page, **When** fields exist in the project, **Then** all fields are displayed in a table with the correct columns
2. **Given** the user is on the Custom Fields settings page, **When** no fields exist, **Then** an empty state message is displayed with an "Add field to project" call-to-action
3. **Given** the user views the table, **When** fields are loaded, **Then** each row displays: checkbox, drag handle, field name, field type (with formatting like "enum (single)"), default value, empty value description, and visibility status

---

### User Story 2 - Toolbar Actions for Field Management (Priority: P1)

As a project administrator, I want a toolbar with action buttons (Add, Edit, Delete, Replace, Make Private) so that I can efficiently manage custom fields.

**Why this priority**: Core management actions must be immediately accessible. The toolbar pattern matches YouTrack's UX and reduces cognitive load.

**Independent Test**: Verify the toolbar displays all action buttons and they respond correctly to selection state.

**Acceptance Scenarios**:

1. **Given** the user is on the Custom Fields settings page, **When** no fields are selected, **Then** the toolbar shows "Add field to project ..." button (primary), edit icon (disabled), delete icon (disabled), Replace button (disabled), Make private button (disabled)
2. **Given** the user is on the Custom Fields settings page, **When** one field is selected, **Then** the toolbar shows edit icon (enabled), delete icon (enabled), Replace button (enabled), Make private button (enabled)
3. **Given** the user is on the Custom Fields settings page, **When** the user clicks "Add field to project ...", **Then** the add field panel opens
4. **Given** the user is on the Custom Fields settings page, **When** the user clicks the edit icon with a field selected, **Then** the edit field dialog opens for the selected field
5. **Given** the user is on the Custom Fields settings page, **When** the user clicks the delete icon with fields selected, **Then** a confirmation dialog appears

---

### User Story 3 - Field Selection and Bulk Operations (Priority: P1)

As a project administrator, I want to select multiple fields using checkboxes so that I can perform bulk operations like delete or visibility changes.

**Why this priority**: Bulk operations are essential for managing projects with many custom fields.

**Independent Test**: Select multiple fields via checkboxes and perform a bulk delete operation.

**Acceptance Scenarios**:

1. **Given** the user views the field table, **When** the user clicks the header checkbox, **Then** all fields are selected/deselected
2. **Given** the user views the field table, **When** the user clicks a row checkbox, **Then** that field is toggled in the selection
3. **Given** multiple fields are selected, **When** the user clicks delete, **Then** a confirmation dialog shows the count and asks for confirmation

---

### User Story 4 - Drag-and-Drop Reordering (Priority: P2)

As a project administrator, I want to reorder fields by dragging them so that I can control the display order in issues.

**Why this priority**: Field ordering affects how users see fields in issue forms, making this important for usability.

**Independent Test**: Drag a field row to a new position and verify the order is persisted.

**Acceptance Scenarios**:

1. **Given** the user views the field table, **When** the user drags a field row using the drag handle, **Then** the field moves to the new position
2. **Given** a field has been reordered, **When** the user refreshes the page, **Then** the new order is maintained

---

### User Story 5 - Field Visibility Control (Priority: P2)

As a project administrator, I want to control whether each field is visible in the issues list so that I can customize the issue tracker view for my team.

**Why this priority**: Visibility control helps teams focus on relevant fields and reduces clutter in issue lists.

**Independent Test**: Toggle a field's visibility and verify the change is reflected in the issues list.

**Acceptance Scenarios**:

1. **Given** the user views the field table, **When** a field's visibility column shows "Show", **Then** the field is visible in issues lists
2. **Given** the user views the field table, **When** a field's visibility column shows "Hide", **Then** the field is hidden from issues lists
3. **Given** the user wants to change visibility, **When** the user clicks the visibility status, **Then** a dropdown or toggle appears to change it

---

### User Story 6 - Show/Hide Details Toggle (Priority: P3)

As a project administrator, I want a "Show details" toggle so that I can expand or collapse additional column information in the table.

**Why this priority**: This provides flexibility for users who want a compact view versus a detailed view.

**Independent Test**: Toggle the "Show details" button and verify columns expand/collapse.

**Acceptance Scenarios**:

1. **Given** the user is on the Custom Fields settings page, **When** the user clicks "Show details", **Then** additional columns (Empty Value, Default Visibility) become visible
2. **Given** details are shown, **When** the user clicks "Show details" again, **Then** the table collapses to show only essential columns

---

### User Story 7 - Replace Field Values (Priority: P3)

As a project administrator, I want to replace field values across issues so that I can migrate or consolidate field data.

**Why this priority**: Value replacement is an advanced operation needed during field maintenance or cleanup.

**Independent Test**: Select a field, click Replace, and verify the replacement workflow opens.

**Acceptance Scenarios**:

1. **Given** a field is selected, **When** the user clicks "Replace", **Then** a replacement dialog or panel opens
2. **Given** the replacement dialog is open, **When** the user specifies old and new values, **Then** the system processes the replacement

---

### Edge Cases

- What happens when a field is being edited by another administrator simultaneously? (Assume optimistic locking with last-write-wins)
- What happens when the user tries to delete a field that is actively used in workflows? (Show warning that existing data will be preserved)
- What happens when drag-and-drop reordering fails due to a network error? (Show error snackbar and revert to previous order)
- What happens when the table has 50+ fields? (Use virtual scrolling or pagination for performance)
- What happens when a field type is changed after values exist? (Show confirmation warning about data compatibility)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display custom fields in a table with columns: checkbox, drag handle, Field in Projects (name), Type, Default Value(s), Empty Value, Default Visibility in Issues List
- **FR-002**: System MUST show field type with formatting like "enum (single)", "state (single)", "user (single)", "ownedField (single)", "version (multi)", "build (single)", "period", "integer"
- **FR-003**: System MUST display a toolbar with buttons: "Add field to project ..." (primary), edit icon, delete icon, Replace, Make private (enabled), Show details toggle
- **FR-004**: System MUST disable toolbar actions (edit, delete, Replace, Make private) when no fields are selected
- **FR-016**: System MUST implement "Make private" with admin-only access control, restricting the action to users with admin/owner role in the project
- **FR-017**: System MUST provide visibility options when "Make private" is clicked: "Everyone" / "Admins only" / "Custom" (allow selecting specific user groups or individual users via a dialog with overlay and checkboxes)
- **FR-005**: System MUST support checkbox-based multi-selection with a header checkbox for select-all
- **FR-006**: System MUST support drag-and-drop reordering of fields via drag handles
- **FR-007**: System MUST display field visibility status as "Show" or "Hide" in the Default Visibility column
- **FR-008**: System MUST allow toggling field visibility between Show and Hide
- **FR-009**: System MUST display the empty value description for each field (e.g., "Cannot be empty", "Unassigned", "No Subsystem", "Unscheduled", "Next Build", "Unknown", "?", "No Ideal days")
- **FR-010**: System MUST open an add field panel when "Add field to project ..." is clicked
- **FR-018**: System MUST implement "Replace" functionality using a PopupButton with a TextField positioned above the value list for selecting old and new values
- **FR-011**: System MUST open an edit dialog when the edit icon is clicked with a field selected
- **FR-012**: System MUST show a confirmation dialog before deleting selected fields
- **FR-013**: System MUST show a "Show details" toggle that expands/collapses additional columns (Empty Value, Default Visibility)
- **FR-014**: System MUST preserve existing field data when fields are reordered or visibility is changed
- **FR-015**: System MUST show error messages via snackbar when operations fail

### Key Entities

- **CustomField**: Represents a custom field configuration with properties: id, name, fieldType, fieldMode, valueMode, defaultValue, emptyValue, canBeEmpty, orderIndex, visibility (show/hide in issues list), aliases
- **FieldType**: The data type of the field (enum, state, user, ownedField, version, build, period, integer, string, text, float, date, dateTime, group) with display formatting
- **FieldValue**: A specific value option within a field type (for enum, state, ownedField, version, build types)
- **FieldVisibility**: Controls whether the field appears in issues lists (Show/Hide)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can view all custom fields with complete metadata in a single table view without scrolling horizontally
- **SC-002**: Users can select and perform bulk operations on fields in under 5 seconds
- **SC-003**: Field reordering via drag-and-drop completes in under 2 seconds with visual feedback
- **SC-004**: The table layout matches YouTrack's visual design with consistent spacing, typography, and color scheme
- **SC-005**: All toolbar actions are accessible within 2 clicks from the main view
- **SC-006**: The page loads and displays fields in under 3 seconds for projects with up to 50 custom fields

## Clarifications

### Session 2026-07-26

- Q: ما هو النطاق الفعلي لوظيفة "Make private" في هذا الإصدار؟ → A: تنفيذ كامل مع تقييد الوصول للمسؤولين فقط (admin-only) مع خيارات تحكم بالرؤية: الجميع / مسؤولون فقط / مخصص
- Q: ما هو نطاق وظيفة "Replace" (استبدال القيم) الذي تفضله؟ → A:ظهر زر PopupButton<String> مع TextField أعلى القائمة لاختيار القيم
- Q: هل يجب تضمين متطلبات إمكانية الوصول في هذا الإصدار؟ → A: لا يتطلب - لا حاجة لإضافة دعم إمكانية الوصول حالياً
- Q: كيف يعمل خيار "المخصص" (Custom) في "Make private"؟ → A: السماح باختيار مجموعات (مثل: المطورين) أو مستخدمين محددين
- Q: ما هي واجهة المستخدم لاختيار المجموعات والمستخدمين في "Make private"؟ → A: نافذة منبثقة (Dialog) مع overlay لعرض قائمة المجموعات والمستخدمين مع خانات اختيار (checkboxes)

## Assumptions

- The existing `CustomFieldEntity` model already contains all necessary properties (visibility, emptyValue, etc.) or can be extended
- The existing `CustomFieldsCubit` can be extended to support visibility toggling and field replacement operations
- The current sliding panel and dialog patterns will be reused for add/edit workflows
- Field type display formatting ("enum (single)") will be derived from the existing `CustomFieldEnumType` enum
- The "Make private" functionality refers to field-level access control with admin-only restriction (fully implemented in this version)
- The "Replace" functionality uses a PopupButton with TextField above the value list (UI-only implementation for this version)
- Performance optimization for large field lists is secondary to visual accuracy in the initial implementation
- Accessibility features (WCAG compliance, screen reader support) are out of scope for this version
