import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/entities/user_role_assignment.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';

void main() {
  group('Permission Resolution', () {
    test('resolveEffective should expand implies recursively', () {
      // projectUpdateProject implies projectReadProjectFull implies projectReadProjectBasic
      final direct = {Permission.projectUpdateProject};
      final effective = Permission.resolveEffective(direct);

      expect(effective.contains(Permission.projectUpdateProject), isTrue);
      expect(effective.contains(Permission.projectReadProjectFull), isTrue);
      expect(effective.contains(Permission.projectReadProjectBasic), isTrue);
    });

    test('arePrerequisitesMet should return false if prerequisite is missing', () {
      // In permission_enum.dart, projectReadProjectFull is in projectReadProjectBasic.dependents
      // So projectReadProjectFull depends on projectReadProjectBasic
      final setWithoutBasic = {Permission.projectReadProjectFull};
      
      expect(Permission.projectReadProjectFull.arePrerequisitesMet(setWithoutBasic), isFalse);
      
      final setWithBasic = {Permission.projectReadProjectFull, Permission.projectReadProjectBasic};
      expect(Permission.projectReadProjectFull.arePrerequisitesMet(setWithBasic), isTrue);
    });

    test('UserPermissionsEntity should compute effective permissions correctly', () {
      final role = UserRoleAssignment(
        roleName: 'Editor',
        permissions: [Permission.projectUpdateProject],
        projectId: 'project-1',
        groupId: 'group-1',
      );

      final permissions = UserPermissionsEntity(
        roleAssignments: [role],
        ownedProjectIds: [],
      );

      expect(permissions.hasProjectPermission('project-1', Permission.projectUpdateProject), isTrue);
      expect(permissions.hasProjectPermission('project-1', Permission.projectReadProjectFull), isTrue);
      expect(permissions.hasProjectPermission('project-1', Permission.projectReadProjectBasic), isTrue);
    });
    
    test('UserPermissionsEntity should handle global permissions expansion', () {
        final role = UserRoleAssignment(
            roleName: 'Admin',
            permissions: [Permission.systemLowLevelAdminWrite],
            projectId: 'global', // Using a string for global as per UserRoleAssignment type
            groupId: 'g1',
        );

        final permissions = UserPermissionsEntity(
            roleAssignments: [role],
            ownedProjectIds: [],
        );

        // hasGlobalPermission checks ALL role assignments
        expect(permissions.hasGlobalPermission(Permission.systemLowLevelAdminWrite), isTrue);
        expect(permissions.hasGlobalPermission(Permission.systemLowLevelAdminRead), isTrue);
    });
  });
}
