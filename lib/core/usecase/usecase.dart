import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';

abstract class Params extends Equatable {
  const Params();
  
  @override
  List<Object?> get props => [];
}

abstract class UseCase<ReturnType, ParamsType extends Params> {
  const UseCase();
  Future<Either<Failure, ReturnType>> call({required ParamsType params});
}

abstract class UseCasePermission<ReturnType, ParamsType extends Params> extends UseCase<ReturnType, ParamsType> {

  Permission get requiredPermission;

  Future<Either<Failure, bool>> hasPermission() async {
    final userSession = get_it<UserSession>();

    if (userSession.currentUser == null) {
      return Left(
        const PermissionDeniedFailure('Current user session is not available'),
      );
    }

    if (!userSession.hasPermission(requiredPermission)) {
      return Left(
        PermissionDeniedFailure(
          'The current user does not have permission to execute this operation: ${requiredPermission.name}',
        ),
      );
    }
    return const Right(true);
  }
}

abstract class StreamUseCase<ReturnType, ParamsType extends Params> {
  const StreamUseCase();
  Stream<Either<Failure, ReturnType>> call({required ParamsType params});
}

class NoParams extends Params {
  const NoParams();
}
