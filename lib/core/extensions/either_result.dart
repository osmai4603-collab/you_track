import 'package:fpdart/fpdart.dart';

extension EitherResultWithThrow<L, R> on Either<L, R> {
  R resultWithThrow() {
    return fold((failire) => throw failire.toString(), (right) => right);
  }
}
