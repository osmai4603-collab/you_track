import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project_model.dart';
import '../models/project_member_model.dart';
import '../models/project_template_model.dart';

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
      ..remove('created_at')
      ..remove('owner_id');

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
    final json = project.toJson()..remove('members');
    final response = await supabase
        .from('projects')
        .update(json)
        .eq('id', project.id)
        .select()
        .single();
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
    final response = await supabase
        .from('project_members')
        .select('*, users(*)')
        .eq('project_id', projectId);
    return (response as List)
        .map((e) => ProjectMemberModel.fromJson(e))
        .toList();
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
}
