import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/role_model.dart';

abstract class RolesRemoteDataSource {
  Future<List<RoleModel>> getRoles();
  Future<RoleModel> getRoleByName(String name);
  Future<RoleModel> createRole(Map<String, dynamic> data);
  Future<RoleModel> updateRole(String name, Map<String, dynamic> data);
  Future<void> deleteRole(String name);
}

class RolesRemoteDataSourceImpl implements RolesRemoteDataSource {
  final SupabaseClient supabase;

  RolesRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<RoleModel>> getRoles() async {
    final response = await supabase.from('roles').select('*');
    return (response as List).map((e) => RoleModel.fromJson(e)).toList();
  }

  @override
  Future<RoleModel> getRoleByName(String name) async {
    final response = await supabase.from('roles').select('*').eq('name', name).single();
    return RoleModel.fromJson(response);
  }

  @override
  Future<RoleModel> createRole(Map<String, dynamic> data) async {
    final response = await supabase.from('roles').insert(data).select().single();
    return RoleModel.fromJson(response);
  }

  @override
  Future<RoleModel> updateRole(String name, Map<String, dynamic> data) async {
    final response = await supabase.from('roles').update(data).eq('name', name).select().single();
    return RoleModel.fromJson(response);
  }

  @override
  Future<void> deleteRole(String name) async {
    await supabase.from('roles').delete().eq('name', name);
  }
}
