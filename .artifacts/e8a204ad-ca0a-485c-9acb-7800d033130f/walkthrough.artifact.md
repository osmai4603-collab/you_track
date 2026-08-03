# Walkthrough - Fixing UseCase Tests

I have resolved the compilation errors in `all_usecases_test.dart` and `permission_guard_mixin_test.dart` that were caused by recent changes to the `UserEntity`, `UserPermissionsEntity`, and `UserRoleAssignment` classes.

## Changes Made

### Tests

#### [all_usecases_test.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/test/core/usecase/all_usecases_test.dart) and [permission_guard_mixin_test.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/test/core/usecase/permission_guard_mixin_test.dart)

- **Fixed Imports**: Removed the invalid import for `UserEntity` from `features/auth` and ensured it points to `features/users`.
- **Updated `UserEntity`**: Added the required `fullName` and `username` parameters to all `UserEntity` instantiations.
- **Updated `UserPermissionsEntity`**: Removed the `const` keyword since the class now has a non-const constructor with logic.
- **Updated `UserRoleAssignment`**: Changed `projectId: null` to `projectId: 'global'` because `projectId` is now a non-nullable `String`.

```diff
-        sl<UserSession>().setUser(
-           const UserEntity(
-            id: 'u1',
-            email: 'user@example.com',
-            groups: [],
-            projects: [],
-          ),
-        );
+        sl<UserSession>().setUser(
+           const UserEntity(
+            id: 'u1',
+            fullName: 'User One',
+            username: 'user1',
+            email: 'user@example.com',
+            groups: [],
+            projects: [],
+          ),
+        );
```

```diff
-        sl<UserSession>().setPermissions(
-          const UserPermissionsEntity(roleAssignments: [], ownedProjectIds: []),
-        );
+        sl<UserSession>().setPermissions(
+          UserPermissionsEntity(roleAssignments: [], ownedProjectIds: []),
+        );
```

## Verification Results

### Automated Tests
- Ran `analyze_file` on both `all_usecases_test.dart` and `permission_guard_mixin_test.dart`.
- Both files are now free of compilation errors and warnings.
