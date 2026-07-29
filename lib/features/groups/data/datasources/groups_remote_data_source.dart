import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group_model.dart';

abstract class GroupsRemoteDataSource {
  Future<List<GroupModel>> getGroups();
  Future<GroupModel> getGroupById(String id);
  Future<GroupModel> createGroup(Map<String, dynamic> data);
  Future<GroupModel> updateGroup(String id, Map<String, dynamic> data);
  Future<void> deleteGroup(String id);
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final SupabaseClient supabase;

  GroupsRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<GroupModel>> getGroups() async {
    final response = await supabase.from('groups').select('*').order('created_at', ascending: false);
    return (response as List).map((e) => GroupModel.fromJson(e)).toList();
  }

  @override
  Future<GroupModel> getGroupById(String id) async {
    final response = await supabase.from('groups').select('*').eq('id', id).single();
    return GroupModel.fromJson(response);
  }

  @override
  Future<GroupModel> createGroup(Map<String, dynamic> data) async {
    data.remove('id');
    final response = await supabase.from('groups').insert(data).select().single();
    return GroupModel.fromJson(response);
  }

  @override
  Future<GroupModel> updateGroup(String id, Map<String, dynamic> data) async {
    data.remove('id');
    data['updated_at'] = DateTime.now().toIso8601String();
    final response = await supabase.from('groups').update(data).eq('id', id).select().single();
    return GroupModel.fromJson(response);
  }

  @override
  Future<void> deleteGroup(String id) async {
    await supabase.from('groups').delete().eq('id', id);
  }
}
