import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/features/users/data/models/user_permissions_model.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
  Future<UserModel> createUser(Map<String, dynamic> data, {String? password});
  Future<UserModel> updateUser(String id, Map<String, dynamic> data);
  Future<void> deleteUser(String id);
  Future<UserEntity> login(String email, String password);
  Future<UserPermissionsModel> getUserPermissions(String userId);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  static const List<String> _updatableColumns = [
    'full_name',
    'user_name',
    'email',
    'avatar_url',
  ];

  static const List<String> _insertableColumns = [
    ..._updatableColumns,
    'created_at',
  ];

  final SupabaseClient _supabase;
  final SupabaseClient? adminClient;

  UsersRemoteDataSourceImpl(this._supabase, {this.adminClient});

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _supabase
        .from('users')
        .select('*, group_members(groups(name, group_projects(projects(name))))')
        .order('created_at', ascending: false);
    return (response as List).map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response =
        await _supabase.from('users').select('*, group_members(groups(name, group_projects(projects(name))))').eq('id', id).single();
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
          final userRecord = await _supabase
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
    final payload = <String, dynamic>{
      for (final column in _insertableColumns)
        if (data.containsKey(column)) column: data[column],
    };
    final response =
        await _supabase.from('users').insert(payload).select().single();
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    final payload = <String, dynamic>{
      for (final column in _updatableColumns)
        if (data.containsKey(column)) column: data[column],
    };
    final response = await _supabase
        .from('users')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return UserModel.fromJson(response);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _supabase.from('users').delete().eq('id', id);
  }
  
  @override
  Future<UserPermissionsModel> getUserPermissions(String userId) async {
    final roleAssignments = <Map<String, dynamic>>[];
    final ownedProjectIds = <String>[];

    final groupMembersResponse = await _supabase
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId);

    final groupMembers = groupMembersResponse as List<dynamic>;

    for (final member in groupMembers) {
      final groupId = member['group_id']?.toString();
      if (groupId == null || groupId.isEmpty) {
        continue;
      }

      final groupRolesResponse = await _supabase
          .from('group_roles')
          .select('role_name, project_id')
          .eq('group_id', groupId);

      final groupRoles = groupRolesResponse as List<dynamic>;

      for (final groupRole in groupRoles) {
        final roleName = groupRole['role_name']?.toString();
        if (roleName == null || roleName.isEmpty) {
          continue;
        }

        final roleResponse = await _supabase
            .from('roles')
            .select('permissions')
            .eq('name', roleName)
            .maybeSingle();

        final permissions = <String>[];
        if (roleResponse != null) {
          final rawPermissions = roleResponse['permissions'] as List<dynamic>?;
          permissions.addAll(
            rawPermissions?.map((entry) => entry.toString()) ?? <String>[],
          );
        }

        final projectId = groupRole['project_id']?.toString();
        roleAssignments.add({
          'role_name': roleName,
          'permissions': permissions
              .map((permission) => Permission.of(permission).name)
              .toList(),
          'project_id': projectId?.isEmpty == true ? null : projectId,
          'group_id': groupId,
        });
      }
    }

    final projectsResponse = await _supabase
        .from('projects')
        .select('id')
        .eq('owner_id', userId);

    final projects = projectsResponse as List<dynamic>;
    for (final project in projects) {
      final projectId = project['id']?.toString();
      if (projectId != null && projectId.isNotEmpty) {
        ownedProjectIds.add(projectId);
      }
    }

    return UserPermissionsModel.fromJson({
      'role_assignments': roleAssignments,
      'owned_project_ids': ownedProjectIds,
    });
  }
  
  @override
  Future<UserEntity> login(String email, String password) async {
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
