import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
  Future<UserModel> createUser(Map<String, dynamic> data, {String? password});
  Future<UserModel> updateUser(String id, Map<String, dynamic> data);
  Future<void> deleteUser(String id);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final SupabaseClient supabase;
  final SupabaseClient? adminClient;

  UsersRemoteDataSourceImpl(this.supabase, {this.adminClient});

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await supabase
        .from('users')
        .select('*')
        .order('created_at', ascending: false);
    return (response as List).map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response =
        await supabase.from('users').select('*').eq('id', id).single();
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> data, {String? password}) async {
    data.remove('id');
    
    if (adminClient != null && password != null && data.containsKey('email')) {
      final res = await adminClient!.auth.admin.createUser(
        AdminUserAttributes(
          email: data['email'],
          password: password,
          emailConfirm: true,
          userMetadata: {
            'display_name': data['display_name'],
            'username': data['username'],
          },
        ),
      );

      if (res.user != null) {
        try {
          final userRecord = await supabase
              .from('users')
              .select('*')
              .eq('id', res.user!.id)
              .single();
          return UserModel.fromJson(userRecord);
        } catch (e) {
          // Fallback if trigger is delayed or error happens fetching
          data['id'] = res.user!.id;
          data['created_at'] = res.user!.createdAt;
          return UserModel.fromJson(data);
        }
      }
    }

    // Fallback to original behavior if no adminClient or password is provided
    final response =
        await supabase.from('users').insert(data).select().single();
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    data.remove('id');
    data['updated_at'] = DateTime.now().toIso8601String();
    final response =
        await supabase.from('users').update(data).eq('id', id).select().single();
    return UserModel.fromJson(response);
  }

  @override
  Future<void> deleteUser(String id) async {
    await supabase.from('users').delete().eq('id', id);
  }
}
