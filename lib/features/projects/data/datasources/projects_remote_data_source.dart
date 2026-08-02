import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/utils/printing.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project_model.dart';
import '../models/project_member_model.dart';
import '../models/project_template_model.dart';
import '../models/subsystem_model.dart';

abstract class ProjectsRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<List<ProjectTemplateModel>> getProjectTemplates();
  Future<ProjectModel> getProjectById(String id);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<ProjectModel> updateProject(ProjectModel project);
  Future<void> archiveProject(String id);
  Future<void> deleteProject(String id);
  Future<List<ProjectMemberModel>> getProjectMembers(String projectId);
  Future<ProjectMemberModel> addProjectMember(ProjectMemberModel member);
  Future<List<SubsystemModel>> getSubsystems(String projectId);

  Future<SubsystemModel> createSubsystem(SubsystemModel model);
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final SupabaseClient supabase;

  ProjectsRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<ProjectModel>> getProjects() async {
    final response = await supabase
        .from('projects')
        .select('*, project_members(*, users(*))')
        .order('created_at', ascending: false);
    return (response as List).map((e) => ProjectModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProjectTemplateModel>> getProjectTemplates() async {
    final response = await supabase
        .from('project_templates')
        .select()
        .order('name', ascending: true);
    return (response as List)
        .map((e) => ProjectTemplateModel.fromJson(e))
        .toList();
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final response = await supabase
        .from('projects')
        .select('*, project_members(*, users(*))')
        .eq('id', id)
        .single();
    return ProjectModel.fromJson(response);
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    final json = project.toJson()
      ..remove('id')
      ..remove('members')
      ..remove('is_archived')
      ..remove('is_template')
      ..remove('is_favorite')
      ..remove('created_at');

    final userSession = get_it<UserSession>();
    if (userSession.currentUser != null) {
      json['owner_id'] = userSession.currentUser!.id;
    }

    final response = await supabase
        .from('projects')
        .insert(json)
        .select()
        .single();
    return ProjectModel.fromJson(response);
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) async {
    final json = project.toJson()..remove('group_members')..remove('id');
    printMap(title: 'Updating Project WHERE id = ${project.id}', data: json);
    final response = await supabase
        .from('projects')
        .update(json)
        .eq('id', project.id)
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('No project updated. Project not found or update not allowed (RLS).');
    }
    printMap(title: 'Updated Project', data: response);
    return ProjectModel.fromJson(response);
  }

  @override
  Future<void> archiveProject(String id) async {
    await supabase.from('projects').update({'is_archived': true}).eq('id', id);
  }

  @override
  Future<void> deleteProject(String id) async {
    await supabase.from('projects').delete().eq('id', id);
  }

  @override
  Future<List<ProjectMemberModel>> getProjectMembers(String projectId) async {
    final directResponse = await supabase
        .from('project_members')
        .select('*, users(*)')
        .eq('project_id', projectId);
        
    final directMembers = (directResponse as List)
        .map((e) => ProjectMemberModel.fromJson(e))
        .toList();
        
    // جلب المجموعات المرتبطة بالمشروع
    final groupProjectsResponse = await supabase
        .from('group_projects')
        .select('group_id')
        .eq('project_id', projectId);
        
    final groupIds = (groupProjectsResponse as List)
        .map((e) => e['group_id'] as String)
        .toList();
        
    if (groupIds.isEmpty) {
      return directMembers;
    }
    
    // جلب أعضاء المجموعات المرتبطة بالمشروع مع بيانات المستخدم
    final groupMembersResponse = await supabase
        .from('group_members')
        .select('user_id, group_id, users(*)')
        .inFilter('group_id', groupIds);
        
    // جلب أدوار المجموعات ضمن هذا المشروع
    final groupRolesResponse = await supabase
        .from('group_roles')
        .select('group_id, role_name')
        .eq('project_id', projectId)
        .inFilter('group_id', groupIds);
        
    final groupRoles = <String, String>{};
    for (final gr in (groupRolesResponse as List)) {
      groupRoles[gr['group_id'] as String] = gr['role_name'] as String;
    }
    
    final inheritedMembersMap = <String, ProjectMemberModel>{};
    for (final gm in (groupMembersResponse as List)) {
      final userId = gm['user_id'] as String;
      final groupId = gm['group_id'] as String;
      final role = groupRoles[groupId] ?? 'Contributor'; 
      
      // تجنب التكرار إذا كان المستخدم موجوداً بالفعل كعضو مباشر
      if (!directMembers.any((m) => m.userId == userId) && !inheritedMembersMap.containsKey(userId)) {
        final userData = gm['users'];
        if (userData != null) {
          inheritedMembersMap[userId] = ProjectMemberModel.fromJson({
            'id': 'inherited_${userId}_$groupId',
            'project_id': projectId,
            'user_id': userId,
            'roles': [role],
            'is_owner': false,
            'users': userData,
          });
        }
      }
    }
    
    return [...directMembers, ...inheritedMembersMap.values];
  }

  @override
  Future<ProjectMemberModel> addProjectMember(ProjectMemberModel member) async {
    final data = member.toJson()..remove('id');
    final response = await supabase
        .from('project_members')
        .insert(data)
        .select()
        .single();
    return ProjectMemberModel.fromJson(response);
  }

  @override
  Future<List<SubsystemModel>> getSubsystems(String projectId) async {
    try {
      final response = await supabase
          .from('issue_subsystems')
          .select()
          .eq('project_id', projectId)
          .order('name', ascending: true);
      return (response as List).map((e) => SubsystemModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
  
  @override
  Future<SubsystemModel> createSubsystem(SubsystemModel model) async {
    final data = model.toJson()..remove('id');
    final response = await supabase
        .from('issue_subsystems')
        .insert(data)
        .select()
        .maybeSingle();
    if (response == null) {
      throw Exception('No subsystem created. Insertion failed or not allowed (RLS).');
    }
    return SubsystemModel.fromJson(response);
  }
}
