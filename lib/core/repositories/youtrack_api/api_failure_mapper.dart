import 'package:issues_tracking/core/errors/failure.dart';
import 'package:youtrack_api/youtrack_api.dart';

Failure failureFromApiError(ApiError error) {
  return switch (error) {
    NetworkError() || TimeoutError() => const NetworkFailure(),
    AuthError(:final message) || PermissionError(:final message) =>
      PermissionDeniedFailure(message),
    ValidationError(:final message) ||
    ResourceError(:final message) ||
    FeatureError(:final message) => ValidationFailure(message),
    ServerError(:final code, :final message) => ServerFailure(
      message.isEmpty ? 'The server returned an error. ($code)' : message,
    ),
    UnknownError(:final error) => ServerFailure(error.toString()),
  };
}