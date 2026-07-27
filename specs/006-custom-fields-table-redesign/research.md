# Research: Custom Fields Table Redesign

**Date**: 2026-07-26
**Feature**: 006-custom-fields-table-redesign

## Research Tasks

### 1. Table Layout Implementation in Flutter

**Decision**: Use a `Column`-based table layout with `Row` widgets for each field, rather than a `DataTable` widget.

**Rationale**:
- `DataTable` has limited customization for complex row layouts (checkboxes, drag handles, multiple column types)
- `Row`-based approach allows full control over column widths, alignment, and interactive elements
- The existing `reorderables` package works with `ReorderableColumn` which requires `Row` children
- Matches YouTrack's visual design more closely with custom spacing and styling

**Alternatives considered**:
- `DataTable` widget: Rejected due to limited row customization and poor drag-and-drop integration
- `ListView.builder` with custom rows: Considered but `ReorderableColumn` from `reorderables` is more suitable for drag-and-drop reordering
- `GridView`: Not suitable for tabular data with fixed columns

**References**:
- `reorderables` package: `ReorderableColumn` for drag-and-drop reordering
- Existing `custom_fields_settings_section.dart` already uses `ReorderableColumn`

---

### 2. Drag-and-Drop Reordering with reorderables

**Decision**: Use `ReorderableColumn` from the `reorderables` package with `ReorderableDragStartListener` for drag handles.

**Rationale**:
- Already used in the existing implementation
- Supports custom drag handles via `ReorderableDragStartListener`
- Integrates well with Flutter's widget tree
- Handles animations and feedback automatically

**Alternatives considered**:
- `LongPressDraggable` + `DragTarget`: Too low-level, requires manual animation handling
- `flutter_reorderable_grid_view`: Only for grid layouts, not suitable for table rows

**Implementation pattern**:
```dart
ReorderableColumn(
  onReorder: (oldIndex, newIndex) {
    // Handle reorder
  },
  children: fields.map((field) => Row(
    key: ValueKey(field.id),
    children: [
      ReorderableDragStartListener(
        index: fields.indexOf(field),
        child: Icon(Icons.drag_handle),
      ),
      // ... other row content
    ],
  )).toList(),
)
```

---

### 3. PopupButton with TextField for Replace Functionality

**Decision**: Use `PopupMenuButton<String>` with a custom `PopupMenuEntry` that includes a `TextField` at the top.

**Rationale**:
- `PopupMenuButton` is a standard Material widget with good theming support
- Custom `PopupMenuItem` can include any widget, including `TextField`
- Positioned above the value list as specified in the clarification
- Lightweight and dismissible by tapping outside

**Alternatives considered**:
- `DropdownButton`: Limited customization, cannot add TextField easily
- Custom overlay: More control but requires manual positioning and lifecycle management
- ` showDialog`: Too heavy for a simple value selection

**Implementation pattern**:
```dart
PopupMenuButton<String>(
  itemBuilder: (context) => [
    PopupMenuItem<String>(
      enabled: false, // Prevents closing when tapping TextField
      child: TextField(
        decoration: InputDecoration(hintText: 'Search values...'),
        onChanged: (value) => _filterValues(value),
      ),
    ),
    ...filteredValues.map((value) => PopupMenuItem<String>(
      value: value,
      child: Text(value),
    )),
  ],
)
```

---

### 4. Dialog with Overlay for Make Private Access Control

**Decision**: Use `showDialog` with a custom `AlertDialog` that includes checkboxes for groups and users.

**Rationale**:
- Standard Material dialog pattern, consistent with existing edit/delete dialogs
- Overlay is automatic with `showDialog` (modal barrier)
- Checkboxes allow multi-selection for groups and users
- Easy to add search/filter functionality if needed

**Alternatives considered**:
- Custom overlay with `OverlayEntry`: More control but requires manual lifecycle management
- `BottomSheet`: Not suitable for complex selection with multiple sections
- Full-screen page: Too heavy for a simple selection dialog

**Implementation pattern**:
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Set Field Visibility'),
    content: Column(
      children: [
        // Radio buttons for Everyone / Admins only / Custom
        if (selectedOption == 'Custom') ...[
          // Groups section with checkboxes
          // Users section with checkboxes
        ],
      ],
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
      FilledButton(onPressed: () => _save(), child: Text('Save')),
    ],
  ),
);
```

---

### 5. Extending Supabase Schema for Visibility and Access Control

**Decision**: Add new columns to the `custom_fields` table for `visibility` and `access_control` fields.

**Rationale**:
- Existing `custom_fields` table already has the core field configuration
- Adding columns is simpler than creating a separate table for access control
- RLS policies can be extended to check the new `visibility` and `access_control` columns
- Follows existing patterns in the codebase

**New columns**:
```sql
-- Visibility: 'show' or 'hide' in issues list
ALTER TABLE custom_fields ADD COLUMN visibility TEXT DEFAULT 'show';

-- Access control: JSON object with role/group/user restrictions
ALTER TABLE custom_fields ADD COLUMN access_control JSONB DEFAULT '{"type": "everyone"}';
```

**Access control JSON structure**:
```json
{
  "type": "everyone" | "admins_only" | "custom",
  "groups": ["group_id_1", "group_id_2"],  // Only for "custom" type
  "users": ["user_id_1", "user_id_2"]       // Only for "custom" type
}
```

**Alternatives considered**:
- Separate `custom_field_access_control` table: More normalized but adds complexity for a simple use case
- Using existing `visibleTo` field: Already exists but may have different semantics

**RLS Policy extension**:
```sql
-- Example policy for reading custom fields based on access_control
CREATE POLICY "Users can view custom fields based on access control" ON custom_fields
  FOR SELECT USING (
    access_control->>'type' = 'everyone'
    OR (
      access_control->>'type' = 'admins_only'
      AND EXISTS (SELECT 1 FROM project_members WHERE user_id = auth.uid() AND role = 'admin')
    )
    OR (
      access_control->>'type' = 'custom'
      AND (
        auth.uid() = ANY(ARRAY(SELECT jsonb_array_elements_text(access_control->'users')))
        OR EXISTS (
          SELECT 1 FROM user_groups_members ugm
          WHERE ugm.group_id = ANY(ARRAY(SELECT jsonb_array_elements_text(access_control->'groups')))
          AND ugm.user_id = auth.uid()
        )
      )
    )
  );
```

---

### 6. Show/Hide Details Toggle Implementation

**Decision**: Use a `ValueNotifier<bool>` to control column visibility state, with a toggle button in the toolbar.

**Rationale**:
- Simple boolean state for show/hide toggle
- `ValueNotifier` is appropriate for UI-only state (no business logic)
- Avoids unnecessary Cubit overhead for a simple toggle
- Can be passed to child widgets via `ValueListenableBuilder`

**Alternatives considered**:
- `StatefulWidget` with `setState`: Works but `ValueNotifier` is more explicit and testable
- Cubit: Overkill for a simple boolean toggle

**Implementation pattern**:
```dart
final _showDetails = ValueNotifier<bool>(true);

// In toolbar
IconButton(
  onPressed: () => _showDetails.value = !_showDetails.value,
  icon: Icon(_showDetails.value ? Icons.visibility_off : Icons.visibility),
  tooltip: _showDetails.value ? 'Hide details' : 'Show details',
)

// In table
ValueListenableBuilder<bool>(
  valueListenable: _showDetails,
  builder: (context, showDetails, child) {
    return Row(
      children: [
        // ... basic columns always shown
        if (showDetails) ...[
          // Empty Value column
          // Default Visibility column
        ],
      ],
    );
  },
)
```

---

## Summary of Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Table layout | Row-based Column | Full control, reorderables integration |
| Drag-and-drop | ReorderableColumn + ReorderableDragStartListener | Already used, handles animations |
| Replace UI | PopupMenuButton with TextField | Standard Material, lightweight |
| Make Private UI | AlertDialog with checkboxes | Consistent with existing dialogs |
| Schema extension | Add columns to custom_fields | Simpler than separate table |
| Details toggle | ValueNotifier<bool> | UI-only state, no Cubit overhead |
