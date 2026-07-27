# Data Model: Add Members Dialog Redesign

**Date**: Sun Jul 26 2026  
**Feature**: 005-add-members-dialog-redesign

## Existing Entities (No Changes)

### ProjectMemberEntity

```dart
class ProjectMemberEntity extends Entity {
  final String id;
  final String projectId;
  final String name;
  final String email;
  final List<String> roles;
  final String? avatarUrl;
  final bool isOwner;
}
```

**Source**: `lib/features/projects/domain/entities/project_member_entity.dart`

## Local State (Widget-Level)

### _SelectedMember

```dart
class _SelectedMember {
  final bool isSelected;      // Toggle state (ON/OFF)
  final String role;          // Assigned role
  final bool isGroup;         // Whether this is a group or user
}
```

**Purpose**: Tracks user selections within the dialog session

### Dialog State Map

```dart
Map<String, _SelectedMember> _selectedMembers;
```

**Key**: Member ID (for users) or group name (for groups)  
**Value**: `_SelectedMember` with selection state

## State Transitions

### Toggle Switch

```
OFF → ON: _selectedMembers[id] = _SelectedMember(isSelected: true, role: 'Contributor', isGroup: false)
ON → OFF: _selectedMembers[id] = _selectedMember.copyWith(isSelected: false)
```

### Role Selection

```
Current → New: _selectedMembers[id] = _selectedMember.copyWith(role: newRole)
```

### Remove Row

```
Present → Removed: _selectedMembers.remove(id)
```

## Validation Rules

| Field | Rule | Error Message |
|-------|------|---------------|
| Selection | At least one member must be toggled ON to enable Invite | "Select at least one member to invite" |
| Role | Must be one of: "None", "Contributor", "Project Admin", "System Admin" | "Invalid role selection" |

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                  ProjectMembersCubit                    │
│  ┌─────────────────────────────────────────────────┐   │
│  │  state.members: List<ProjectMemberEntity>       │   │
│  └─────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────┘
                        │ provides member list
                        ▼
┌─────────────────────────────────────────────────────────┐
│              AddProjectMembersPage (Dialog)             │
│  ┌─────────────────────────────────────────────────┐   │
│  │  _selectedMembers: Map<String, _SelectedMember> │   │
│  │  - Tracks toggle state, role, isGroup           │   │
│  └─────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────┘
                        │ on Invite button tap
                        ▼
┌─────────────────────────────────────────────────────────┐
│         ProjectMembersCubit.addMember()                │
│  ┌─────────────────────────────────────────────────┐   │
│  │  For each _selectedMember where isSelected=true │   │
│  │  → call addMember(projectId, name, email, roles)│   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Summary

- No new entities or database models required
- Existing `ProjectMemberEntity` provides all required fields
- Local `_SelectedMember` class tracks transient dialog state
- State transitions are simple and well-defined
- Validation rules ensure data integrity before processing
