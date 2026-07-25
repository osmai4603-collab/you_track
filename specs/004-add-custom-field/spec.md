# Feature Specification: Add Custom Field Page

**Feature Branch**: `004-add-custom-field`

**Created**: 2026-07-26

**Status**: Draft

**Input**: User description: "الحركة والانزلاق (AnimatedPositioned): استخدمت Stack لوضع القائمة فوق الصفحة، وبداخلها وضعت AnimatedPositioned. عندما تكون القائمة مغلقة، تكون right: -400 (خارج الشاشة)، وعند فتحها تصبح right: 0. (الـ duration: 300ms يمنحها سلاسة حركة ناعمة جداً). طبقة التظليل (Overlay): طبقة AnimatedOpacity تعمل كـ "خلفية داكنة" شفافة لحجب الخلفية، مما يجعل المستخدم يركز على النموذج. كذبت تفاعلية GestureDetector بحيث إذا ضغط المستخدم في أي مكان خارج القائمة، تنغلق تلقائياً. التبويبات المخصصة (Custom Tabs): بدلاً من استخدام مكتبة خارجية، تم تصميم Row مع ستايل النصوص وتغيير لون الخط السفلي (Container مع color) حسب ما إذا كانت التبويبة نشطة (isActive: true) من عدمه. زر Add field المعطل: في فلاتر يتم ذلك بكل بساطة بتمرير onPressed: null. هذا يجعل الزر يعطى مظهراً باهتاً مبرمجاً حسب نظام الألوان، ولإجباره على اللون الأزرق الفاتح كما في الصورة استخدمت backgroundColor: Color(0xFF7A8BFF). تنسيق مربع الاختيار (Make private): استخدمت Row بدلاً من CheckboxListTile القياسي للتحكم بنسبة 100% في التصميم: Checkbox على اليسار، و Column إلى جواره يحتوي على النص العريض "🔒 Make private" والنص الصغير المساعد تحته. صفحة اضافة custom_field build app_enum Type: build, enum, group, owned-field, state, user, version .agent/workflows/add_enum.md"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open Add Custom Field Panel (Priority: P1)

As a project administrator, I want to open a sliding panel to add a new custom field to my project so that I can extend issue tracking capabilities.

**Why this priority**: This is the core interaction that enables the entire feature. Without opening the panel, no custom fields can be added.

**Independent Test**: Can be fully tested by tapping the "Add field" button and verifying the panel slides in from the right with a dark overlay.

**Acceptance Scenarios**:

1. **Given** the user is on the project settings page, **When** they tap the "Add field" button, **Then** a panel slides in from the right (300ms animation) with a dark transparent overlay behind it.
2. **Given** the panel is closed, **When** the user taps the "Add field" button, **Then** the panel appears at right: 0 position.
3. **Given** the panel is open, **When** the user taps anywhere on the dark overlay outside the panel, **Then** the panel slides back out (right: -400) and disappears.

---

### User Story 2 - Configure Custom Field Type (Priority: P2)

As a project administrator, I want to select the type of custom field from a tabbed interface so that I can choose the appropriate data format for my field.

**Why this priority**: Selecting the field type is essential before defining other field properties.

**Independent Test**: Can be fully tested by opening the panel and switching between tabs, verifying the active tab indicator changes.

**Acceptance Scenarios**:

1. **Given** the add custom field panel is open, **When** the user views the tabs, **Then** they see type options: build, enum, group, owned-field, state, user, version.
2. **Given** the panel is open, **When** the user taps a different tab, **Then** the underline indicator moves to the newly selected tab with smooth transition.
3. **Given** a tab is selected, **When** the user views the tab, **Then** the active tab has a distinct color (blue/purple) while inactive tabs are gray.

---

### User Story 3 - Fill Field Details (Priority: P3)

As a project administrator, I want to enter the field name and description so that I can define what the custom field represents.

**Why this priority**: After selecting type, the user must provide identifying information for the field.

**Independent Test**: Can be fully tested by entering text in name and description fields and verifying they are captured.

**Acceptance Scenarios**:

1. **Given** the add custom field panel is open, **When** the user enters a name in the "Field Name" input, **Then** the text is displayed correctly.
2. **Given** the panel is open, **When** the user enters a description in the "Description" input, **Then** the text is displayed correctly.
3. **Given** the panel is open, **When** the user leaves the name field empty, **Then** the "Add field" button remains disabled.

---

### User Story 4 - Set Field Privacy (Priority: P4)

As a project administrator, I want to mark a custom field as private so that only authorized users can see it.

**Why this priority**: Privacy is an important secondary feature for sensitive data fields.

**Independent Test**: Can be fully tested by toggling the "Make private" checkbox and verifying the field's private status.

**Acceptance Scenarios**:

1. **Given** the add custom field panel is open, **When** the user views the privacy option, **Then** they see a checkbox with bold "🔒 Make private" text and smaller helper text below.
2. **Given** the panel is open, **When** the user taps the checkbox, **Then** the checkbox toggles between checked/unchecked states.
3. **Given** the checkbox is checked, **When** the user submits the field, **Then** the field is marked as private in the system.

---

### User Story 5 - Submit Custom Field (Priority: P5)

As a project administrator, I want to submit the new custom field so that it becomes available for use in issues.

**Why this priority**: This is the final step that persists the field configuration.

**Independent Test**: Can be fully tested by filling all required fields and tapping "Add field" button.

**Acceptance Scenarios**:

1. **Given** all required fields are filled, **When** the user taps the "Add field" button, **Then** the field is created and the panel closes.
2. **Given** required fields are missing, **When** the user views the "Add field" button, **Then** the button appears disabled (lighter color, no interaction).
3. **Given** the field is submitted successfully, **When** the user returns to the project settings, **Then** the new custom field appears in the list.

---

### Edge Cases

- What happens when the user tries to open the panel while it's already open?
- How does the system handle network errors when saving the custom field?
- What happens if the user enters a field name that already exists?
- How does the system handle invalid characters in field name or description?
- What happens when the user rotates the device while the panel is open?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a sliding panel that animates from right: -400 (off-screen) to right: 0 (on-screen) with 300ms duration.
- **FR-002**: System MUST display a dark transparent overlay behind the panel that blocks interaction with background content.
- **FR-003**: System MUST close the panel when user taps anywhere on the overlay outside the panel area.
- **FR-004**: System MUST provide tabbed interface for selecting custom field type with options: build, enum, group, owned-field, state, user, version.
- **FR-005**: System MUST visually indicate active tab with colored underline and inactive tabs with gray text.
- **FR-006**: System MUST provide input fields for field name (required) and description (optional).
- **FR-007**: System MUST disable "Add field" button when required fields are missing.
- **FR-008**: System MUST provide "Make private" checkbox with bold label and helper text.
- **FR-009**: System MUST persist custom field configuration to backend with proper security policies.
- **FR-010**: System MUST validate field name uniqueness within the project.
- **FR-011**: System MUST handle network errors gracefully and inform user of connectivity issues.
- **FR-012**: System MUST follow established architectural patterns for maintainability.
- **FR-013**: System MUST manage state efficiently for panel open/close and form state.
- **FR-014**: System MUST comply with backend governance rules for schema changes and API contracts.

### Key Entities

- **CustomField**: Represents a custom field definition with attributes: id, projectId, name, description, type (enum of allowed values), isPrivate, createdAt, updatedAt.
- **FieldType**: Enum representing allowed field types: build, enum, group, owned-field, state, user, version.
- **Project**: Parent entity that contains custom fields; a project has many custom fields.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can open the add custom field panel in under 2 seconds from button tap.
- **SC-002**: Panel animation completes smoothly without frame drops on mid-range devices.
- **SC-003**: 95% of users can successfully create a custom field without assistance.
- **SC-004**: Custom field creation success rate is above 98% (excluding network errors).
- **SC-005**: Users can switch between field type tabs with immediate visual feedback.
- **SC-006**: The panel closes within 300ms when user taps overlay or submits field.

## Assumptions

- Users have appropriate project administrator permissions to add custom fields.
- The existing backend infrastructure is available and functioning.
- The project already has UI patterns for sliding panels and form components that can be reused.
- Network connectivity is available for saving custom field configurations.
- The enum values for field types (build, enum, group, owned-field, state, user, version) are stable and won't change frequently.
- Users understand the concept of private vs public fields in the context of project management.
- The existing authentication system will be used for authorization checks.