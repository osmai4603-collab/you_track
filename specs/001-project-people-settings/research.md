# Research: Project People Settings Redesign

**Date**: Sun Jul 26 2026  
**Feature**: 001-project-people-settings

## Research Tasks

### R1: Search/Filter Architecture in Cubit Pattern

**Decision**: Add `searchQuery` field to `ProjectMembersState` and a `updateSearchQuery(String)` method to `ProjectMembersCubit`. Filtering is performed client-side on the already-loaded member list.

**Rationale**:
- The member list is already fetched via `loadMembers(projectId)` and held in state
- Client-side filtering is appropriate because project teams are typically <100 members
- No new use case or repository method needed — filtering is a presentation concern
- Follows existing cubit pattern: `Equatable` state, `copyWith` method, simple state transitions

**Alternatives considered**:
- Server-side search via Supabase query — rejected because it requires a new API endpoint and is overkill for small team sizes
- Separate `FilteredMembersCubit` — rejected per YAGNI (Principle V); single cubit is simpler

### R2: Role Chip Color Mapping Strategy

**Decision**: Define a static `Map<String, Color>` inside the widget file mapping role names to colors. Use `AppColors` palette for consistency.

**Rationale**:
- Role names are already localized (ARB keys exist: `roleContributor`, `roleProjectAdmin`, `roleSystemAdmin`)
- Color mapping is UI-only logic — belongs in the presentation layer, not domain
- Static map is the simplest solution (Principle V)

**Color assignments** (from screenshot analysis):
| Role | Color | Source |
|------|-------|--------|
| System Admin | Orange/Amber | `AppColors.light.warning.color600` |
| Contributor | Teal/Cyan | `AppColors.light.brand.color500` or custom teal |
| Project Admin | Orange | `AppColors.light.warning.color500` |
| Owner badge | Green | `AppColors.light.success.color500` (already used) |

**Alternatives considered**:
- Store colors in entity/model — rejected; colors are presentation concern, not domain
- Use theme color slots — rejected; no suitable Material slot for "role chip" semantics

### R3: "Other People with Access" Section Implementation

**Decision**: Split the `members` list in the widget builder: members with non-empty `roles` go to the team table; members with empty `roles` go to the "Other People" section. No new data source needed.

**Rationale**:
- Clarified in spec clarification session: data comes from filtering existing members list
- Simple `where` filter on `member.roles.isEmpty` — no performance concern at project team scale
- Follows YAGNI — no new use case needed for a UI split

**Alternatives considered**:
- New `GetRegisteredUsersUseCase` — rejected; out of scope per spec and YAGNI

### R4: Context Menu Implementation Pattern

**Decision**: Use `PopupMenuButton<String>` wrapped in a `GestureDetector` or as an `IconButton`. Menu items defined as a list of `PopupMenuItem` widgets. "Remove member" action triggers a confirmation dialog before calling the cubit.

**Rationale**:
- `PopupMenuButton` is the standard Material 3 pattern for context menus
- Already used elsewhere in the project (see `AppIcons.moreVert` usage)
- Confirmation dialog before destructive action is a UX best practice
- Per constitution Principle IV, the dialog is UI-only state (StatefulWidget)

**Alternatives considered**:
- Custom overlay/floating menu — rejected; over-engineering for a single action
- Bottom sheet — rejected; doesn't match the YouTrack "..." pattern from the screenshot

### R5: Role Editor Dropdown Implementation

**Decision**: Use `PopupMenuButton` or `DropdownButton` with multi-select capability. When a role chip is tapped, show a popup with available roles as checkable items. On selection change, call a new `updateMemberRole` cubit method.

**Rationale**:
- Matches the YouTrack pattern: click chip → dropdown with role checkboxes
- Multi-select is needed because members can have multiple roles
- `PopupMenuButton` with custom child (the chip) is the cleanest Material approach
- Role change triggers cubit state update (optimistic or with backend call)

**Note**: The spec says role change backend operations are out of scope, but the UI for role selection is in scope. The dropdown will update local state; backend sync is deferred.

### R6: Access Control Implementation

**Decision**: Check the current user's roles from the project entity or a dedicated auth cubit. If not admin, show an "Access Denied" widget instead of the settings content.

**Rationale**:
- The page is already behind a settings route — non-admins shouldn't navigate here
- Defense-in-depth: even if they arrive via deep link, show access denied
- `ProjectDetailsCubit` state contains the project (with owner info); current user roles can be checked against this
- Simple conditional rendering in the build method — no new cubit needed

**Alternatives considered**:
- Route-level guard in GoRouter — rejected; the route is already scoped to settings
- Separate `AuthCubit` check — rejected; overkill for a single page gate

### R7: Empty State Illustration

**Decision**: Use a pre-existing Flutter `Icons` icon (e.g., `Icons.people_outline`) as a large placeholder with the "No team members yet" text. No custom illustration asset needed.

**Rationale**:
- Constitution Principle V (YAGNI): custom illustration asset is unnecessary for an empty state
- Material Icons are available without adding dependencies
- Large icon + text is a standard Flutter empty state pattern

**Alternatives considered**:
- Custom SVG illustration — rejected; adds asset management overhead for minimal UX gain
- Lottie animation — rejected; adds a dependency for a single empty state

## Summary

All NEEDS CLARIFICATION items have been resolved through research. No technical blockers remain. The implementation is straightforward: one cubit modification (search state), one widget redesign (presentation only), and one new widget test file.
