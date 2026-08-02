import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';

import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/entities/user_role_assignment.dart';

class TestParams extends Params {
  const TestParams();
}

class TestUseCase extends UseCasePermission<String, TestParams> {
  const TestUseCase();

  @override
  Permission get requiredPermission => Permission.projectCreateProject;

  @override
  Future<Either<Failure, String>> execute({required TestParams params}) {
    return Future.value(const Right('ok'));
  }
}

void main() {
  late GetIt sl;

  setUp(() {
    sl = GetIt.instance;
    sl.unregister<UserSession>(instance: sl<UserSession>());
  });

  tearDown(() {
    sl.reset();
  });

  test('returns permission denied when user lacks permission', () async {
    sl.registerLazySingleton<UserSession>(() => UserSession());
    sl<UserSession>().setUser(
      const UserEntity(
        id: 'u1',
        email: 'user@example.com',
        groups: [],
        projects: [],
      ),
    );
    sl<UserSession>().setPermissions(
      const UserPermissionsEntity(roleAssignments: [], ownedProjectIds: []),
    );

    final result = await const TestUseCase().call(params: const TestParams());

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<PermissionDeniedFailure>()),
      (_) => fail('Expected a failure'),
    );
  });

  test('executes action when user has permission', () async {
    sl.registerLazySingleton<UserSession>(() => UserSession());
    sl<UserSession>().setUser(
      const UserEntity(
        id: 'u1',
        email: 'user@example.com',
        groups: [],
        projects: [],
      ),
    );
    sl<UserSession>().setPermissions(
      const UserPermissionsEntity(
        roleAssignments: [
          UserRoleAssignment(
            roleName: 'admin',
            permissions: [Permission.projectCreateProject],
            projectId: null,
            groupId: 'g1',
          ),
        ],
        ownedProjectIds: [],
      ),
    );

    final result = await const TestUseCase().call(params: const TestParams());

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected success'),
      (value) => expect(value, 'ok'),
    );
  });
}
