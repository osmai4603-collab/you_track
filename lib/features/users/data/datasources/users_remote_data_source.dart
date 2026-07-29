import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
  Future<UserModel> createUser(Map<String, dynamic> data);
  Future<UserModel> updateUser(String id, Map<String, dynamic> data);
  Future<void> deleteUser(String id);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final SupabaseClient supabase;

  UsersRemoteDataSourceImpl(this.supabase);

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
  Future<UserModel> createUser(Map<String, dynamic> data) async {
    data.remove('id');
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
