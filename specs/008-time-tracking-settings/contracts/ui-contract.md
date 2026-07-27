# UI Contract: Time Tracking Settings

**Date**: 2026-07-26
**Feature**: 008-time-tracking-settings

## Component: TimeTrackingSettingsSection

**Location**: `lib/features/projects/presentation/widgets/settings_sections/project_time_tracking_settings_section.dart`

**Purpose**: Main settings section widget rendered at route `settings/time`. Replaces the existing placeholder `Center(child: Text('Time Tracking Settings'))`.

**Props/Inputs**:
- `projectId` (String) — Current project ID from route params

**State Cubits** (provided via BlocProvider in router):
- `TimeTrackingConfigCubit` — manages toggle, field mappings, aggregation settings
- `WorkTypesCubit` — manages work type CRUD and reordering
- `CustomAttributesCubit` — manages custom attribute CRUD

**Layout**:
```
SingleChildScrollView
  └── Column (padding: AppSpacing.large horizontal)
      ├── TimeTrackingToggle          (always visible)
      ├── AnimatedSize                 (show/hide sections based on toggle)
      │   ├── FieldConfigurationSection
      │   ├── AggregationSection
      │   ├── WorkTypesSection
      │   └── CustomAttributesSection
      └── TimeTrackingSaveBar          (sticky bottom)
```

---

## Component: TimeTrackingToggle

**Purpose**: Master on/off switch for time tracking.

**Props/Inputs**:
- `isEnabled` (bool) — Current toggle state
- `onToggle` (ValueChanged<bool>) — Callback when toggled

**Behavior**:
- ON → emits `onToggle(true)` immediately
- OFF → shows confirmation dialog, emits `onToggle(false)` only on confirm

**FR Coverage**: FR-001, FR-002, FR-003, FR-004

---

## Component: FieldConfigurationSection

**Purpose**: Dropdown selectors for Estimation and Spent Time fields.

**Props/Inputs**:
- `availableFields` (List<CustomField>) — Period-type fields in the project
- `selectedEstimationFieldId` (String?) — Currently selected estimation field
- `selectedSpentTimeFieldId` (String?) — Currently selected spent time field
- `onEstimationFieldChanged` (ValueChanged<String?>) — Callback
- `onSpentTimeFieldChanged` (ValueChanged<String?>) — Callback
- `onAddField` (VoidCallback) — Opens inline field creation

**Behavior**:
- Both dropdowns list only Period-type fields
- If no Period-type fields exist, show "Add Field" option
- Validation: estimation ≠ spent time field (FR-008)
- Shows warning banner if selected field was deleted externally

**FR Coverage**: FR-005, FR-006, FR-007, FR-008

---

## Component: AggregationSection

**Purpose**: Toggle switches for subtask time aggregation.

**Props/Inputs**:
- `aggregateSpentTime` (bool)
- `aggregateEstimation` (bool)
- `onAggregateSpentTimeChanged` (ValueChanged<bool>)
- `onAggregateEstimationChanged` (ValueChanged<bool>)

**FR Coverage**: FR-009, FR-010, FR-011, FR-012

---

## Component: WorkTypesSection

**Purpose**: List management for work type classifications with drag-to-reorder.

**Props/Inputs**:
- `workTypes` (List<WorkType>) — Ordered by sort_order
- `onAdd` (VoidCallback) — Opens add dialog
- `onEdit` (ValueChanged<WorkType>) — Opens edit dialog
- `onDelete` (ValueChanged<WorkType>) — Shows confirmation, then deletes
- `onReorder` (ValueChanged<List<WorkType>>) — Bulk reorder callback

**Behavior**:
- Displays name, description, active/inactive status for each
- Empty state: "Add your first work type" message
- Add/Edit: opens `WorkTypeFormDialog`
- Delete: confirmation dialog, then remove
- Drag handle for reordering (uses `reorderables` package)

**FR Coverage**: FR-013, FR-014, FR-015, FR-016

---

## Component: WorkTypeFormDialog

**Purpose**: Form for adding or editing a work type.

**Props/Inputs**:
- `workType` (WorkType?) — Null for add, populated for edit
- `onSave` (ValueChanged<WorkType>) — Callback with form data

**Fields**:
- Name (text, required)
- Description (text, optional)
- Active/Inactive toggle (boolean, default: true)

---

## Component: CustomAttributesSection

**Purpose**: List management for custom work item attributes.

**Props/Inputs**:
- `attributes` (List<CustomWorkItemAttribute>) — Ordered by sort_order
- `onAdd` (VoidCallback) — Opens add dialog
- `onEdit` (ValueChanged<CustomWorkItemAttribute>) — Opens edit dialog
- `onDelete` (ValueChanged<CustomWorkItemAttribute>) — Shows confirmation, then deletes

**Behavior**:
- Displays name, type badge, required/optional badge for each
- Empty state: "Add your first custom attribute" message
- Add/Edit: opens `CustomAttributeFormDialog`
- Delete: confirmation dialog, then remove

**FR Coverage**: FR-017, FR-018, FR-019

---

## Component: CustomAttributeFormDialog

**Purpose**: Form for adding or editing a custom work item attribute.

**Props/Inputs**:
- `attribute` (CustomWorkItemAttribute?) — Null for add, populated for edit
- `onSave` (ValueChanged<CustomWorkItemAttribute>) — Callback with form data

**Fields**:
- Name (text, required)
- Field Type (dropdown: text, number, date, dropdown — required)
- Required/Optional toggle (boolean, default: false)
- Options (list of strings, visible only when type = dropdown, required if type = dropdown)

---

## Component: TimeTrackingSaveBar

**Purpose**: Sticky bottom action bar with Save and Discard buttons.

**Props/Inputs**:
- `hasChanges` (bool) — Whether any settings have been modified
- `onSave` (VoidCallback) — Triggers save operation
- `onDiscard` (VoidCallback) — Shows confirmation, then reverts

**Behavior**:
- Both buttons disabled when `hasChanges` is false (FR-023)
- Discard shows confirmation dialog (FR-024)
- Save shows success snackbar on completion (FR-025)
- Save shows error snackbar with Retry button on failure (FR-031)
- Loading indicator during save operation

**FR Coverage**: FR-022, FR-023, FR-024, FR-025, FR-031

---

## Cubit Contracts

### TimeTrackingConfigCubit

**States**:
- `TimeTrackingConfigInitial` — Loading
- `TimeTrackingConfigLoaded` — Data loaded, ready for editing
- `TimeTrackingConfigSaved` — Save successful
- `TimeTrackingConfigError` — Load or save failed
- `TimeTrackingConfigStale` — Concurrent edit detected (warning banner)

**Key Methods**:
- `loadConfig(String projectId)` — Fetches config from Supabase
- `toggleEnabled(bool value)` — Updates local state
- `setEstimationField(String? fieldId)` — Updates local state
- `setSpentTimeField(String? fieldId)` — Updates local state
- `setAggregateSpentTime(bool value)` — Updates local state
- `setAggregateEstimation(bool value)` — Updates local state
- `save()` — Persists all changes, detects concurrency
- `discard()` — Reverts to last saved state

### WorkTypesCubit

**States**:
- `WorkTypesInitial` — Loading
- `WorkTypesLoaded` — List loaded
- `WorkTypesError` — Operation failed

**Key Methods**:
- `loadWorkTypes(String projectId)` — Fetches ordered list
- `addWorkType(String name, String? description)` — Creates new
- `updateWorkType(WorkType workType)` — Updates existing
- `deleteWorkType(String id)` — Removes (time entries retain null)
- `reorderWorkTypes(List<String> orderedIds)` — Bulk update sort_order

### CustomAttributesCubit

**States**:
- `CustomAttributesInitial` — Loading
- `CustomAttributesLoaded` — List loaded
- `CustomAttributesError` — Operation failed

**Key Methods**:
- `loadAttributes(String projectId)` — Fetches ordered list
- `addAttribute(String name, String type, bool required, List<String>? options)` — Creates new
- `updateAttribute(CustomWorkItemAttribute attr)` — Updates existing
- `deleteAttribute(String id)` — Removes
