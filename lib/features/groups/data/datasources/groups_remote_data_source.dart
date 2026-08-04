import 'package:flutter/foundation.dart';
import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group_member_model.dart';
import '../models/group_model.dart';
import '../models/group_project_model.dart';
import '../models/group_role_assignment_model.dart';

abstract class GroupsRemoteDataSource {
  Future<List<GroupModel>> getGroups({String? userId});
  Future<GroupModel> getGroupById(String id);
  Future<GroupModel> createGroup(GroupModel data);
  Future<GroupModel> updateGroup(String id, GroupModel data);
  Future<void> deleteGroup(String id);

  Future<GroupRoleAssignmentModel> assignRole(GroupRoleAssignmentModel data);
  Future<void> removeGroupRole(String groupId, String projectId);
  Future<List<GroupRoleAssignmentModel>> getGroupRoles(String groupId);

  Future<List<GroupMemberModel>> getGroupMembers(String groupId);
  Future<List<GroupMemberModel>> addGroupMembers(
    String groupId,
    List<String> userIds,
  );
  Future<void> removeGroupMembers(String groupId, List<String> userIds);

  Future<List<GroupProjectModel>> addGroupProjects(
    String groupId,
    List<String> projectIds,
  );
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final SupabaseClient supabase;

  GroupsRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<GroupModel>> getGroups({String? userId}) async {
    final selectString =
        '*, group_members${userId != null ? "!inner" : ""}(*, users(id, user_name, email, avatar_url)), group_roles(*, projects(*)), group_projects(*, projects(*))';
    var query = supabase.from('groups').select(selectString);

    if (userId != null) {
      query = query.eq('group_members.user_id', userId);
    }

    debugPrint('from groups $selectString');

    final response = await query.order('created_at', ascending: false);
    return (response as List).map((e) => GroupModel.fromJson(e)).toList();
  }

  @override
  Future<GroupModel> getGroupById(String id) async {
    final response = await supabase
        .from('groups')
        .select(
          '*, group_members(*, users(id, user_name, email, avatar_url)), group_roles(*, projects(*)), group_projects(*, projects(*))',
        )
        .eq('id', id)
        .single();
    return GroupModel.fromJson(response);
  }

  @override
  Future<GroupModel> createGroup(GroupModel data) async {
    final json = data.toJson()..remove('id');
    final response = await supabase
        .from('groups')
        .insert(json)
        .select()
        .maybeSingle();
    if (response == null) {
      throw DatabaseException('Failed insert group');
    }
    return GroupModel.fromJson(response);
  }

  @override
  Future<GroupModel> updateGroup(String id, GroupModel data) async {
    final json = data.toJson()
      ..remove('id')
      ..['updated_at'] = DateTime.now().toIso8601String();
    final response = await supabase
        .from('groups')
        .update(json)
        .eq('id', id)
        .select()
        .maybeSingle();
    if (response == null) {
      throw DatabaseException('Group Did not updated');
    }
    return GroupModel.fromJson(response);
  }

  @override
  Future<void> deleteGroup(String id) async {
    await supabase.from('groups').delete().eq('id', id);
  }

  @override
  Future<GroupRoleAssignmentModel> assignRole(
    GroupRoleAssignmentModel data,
  ) async {
    final json = data.toJson()..remove('id');
    final response = await supabase
        .from('group_roles')
        .insert(json)
        .select()
        .maybeSingle();
    if (response == null) {
      throw DatabaseException('Group Role Did not inserted');
    }
    return GroupRoleAssignmentModel.fromJson(response);
  }

  @override
  Future<void> removeGroupRole(String groupId, String projectId) async {
    await supabase
        .from('group_roles')
        .delete()
        .eq('group_id', groupId)
        .eq('project_id', projectId);
  }

  @override
  Future<List<GroupRoleAssignmentModel>> getGroupRoles(String groupId) async {
    final response = await supabase
        .from('group_roles')
        .select('*')
        .eq('group_id', groupId)
        .order('role_name', ascending: false);
    return (response as List)
        .map((e) => GroupRoleAssignmentModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    final response = await supabase
        .from('group_members')
        .select('*')
        .eq('group_id', groupId);
    return (response as List).map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupMemberModel>> addGroupMembers(
    String groupId,
    List<String> userIds,
  ) async {
    final data = userIds
        .map((uid) => {'user_id': uid, 'group_id': groupId})
        .toList();
    final response = await supabase.from('group_members').insert(data).select();
    return response.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  @override
  Future<void> removeGroupMembers(String groupId, List<String> userIds) async {
    for (final uid in userIds) {
      await supabase
          .from('group_members')
          .delete()
          .eq('group_id', groupId)
          .eq('user_id', uid);
    }
  }

  @override
  Future<List<GroupProjectModel>> addGroupProjects(
    String groupId,
    List<String> projectIds,
  ) async {
    final data = projectIds
        .map((pid) => {'project_id': pid, 'group_id': groupId})
        .toList();
    final response = await supabase
        .from('group_projects')
        .insert(data)
        .select();
    return response.map((e) => GroupProjectModel.fromJson(e)).toList();
  }
}
