# Data Model: Project People Settings Redesign

**Date**: Sun Jul 26 2026  
**Feature**: 001-project-people-settings

## Entity: ProjectMemberEntity (Existing — No Changes)

The existing entity is sufficient for this feature. No new fields are needed.

```
ProjectMemberEntity
├── id: String (required)
├── projectId: String (required)
├── name: String (required)
├── email: String (required)
├── roles: List<String> (required)
├── avatarUrl: String? (optional)
└── isOwner: bool (default: false)
```

### Validation Rules (existing)
- `id`: Non-empty string
- `projectId`: Non-empty string
- `name`: Non-empty string
- `email`: Valid email format
- `roles`: List of role name strings (may be empty)
- `isOwner`: Exactly one member per project has `isOwner = true`

## State Model: ProjectMembersState (Modified)

### Current State
```
ProjectMembersState
├── status: ProjectMembersStatus (initial|loading|success|failure)
├── members: List<ProjectMemberEntity>
└── errorMessage: String?
```

### Modified State (additions in bold)
```
ProjectMembersState
├── status: ProjectMembersStatus (initial|loading|success|failure)
├── members: List<ProjectMemberEntity>
├── errorMessage: String?
└── searchQuery: String (default: '')            ← NEW
```

### Derived Data (computed in widget, not stored in state)
```
filteredMembers: List<ProjectMemberEntity>
  = members.where(m => m.name.contains(query) || m.email.contains(query))

teamMembers: List<ProjectMemberEntity>
  = filteredMembers.where(m => m.roles.isNotEmpty)

otherPeople: List<ProjectMemberEntity>
  = filteredMembers.where(m => m.roles.isEmpty)
```

### State Transitions
```
[Initial] → loadMembers(projectId) → [Loading]
[Loading] → success → [Success with members list]
[Loading] → failure → [Failure with errorMessage]
[Success] → updateSearchQuery(query) → [Success with updated searchQuery]
[Success] → loadMembers(projectId) → [Loading] (reload)
```

## Role Color Mapping (New — Widget-Internal)

Defined as a static constant map inside the widget file:

| Role Key | Display Color | Material Equivalent |
|----------|---------------|---------------------|
| "System Admin" | Amber/Orange | `Colors.orange.shade700` |
| "Contributor" | Teal | `Colors.teal.shade600` |
| "Project Admin" | Orange | `Colors.orange.shade600` |
| "Owner" badge | Green | `Colors.green.shade700` (existing) |

Fallback: `Colors.grey.shade600` for unrecognized role names.

## Relationships

```
ProjectEntity (1) ──→ (*) ProjectMemberEntity
  via projectId field

ProjectMemberEntity
  ├── isOwner = true  →  displayed with "project owner" badge
  ├── roles.isNotEmpty →  displayed in "Project Team" table
  └── roles.isEmpty    →  displayed in "Other People with Access" section
```

## Localization Keys (Existing — No Changes)

| Key | English | Arabic |
|-----|---------|--------|
| `projectTeamTitle` | "Project Team" | "فريق المشروع" |
| `otherPeopleAccessTitle` | "Other People with Access" | "أشخاص آخرون لديهم إمكانية الوصول" |
| `roleContributor` | "Contributor" | "مساهم" |
| `roleProjectAdmin` | "Project Admin" | "مدير مشروع" |
| `roleSystemAdmin` | "System Admin" | "مدير نظام" |
| `cancelButton` | "Cancel" | "إلغاء" |

New keys needed for this feature:
| Key | English | Arabic |
|-----|---------|--------|
| `searchMembersHint` | "Search for text or add a filter" | "البحث عن نص أو إضافة فلتر" |
| `teamRolesLabel` | "Team roles" | "أدوار الفريق" |
| `ownerLabel` | "Owner" | "المالك" |
| `projectOwnerBadge` | "project owner" | "مالك المشروع" |
| `removeMemberAction` | "Remove member" | "إزالة العضو" |
| `removeMemberConfirmTitle` | "Remove member?" | "إزالة العضو؟" |
| `removeMemberConfirmBody` | "Are you sure you want to remove this member from the project?" | "هل أنت متأكد من إزالة هذا العضو من المشروع؟" |
| `emptyMembersTitle` | "No team members yet" | "لا يوجد أعضاء في الفريق بعد" |
| `accessDeniedTitle` | "Access Denied" | "تم رفض الوصول" |
| `accessDeniedBody` | "You don't have permission to view this page" | "ليس لديك صلاحية لعرض هذه الصفحة" |
| `memberCount` | "{count}" | "{count}" |
