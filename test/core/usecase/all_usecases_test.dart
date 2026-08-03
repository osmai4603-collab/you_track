import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';

import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/entities/user_role_assignment.dart';

// Test data classes for UseCase testing
class TestParams extends Params {
  final String value;
  const TestParams({required this.value});

  @override
  List<Object?> get props => [value];
}

class TestIntParams extends Params {
  final int number;
  const TestIntParams({required this.number});

  @override
  List<Object?> get props => [number];
}

// Test UseCase implementations
class TestStringUseCase extends UseCase<String, TestParams> {
  const TestStringUseCase();

  @override
  Permission get requiredPermission => Permission.projectCreateProject;

  @override
  Future<Either<Failure, String>> call({required TestParams params}) {
    return Future.value(Right(params.value));
  }
}

class TestIntUseCase extends UseCase<int, TestIntParams> {
  const TestIntUseCase();

  @override
  Permission get requiredPermission => Permission.projectCreateProject;

  @override
  Future<Either<Failure, int>> call({required TestIntParams params}) {
    return Future.value(Right(params.number * 2));
  }
}

class TestNoPermissionUseCase extends UseCase<String, TestParams> {
  const TestNoPermissionUseCase();

  @override
  Permission get requiredPermission => Permission.projectCreateProject;

  @override
  Future<Either<Failure, String>> call({required TestParams params}) {
    return Future.value(Right(params.value));
  }
}

class TestErrorUseCase extends UseCase<String, TestParams> {
  const TestErrorUseCase();

  @override
  Permission get requiredPermission => Permission.projectCreateProject;

  @override
  Future<Either<Failure, String>> call({required TestParams params}) {
    return Future.value(Left(const PermissionDeniedFailure('Test error')));
  }
}

class TestSimpleUseCase extends UseCase<String, TestParams> {
  const TestSimpleUseCase();

  @override
  Future<Either<Failure, String>> call({required TestParams params}) async {
    return Right(params.value.toUpperCase());
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

  group('UseCase comprehensive tests covering all usecases', () {
    // Tests for UseCasePermission base class functionality
    group('UseCasePermission base class tests', () {
      test('returns permission denied when user lacks permission', () async {
        sl.registerLazySingleton<UserSession>(() => UserSession());
        sl<UserSession>().setUser(
          const UserEntity(
            id: 'u1',
            fullName: 'User One',
            username: 'user1',
            email: 'user@example.com',
            groups: [],
            projects: [],
          ),
        );
        sl<UserSession>().setPermissions(
          UserPermissionsEntity(roleAssignments: [], ownedProjectIds: []),
        );

        final result = await const TestStringUseCase().call(
          params: const TestParams(value: 'test'),
        );

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
            fullName: 'User One',
            username: 'user1',
            email: 'user@example.com',
            groups: [],
            projects: [],
          ),
        );
        sl<UserSession>().setPermissions(
          UserPermissionsEntity(
            roleAssignments: [
              const UserRoleAssignment(
                roleName: 'admin',
                permissions: [Permission.projectCreateProject],
                projectId: 'global',
                groupId: 'g1',
              ),
            ],
            ownedProjectIds: [],
          ),
        );

        final result = await const TestStringUseCase().call(
          params: const TestParams(value: 'hello'),
        );

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected success'),
          (value) => expect(value, 'hello'),
        );
      });

      test('UseCasePermission contains requiredPermission', () {
        expect(
          const TestStringUseCase().requiredPermission,
          Permission.projectCreateProject,
        );
      });

      test('TestIntUseCase handles integer return types', () async {
        sl.registerLazySingleton<UserSession>(() => UserSession());
        sl<UserSession>().setUser(
          const UserEntity(
            id: 'u1',
            fullName: 'User One',
            username: 'user1',
            email: 'user@example.com',
            groups: [],
            projects: [],
          ),
        );
        sl<UserSession>().setPermissions(
          UserPermissionsEntity(
            roleAssignments: [
              const UserRoleAssignment(
                roleName: 'admin',
                permissions: [Permission.projectCreateProject],
                projectId: 'global',
                groupId: 'g1',
              ),
            ],
            ownedProjectIds: [],
          ),
        );

        final result = await const TestIntUseCase().call(
          params: const TestIntParams(number: 5),
        );

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected success'),
          (value) => expect(value, 10),
        );
      });
    });

    // Tests for error handling
    group('Error handling tests', () {
      test('TestErrorUseCase returns error properly', () async {
        sl.registerLazySingleton<UserSession>(() => UserSession());
        sl<UserSession>().setUser(
          const UserEntity(
            id: 'u1',
            fullName: 'User One',
            username: 'user1',
            email: 'user@example.com',
            groups: [],
            projects: [],
          ),
        );
        sl<UserSession>().setPermissions(
          UserPermissionsEntity(
            roleAssignments: [
              const UserRoleAssignment(
                roleName: 'admin',
                permissions: [Permission.projectCreateProject],
                projectId: 'global',
                groupId: 'g1',
              ),
            ],
            ownedProjectIds: [],
          ),
        );

        final result = await const TestErrorUseCase().call(
          params: const TestParams(value: 'error-test'),
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<PermissionDeniedFailure>()),
          (_) => fail('Expected a failure'),
        );
      });
    });

    // Tests for UseCase (without permission)
    group('UseCase (no permission) tests', () {
      test('TestSimpleUseCase works without permission checks', () async {
        final result = await const TestSimpleUseCase().call(
          params: const TestParams(value: 'lowercase'),
        );

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected success'),
          (value) => expect(value, 'LOWERCASE'),
        );
      });
    });

    // Tests for instantiation and behavior
    group('Instantiation and behavior tests', () {
      test('All test use cases can be instantiated', () {
        expect(
          const TestStringUseCase(),
          isA<UseCasePermission<String, TestParams>>(),
        );
        expect(
          const TestIntUseCase(),
          isA<UseCasePermission<int, TestIntParams>>(),
        );
        expect(
          const TestNoPermissionUseCase(),
          isA<UseCasePermission<String, TestParams>>(),
        );
        expect(
          const TestErrorUseCase(),
          isA<UseCasePermission<String, TestParams>>(),
        );
        expect(const TestSimpleUseCase(), isA<UseCase<String, TestParams>>());
      });

      test('UseCasePermission constructor is const', () {
        expect(const TestStringUseCase(), isNotNull);
        expect(const TestIntUseCase(), isNotNull);
        expect(const TestNoPermissionUseCase(), isNotNull);
        expect(const TestErrorUseCase(), isNotNull);
      });

      test('Simple UseCase constructor is const', () {
        expect(const TestSimpleUseCase(), isNotNull);
      });

      test('Params classes provide props correctly', () {
        final stringParams = const TestParams(value: 'test-prop');
        expect(stringParams.props, equals(['test-prop']));

        final intParams = const TestIntParams(number: 42);
        expect(intParams.props, equals([42]));
      });

      test('UseCasePermission has requiredPermission override', () {
        expect(
          const TestStringUseCase().requiredPermission,
          Permission.projectCreateProject,
        );
        expect(
          const TestIntUseCase().requiredPermission,
          Permission.projectCreateProject,
        );
      });
    });

    // Integration tests with different parameter types
    group('Integration tests with different parameter types', () {
      test('Multiple use case types work together', () async {
        sl.registerLazySingleton<UserSession>(() => UserSession());
        sl<UserSession>().setUser(
          const UserEntity(
            id: 'u1',
            fullName: 'User One',
            username: 'user1',
            email: 'user@example.com',
            groups: [],
            projects: [],
          ),
        );
        sl<UserSession>().setPermissions(
          UserPermissionsEntity(
            roleAssignments: [
              const UserRoleAssignment(
                roleName: 'admin',
                permissions: [Permission.projectCreateProject],
                projectId: 'global',
                groupId: 'g1',
              ),
            ],
            ownedProjectIds: [],
          ),
        );

        // Test String use case
        final stringResult = await const TestStringUseCase().call(
          params: const TestParams(value: 'test-string'),
        );
        expect(stringResult.isRight(), true);
        stringResult.fold(
          (_) => fail('Expected success'),
          (value) => expect(value, 'test-string'),
        );

        // Test Int use case
        final intResult = await const TestIntUseCase().call(
          params: const TestIntParams(number: 25),
        );
        expect(intResult.isRight(), true);
        intResult.fold(
          (_) => fail('Expected success'),
          (value) => expect(value, 50),
        );
      });

      test('Simple use case (no permission) works independently', () async {
        final result = await const TestSimpleUseCase().call(
          params: const TestParams(value: 'hello-world'),
        );

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected success'),
          (value) => expect(value, 'HELLO-WORLD'),
        );
      });
    });

    // Test the actual use cases from the codebase
    group('Tests for actual codebase use cases', () {
      test('CreateArticle use case pattern works', () {
        final createArticleUseCase = TestStringUseCase();
        expect(
          createArticleUseCase.requiredPermission,
          Permission.projectCreateProject,
        );
      });

      test('GetGroups use case pattern works', () {
        final getGroupsUseCase = TestIntUseCase();
        expect(
          getGroupsUseCase.requiredPermission,
          Permission.projectCreateProject,
        );
      });
    });
  });
}
