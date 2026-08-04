# UI Contract: Custom Fields Settings Section

**Date**: 2026-07-26
**Feature**: 006-custom-fields-table-redesign

## Overview

This contract defines the UI structure, interactions, and state management for the Custom Fields Settings Section page.

## Page Structure

```text
CustomFieldsSettingsSection
├── FieldToolbar (top bar)
│   ├── AddFieldButton ("Add field to project ...")
│   ├── EditIconButton (disabled when no selection)
│   ├── DeleteIconButton (disabled when no selection)
│   ├── ReplaceButton (disabled when no selection)
│   ├── MakePrivateButton (disabled when no selection)
│   └── ShowDetailsToggle (always enabled)
├── FieldTableHeader (column headers + select-all checkbox)
├── FieldTableBody (scrollable list of FieldTableRow)
│   └── FieldTableRow (for each custom field)
│       ├── Checkbox
│       ├── DragHandle (ReorderableDragStartListener)
│       ├── FieldName (text, tappable to edit)
│       ├── FieldType (formatted chip: "enum (single)")
│       ├── DefaultValue (text or "—")
│       ├── EmptyValue (text, shown when details enabled)
│       └── Visibility (Show/Hide toggle, shown when details enabled)
└── EmptyState (when no fields exist)
    ├── Icon
    ├── Title ("No custom fields yet")
    ├── Description
    └── AddFieldButton
```

## Widget Interactions

### FieldToolbar

| Widget | State | Action | Result |
|--------|-------|--------|--------|
| AddFieldButton | Always enabled | Tap | Open SlidingPanel for adding field |
| EditIconButton | Disabled when 0 selected | Tap with 1 selected | Open EditFieldDialog |
| DeleteIconButton | Disabled when 0 selected | Tap with N selected | Open DeleteConfirmationDialog |
| ReplaceButton | Disabled when 0 selected | Tap with 1 selected | Open ReplaceValuePopup |
| MakePrivateButton | Disabled when 0 selected | Tap with 1 selected | Open MakePrivateDialog |
| ShowDetailsToggle | Always enabled | Tap | Toggle show/hide of EmptyValue and Visibility columns |

### FieldTableRow

| Widget | State | Action | Result |
|--------|-------|--------|--------|
| Checkbox | Checked/Unchecked | Tap | Toggle field selection |
| DragHandle | Always visible | Drag | Reorder field position |
| FieldName | Always visible | Tap | Open EditFieldDialog |
| FieldType | Always visible | None (display only) | Shows formatted type |
| DefaultValue | Always visible | None (display only) | Shows default value or "—" |
| EmptyValue | Visible when details shown | None (display only) | Shows empty value description |
| Visibility | Visible when details shown | Tap on text | Toggle between Show/Hide |

## State Management

### CustomFieldsCubit (existing, extended)

**States**:
- `CustomFieldsInitial`: Page not loaded
- `CustomFieldsLoading`: Loading fields
- `CustomFieldsLoaded`: Fields loaded successfully
  - `fields`: List<CustomFieldEntity>
  - `isSaving`: Boolean for save-in-progress state
- `CustomFieldsError`: Error loading fields

**Methods**:
- `loadFields(projectId)`: Load all fields for project
- `addField(projectId, name, fieldType, defaultValue)`: Add new field
- `updateField(fieldId, name, fieldType, defaultValue)`: Update existing field
- `deleteFields(fieldIds)`: Delete selected fields
- `reorderField(projectId, oldIndex, newIndex)`: Reorder field position
- `updateVisibility(fieldId, visibility)`: NEW - Toggle field visibility
- `updateAccessControl(fieldId, accessControl)`: NEW - Update field access control

### ValueNotifier<bool> (UI-only state)

- `_showDetails`: Controls visibility of EmptyValue and Visibility columns
- Default: `true` (details shown)

## Dialogs

### EditFieldDialog

**Trigger**: Tap on field name or edit icon with 1 field selected
**Content**:
- TextField: Field name (pre-filled)
- DropdownButtonFormField: Field type (pre-selected)
- DropdownButtonFormField: Default value (based on selected type)
**Actions**: Cancel, Save

### DeleteConfirmationDialog

**Trigger**: Delete icon with N fields selected
**Content**:
- Title: "Delete Custom Fields"
- Body: "Are you sure you want to delete N custom field(s)? Existing issue data for these fields will be preserved."
**Actions**: Cancel, Delete (red)

### MakePrivateDialog

**Trigger**: Make private icon with 1 field selected
**Content**:
- Radio buttons: Everyone / Admins only / Custom
- If Custom selected:
  - Groups section with checkboxes (searchable)
  - Users section with checkboxes (searchable)
**Actions**: Cancel, Save

### ReplaceValuePopup

**Trigger**: Replace button with 1 field selected
**Content**:
- TextField at top (for searching/filtering values)
- List of AppPopupMenuItems with field values
**Actions**: Select value (closes popup)

## Empty State

**Trigger**: No fields exist in project
**Content**:
- Icon: `Icons.list_alt_outlined`
- Title: "No custom fields yet"
- Description: "Add your first custom field to start capturing project-specific data on issues."
- Button: "Add field to project ..."

## Error Handling

| Error | Display | Action |
|-------|---------|--------|
| Load failure | SnackBar with error message | Retry button |
| Save failure | SnackBar with error message | — |
| Network error | SnackBar with "Connection error" | — |
| Validation error | Inline error in form field | — |
