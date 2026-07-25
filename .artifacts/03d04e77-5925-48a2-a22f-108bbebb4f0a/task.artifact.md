# Tasks: Integrate Project Settings Routes

- `[x]` Update `AppRouteKeys` with settings sub-routes
- `[x]` Refactor `NavigationService` to use `ShellRoute` for settings
    - `[x]` Define `ShellRoute` for settings
    - `[x]` Add `GoRoute` for each settings section (General, People, etc.)
- `[x]` Update `ProjectSettingsPage`
    - `[x]` Add `child` parameter to constructor
    - `[x]` Implement dynamic `selectedIndex` calculation
    - `[x]` Use `child` in the UI
- `[x]` Update `ProjectSettingsSidebar`
    - `[x]` Update `onTap` for all items to use section routes
- `[x]` Verify navigation and UI state
