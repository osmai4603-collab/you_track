import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'بيانات غير صالحة']);
}

class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([super.message = 'لا يملك المستخدم الحالي صلاحية لتنفيذ هذه العملية']);
}
