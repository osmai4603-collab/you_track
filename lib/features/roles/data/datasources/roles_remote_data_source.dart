import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/role_model.dart';

abstract class RolesRemoteDataSource {
  Future<List<RoleModel>> getRoles();
  Future<RoleModel> getRoleById(String id);
  Future<RoleModel> createRole(Map<String, dynamic> data);
  Future<RoleModel> updateRole(String id, Map<String, dynamic> data);
  Future<void> deleteRole(String id);
}

class RolesRemoteDataSourceImpl implements RolesRemoteDataSource {
  final SupabaseClient supabase;

  RolesRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<RoleModel>> getRoles() async {
    final response = await supabase.from('roles').select('*').order('created_at', ascending: false);
    return (response as List).map((e) => RoleModel.fromJson(e)).toList();
  }

  @override
  Future<RoleModel> getRoleById(String id) async {
    final response = await supabase.from('roles').select('*').eq('id', id).single();
    return RoleModel.fromJson(response);
  }

  @override
  Future<RoleModel> createRole(Map<String, dynamic> data) async {
    data.remove('id');
    final response = await supabase.from('roles').insert(data).select().single();
    return RoleModel.fromJson(response);
  }

  @override
  Future<RoleModel> updateRole(String id, Map<String, dynamic> data) async {
    data.remove('id');
    data['updated_at'] = DateTime.now().toIso8601String();
    final response = await supabase.from('roles').update(data).eq('id', id).select().single();
    return RoleModel.fromJson(response);
  }

  @override
  Future<void> deleteRole(String id) async {
    await supabase.from('roles').delete().eq('id', id);
  }
}
