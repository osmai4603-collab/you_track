
import 'network_error.dart';

sealed class ApiResult<T> {
  const ApiResult();
  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.failure(ApiError error) = ApiFailure<T>;
  bool get isSuccess => this is ApiSuccess;
  bool get isFailure => this is ApiFailure;
  T get data => (this as ApiSuccess<T>).data;
  ApiError get error => (this as ApiFailure<T>).error;
}

class ApiSuccess<T> extends ApiResult<T> {
  @override
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  @override
  final ApiError error;
  const ApiFailure(this.error);
}
