import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:issues_tracking/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSourceImpl(this._supabase);

  @override
  Future<UserModel> login(String email, String password) async {
    final authResponse = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final authUser = authResponse.user;
    if (authUser == null) {
      throw Exception('Login failed: no user authenticated');
    }

    final userData = await _supabase
        .from('users')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();
    if (userData == null) {
      throw DatabaseException('No User Found for id: ${authUser.id}');
    }

    return UserModel.fromJson(userData);
  }
}
