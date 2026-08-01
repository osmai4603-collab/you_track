import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/auth/data/datasources/user_permissions_data_source.dart';
import 'package:issues_tracking/features/auth/domain/repositories/user_permissions_repository.dart';

class UserPermissionsRepositoryImpl implements UserPermissionsRepository {
  final UserPermissionsDataSource dataSource;

  UserPermissionsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserPermissionsEntity>> getUserPermissions(String userId) async {
    try {
      final model = await dataSource.getUserPermissions(userId);
      return Right(model);
    } on DatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(LocalDatabaseFailure('فشل في جلب صلاحيات المستخدم: $e'));
    }
  }
}
