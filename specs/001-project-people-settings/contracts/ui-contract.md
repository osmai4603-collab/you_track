# UI Contract: ProjectPeopleSettingsSection Widget

**Date**: Sun Jul 26 2026  
**Feature**: 001-project-people-settings

## Widget Interface

### Inputs (Provided via BlocBuilder context)
- `ProjectDetailsCubit` — provides `ProjectEntity` (name, owner, projectKey)
- `ProjectMembersCubit` — provides `List<ProjectMemberEntity>` (members list)

### State Dependencies
- `ProjectDetailsState.project` — project metadata
- `ProjectMembersState.status` — loading/success/failure
- `ProjectMembersState.members` — member list
- `ProjectMembersState.searchQuery` — current search filter

### Widget Tree Structure

```
ProjectPeopleSettingsSection (StatefulWidget)
└── BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>
    └── SingleChildScrollView
        ├── _SearchFilterBar         ← NEW
        │   ├── "+" IconButton
        │   ├── TextField (search)
        │   └── Search IconButton
        ├── _ProjectTeamHeader       ← REDESIGNED
        │   ├── "Project Team" + count badge
        │   ├── Owner dropdown
        │   └── Team roles filter
        ├── _TeamMembersTable        ← REDESIGNED
        │   ├── Table header (Name | Roles)
        │   ├── Empty state (illustration + message)
        │   ├── Loading indicator
        │   ├── Error message
        │   └── _MemberRow[]         ← NEW per member
        │       ├── Checkbox
        │       ├── CircleAvatar (initials)
        │       ├── Name + email + owner badge
        │       ├── Role chips[] ← NEW (each clickable)
        │       └── "..." PopupMenuButton ← NEW
        ├── _OtherPeopleSection      ← NEW
        │   ├── "Other People with Access" header
        │   └── _MemberRow[] (filtered: roles.isEmpty)
        └── _AccessDeniedView        ← NEW
            └── "Access Denied" message
```

## User Interactions

| Interaction | Trigger | Behavior |
|-------------|---------|----------|
| Search/filter | TextField onChanged | Updates `searchQuery` in cubit; list filters in real-time |
| Role chip tap | onTap on chip widget | Opens PopupMenuButton with role checkboxes |
| Role toggle | Tap role in dropdown | Adds/removes role from member's roles list (local state) |
| Context menu | Tap "..." IconButton | Opens PopupMenuButton with "Remove member" |
| Remove member | Tap "Remove member" | Shows confirmation AlertDialog; on confirm, removes from local list |
| Owner badge | N/A (display only) | Always shown for `isOwner == true` member |

## Visual Layout (Matching YouTrack Screenshot)

```
┌─────────────────────────────────────────────────┐
│ [+] Search for text or add a filter        [🔍] │
├─────────────────────────────────────────────────┤
│ Project Team  2          Owner: 🟢 admin ▾      │
│                          Team roles: Contributor ▾│
├─────────────────────────────────────────────────┤
│ ☐  Name                   Roles                  │
│─────────────────────────────────────────────────│
│ ☐  🟢 AD  admin           System Admin▾         │
│     project owner          Contributor▾          │
│     osmflutter...@gmail.com Project Admin▾      │
│                                                  │
│ ☐  🟣 OS  osmai4603       Contributor▾          │
│     osmai4603@gmail.com                        │
│                                                  │
│                                              ••• │
├─────────────────────────────────────────────────┤
│ Other People with Access                         │
│─────────────────────────────────────────────────│
│ ☐  👤  Registered Users 2  None ▾               │
│                                              ••• │
└─────────────────────────────────────────────────┘
```

## Accessibility

- All interactive elements must have `Semantics` labels
- Role chips must announce their role name and current state
- Context menu must be keyboard-navigable
- Search field must have a label for screen readers
