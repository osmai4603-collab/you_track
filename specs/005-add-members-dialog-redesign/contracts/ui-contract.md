# UI Contract: AddProjectMembersPage Widget

**Date**: Sun Jul 26 2026  
**Feature**: 005-add-members-dialog-redesign

## Widget Interface

### Inputs (Provided via BlocBuilder context)
- `ProjectMembersCubit` — provides `List<ProjectMemberEntity>` (members list) and `addMember()` method

### State Dependencies
- `ProjectMembersState.status` — loading/success/failure
- `ProjectMembersState.members` — full member list

### Constructor Parameters
- `projectId` (`String`) — the project ID to associate added members with

### Widget Tree Structure

```
AddProjectMembersPage (StatefulWidget)
└── Dialog
    └── ConstrainedBox (maxWidth: 520)
        └── Padding (all: 24)
            └── Column (mainAxisSize:.min)
                ├── Text "Add People" (headlineSmall)
                ├── SizedBox (height: 8)
                ├── Text subtitle (bodyMedium, grey)
                ├── SizedBox (height: 20)
                ├── CompositedTransformTarget
                │   └── TextField (search field)
                │       └── InputDecoration
                │           ├── hintText: "Select users and groups or enter an email address"
                │           └── border: OutlineInputBorder
                ├── SizedBox (height: 24)
                ├── _MembersTableCard          ← NEW (replaces overlay)
                │   └── Container (border, rounded corners)
                │       └── Column
                │           ├── _TableHeader (Name | Add to team | Roles)
                │           ├── _GroupRows[]   ← NEW
                │           │   └── _MemberRow (group)
                │           │       ├── GroupIcon + Label
                │           │       ├── Switch (toggle)
                │           │       ├── Dropdown (roles)
                │           │       └── IconButton (X)
                │           ├── Divider
                │           ├── _UserRows[]     ← NEW
                │           │   └── _MemberRow (user)
                │           │       ├── CircleAvatar + Name + Email
                │           │       ├── Switch (toggle)
                │           │       ├── Dropdown (roles)
                │           │       └── IconButton (X)
                │           └── _EmptyState (if no results)
                ├── Row (action buttons)
                │   ├── FilledButton "Invite" (blue)
                │   ├── SizedBox
                │   ├── OutlinedButton "Cancel"
                │   ├── Spacer
                │   └── Text "Standard user licenses: 8"
```

## User Interactions

| Interaction | Trigger | Behavior |
|-------------|---------|----------|
| Search/filter | TextField onChanged | Filters table rows in real-time based on name/email match |
| Toggle add to team | Switch onChanged | Marks member for addition (ON) or removal (OFF) from team |
| Select role | Dropdown onChanged | Updates the assigned role for the selected member |
| Remove row | IconButton (X) onTap | Removes the row from the table entirely |
| Invite | FilledButton onTap | Processes all toggled-ON members via `addMember()`, closes dialog |
| Cancel | OutlinedButton onTap | Closes dialog without changes |
| Email invite | TextField + Invite | If text contains '@', creates new user invitation |

## Visual Layout (Matching YouTrack Screenshot)

```
┌─────────────────────────────────────────────────────────┐
│ Add People                                               │
│ You can add users who already have YouTrack accounts     │
│ or invite new users by email                             │
├─────────────────────────────────────────────────────────┤
│ [Select users and groups or enter an email address    ]  │
├─────────────────────────────────────────────────────────┤
│ Name                    │ Add to team │ Roles       │    │
│─────────────────────────┼─────────────┼─────────────│    │
│ 🟣 osmai4603            │      ●      │ Contributor │ ✕  │
│    osmai4603@gmail.com  │    (ON)     │    , +1 ▾  │    │
│─────────────────────────┼─────────────┼─────────────│    │
│ 👥 Registered Users     │      ○      │ None     ▾  │ ✕  │
│                         │    (OFF)    │             │    │
├─────────────────────────────────────────────────────────┤
│ [Invite]  [Cancel]              Standard user licenses: 8│
└─────────────────────────────────────────────────────────┘
```

## Component Specifications

### _MembersTableCard
- **Container**: Border (grey.shade300), borderRadius (AppRadius.smallBorderRadius)
- **Max height**: 320px with vertical scroll
- **Header row**: "Name", "Add to team", "Roles" labels in grey.shade500

### _MemberRow
- **Name column**: 
  - Users: CircleAvatar (14px radius, blue.shade100 bg) + Name (14px) + Email (12px, grey.shade500)
  - Groups: Group icon + Label (14px)
- **Add to team column**: Switch widget (blue when ON, grey when OFF)
- **Roles column**: DropdownButton with role options, 12px grey text
- **Remove column**: IconButton with X icon (grey.shade500)

### _EmptyState
- **Text**: "Type to see more relevant options" (13px, grey.shade500)
- **Padding**: horizontal 16, vertical 12

## State Management

### Local State (StatefulWidget)
- `_controller` (TextEditingController) — search field text
- `_focusNode` (FocusNode) — search field focus
- `_selectedMembers` (Map<String, _SelectedMember>) — tracks toggled members
  - Key: member ID or group name
  - Value: `_SelectedMember` with `isSelected`, `role`, `isGroup` fields

### Data Flow
1. Dialog opens → `ProjectMembersCubit` provides member list
2. Search field onChanged → filters displayed rows locally
3. Toggle switch → updates `_selectedMembers` map
4. Role dropdown → updates role in `_selectedMembers` map
5. Invite button → iterates `_selectedMembers`, calls `addMember()` for each
6. Cancel button → `Navigator.pop(context)`

## Accessibility

- All interactive elements must have `Semantics` labels
- Toggle switches must announce their state (ON/OFF)
- Dropdowns must be keyboard-navigable
- Search field must have a label for screen readers
- Table headers must be associated with their columns
