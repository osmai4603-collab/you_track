# Research: Add Members Dialog Redesign

**Date**: Sun Jul 26 2026  
**Feature**: 005-add-members-dialog-redesign

## Design Decisions

### Decision 1: Table-Based Layout vs Overlay

**Choice**: Table-based layout (always visible)

**Rationale**: The YouTrack reference design shows an always-visible table below the search field. This provides better discoverability and reduces cognitive load compared to the current overlay-based suggestion system.

**Alternatives Considered**:
- Overlay-based suggestions (current implementation): Less discoverable, requires user interaction to see options
- Modal selection: Adds extra navigation step

### Decision 2: Local State for Selections

**Choice**: StatefulWidget with local `Map<String, _SelectedMember>` state

**Rationale**: The dialog's selection state is transient and doesn't need to persist beyond the dialog session. Using local StatefulWidget state keeps the implementation simple and avoids unnecessary Cubit complexity for UI-only concerns.

**Alternatives Considered**:
- Extending ProjectMembersCubit: Would add UI-only state to business logic layer, violating YAGNI
- New DialogCubit: Over-engineering for a simple dialog

### Decision 3: Toggle Switch vs Checkbox

**Choice**: Toggle Switch

**Rationale**: The YouTrack reference design uses toggle switches for the "Add to team" column. Toggle switches provide clear visual feedback (ON/OFF states) and are more intuitive for binary selections.

**Alternatives Considered**:
- Checkboxes: Less visual impact, doesn't match YouTrack design
- Multi-select with confirm: Adds complexity

### Decision 4: Role Dropdown Implementation

**Choice**: DropdownButton with role options

**Rationale**: Standard Flutter DropdownButton provides the required functionality. The role list is static and doesn't require dynamic loading.

**Alternatives Considered**:
- PopupMenuButton: Similar functionality but DropdownButton is more standard for form fields
- Custom dropdown: Unnecessary complexity

## Best Practices

### Flutter Dialog Best Practices

1. **Dialog Width**: Use `ConstrainedBox` with `maxWidth: 520` for consistent dialog sizing
2. **Scrollable Content**: Use `ListView.builder` with `shrinkWrap: true` for dynamic content
3. **Form Validation**: Validate inputs before processing (check for empty selections)
4. **Accessibility**: Add `Semantics` labels to interactive elements

### Toggle Switch Best Practices

1. **Visual Feedback**: Use distinct colors for ON (blue) and OFF (grey) states
2. **State Management**: Update local state immediately for responsive UI
3. **Accessibility**: Announce state changes for screen readers

### Dropdown Best Practices

1. **Default Values**: Set sensible defaults (e.g., "Contributor" for new additions)
2. **Visual Clarity**: Show current selection in collapsed state
3. **Keyboard Navigation**: Ensure dropdown items are keyboard-accessible

## Integration Patterns

### Reuse Existing Components

- `AppRadius.smallBorderRadius` for table card corners
- `AppRadius.mediumBorderRadius` for dialog corners
- Existing color scheme from `AppColorScheme` for consistency
- `CircleAvatar` pattern from `project_people_settings_section.dart` for user avatars

### Data Flow

```
ProjectMembersCubit.state.members
        ↓
AddProjectMembersPage (dialog)
        ↓
_localMembers Map (selections)
        ↓
Invite button → addMember() for each selected
        ↓
Navigator.pop(context)
```

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Performance with many members | Medium | Limit table height with scrolling |
| Role assignment conflicts | Low | Use local state; no backend conflicts |
| Accessibility gaps | Medium | Add Semantics labels to all interactive elements |

## Conclusion

All design decisions align with the feature spec and constitution principles. No NEEDS CLARIFICATION items remain. The implementation can proceed with Phase 1 design.
