import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';

abstract class Params extends Equatable {
  const Params();
  
  @override
  List<Object?> get props => [];
}

abstract class UseCase<ReturnType, ParamsType extends Params> {
  const UseCase();
  Future<Either<Failure, ReturnType>> call({required ParamsType params});
}

abstract class StreamUseCase<ReturnType, ParamsType extends Params> {
  const StreamUseCase();
  Stream<Either<Failure, ReturnType>> call({required ParamsType params});
}

class NoParams extends Params {
  const NoParams();
}
