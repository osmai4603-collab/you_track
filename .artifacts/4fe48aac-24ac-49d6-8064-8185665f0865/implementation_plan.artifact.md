# Implementation Plan - Administration Menu for YouTrack Sidebar

This plan outlines the changes needed to add a hierarchical administration menu to the "Administration" item in the `YouTrackSidebar`.

## User Review Required

> [!IMPORTANT]
> The user requested a `PopupMenuButton`. However, standard Flutter `PopupMenuButton` does not natively support hierarchical submenus. I recommend using `MenuAnchor` with `SubmenuButton` and `MenuItemButton`, which is the modern Flutter way to implement hierarchical menus. This will achieve the requested "submenu" behavior perfectly.

## Proposed Changes

### [UI Components]

#### [MODIFY] [youtrack_sidebar.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/presentation/widgets/youtrack_sidebar.dart)
- Update `_YouTrackSidebarState` to include a `MenuController` for the Administration menu.
- Modify the "Administration" item to use `MenuAnchor`.
- Implement a helper method `_buildAdminMenu()` to generate the hierarchical menu items.
- Style the menu items to match the sidebar's dark theme and text colors.

The menu will contain:
- `Custom Fields`
- `Link Types`
- `Time Tracking`
- `Workflows`
- `Apps`
- `Divider`
- `Access Management` (Submenu)
  - `Users`, `Organizations`, `Groups`, `Roles`, `Auth Modules`, `SAML 2.0`, `OAuth Clients`
- `Integrations` (Submenu)
  - `imports`, `Mailbox integrations`, `Build server integrations`, `VCS Integration`, `Zendesk Integration`, `Jetbrains AI`
- `Server Settings` (Submenu)
  - `Global Settings`, `user Agreement`, `Database Export`, `SSL Certificates`, `SSL Keys`, `Audit Events`

## Verification Plan

### Manual Verification
- Run the app and open the sidebar.
- Click on the "Administration" item.
- Verify that the menu appears with the correct items.
- Verify that the submenus (`Access Management`, `Integrations`, `Server Settings`) open and display their respective items.
- Verify that the background color and text colors match the sidebar theme.
- Verify the behavior in both expanded and collapsed sidebar states.
