import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/users_table.dart';
import 'package:issues_tracking/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:issues_tracking/features/auth/data/models/user_model.dart';

class AuthSqliteDataSourceImpl implements AuthRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final UsersTable _table = const UsersTable();

  AuthSqliteDataSourceImpl(this._sqlite);

  @override
  Future<UserModel> login(String email, String password) async {
    // In offline mode, we just fetch the user by email since we can't verify password securely locally without syncing hashes.
    final row = _sqlite.fetchFirst(
      tableName: _table.tableName,
      where: '${_table.email} = ?',
      whereArgs: [email],
    );
    if (row == null) {
      throw DatabaseException(
        'Login failed: invalid email or user not found locally',
      );
    }

    // Convert users table row to auth UserModel
    return UserModel(
      id: row[_table.id] as String,
      email: row[_table.email] as String,
      userName: row[_table.username] as String?,
      avatarUrl: row[_table.avatarUrl] as String?,
      createdAt: row[_table.registrationDate] != null
          ? DateTime.tryParse(row[_table.registrationDate] as String)
          : null,
    );
  }
}
