import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

abstract class Params extends Equatable {
  const Params();

  @override
  List<Object?> get props => [];
}

abstract class UseCase<ReturnType, ParamsType extends Params> {
  const UseCase();
  Future<Either<Failure, ReturnType>> call({required ParamsType params});
}

abstract class UseCasePermission<ReturnType, ParamsType extends Params>
    extends UseCase<ReturnType, ParamsType> {
  const UseCasePermission();

  Permission get requiredPermission;

  /// Returns the project ID associated with the operation, if any.
  /// Override this in project-scoped UseCases.
  String? getProjectId(ParamsType params) => null;

  Future<Either<Failure, ReturnType>> call({required ParamsType params});

  @protected
  Future<Either<Failure, bool>> hasPermission({
    required ParamsType params,
  }) async {
    final userSession = get_it<UserSession>();

    if (userSession.currentUser == null) {
      return Left(
        const PermissionDeniedFailure('Current user session is not available'),
      );
    }

    final projectId = getProjectId(params);
    if (!userSession.hasPermission(requiredPermission, projectId: projectId)) {
      final scope = projectId != null ? ' in project $projectId' : '';
      return Left(
        PermissionDeniedFailure(
          'The current user does not have permission to execute this operation: ${requiredPermission.name}$scope',
        ),
      );
    }
    return const Right(true);
  }

  @override
  Future<Either<Failure, ReturnType>> execute({
    required ParamsType params,
  }) async {
    final permissionCheck = await hasPermission(params: params);
    return permissionCheck.fold(
      (failure) => Left(failure),
      (_) => execute(params: params),
    );
  }
}

abstract class StreamUseCase<ReturnType, ParamsType extends Params> {
  const StreamUseCase();
  Stream<Either<Failure, ReturnType>> call({required ParamsType params});
}

class NoParams extends Params {
  const NoParams();
}
