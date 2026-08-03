# Fix errors in `all_usecases_test.dart` and `permission_guard_mixin_test.dart`

The test files `all_usecases_test.dart` and `permission_guard_mixin_test.dart` have several compilation errors due to changes in `UserEntity`, `UserPermissionsEntity`, and `UserRoleAssignment`.

## Proposed Changes

### [all_usecases_test.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/test/core/usecase/all_usecases_test.dart)

#### [MODIFY] [all_usecases_test.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/test/core/usecase/all_usecases_test.dart)
- Remove invalid import: `import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';`.
- Update `UserEntity` instantiation: add required `fullName` and `username` parameters.
- Update `UserPermissionsEntity` instantiation: remove `const` keyword as the constructor is no longer `const`.
- Update `UserRoleAssignment` instantiation: change `projectId: null` to `projectId: 'global'` (or another string) as `projectId` is now a required non-nullable `String`.

### [permission_guard_mixin_test.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/test/core/usecase/permission_guard_mixin_test.dart)

#### [MODIFY] [permission_guard_mixin_test.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/test/core/usecase/permission_guard_mixin_test.dart)
- Remove invalid import: `import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';`.
- Update `UserEntity` instantiation: add required `fullName` and `username` parameters.
- Update `UserPermissionsEntity` instantiation: remove `const` keyword.
- Update `UserRoleAssignment` instantiation: change `projectId: null` to `projectId: 'global'`.

## Verification Plan

### Automated Tests
- Run `analyze_file` on both test files to ensure all compilation errors are resolved.
