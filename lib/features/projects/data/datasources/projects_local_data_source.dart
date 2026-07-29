import 'package:issues_tracking/core/enums/project_template_enum.dart';
import '../models/project_model.dart';
import '../models/project_member_model.dart';
import '../models/project_template_model.dart';

abstract class ProjectsLocalDataSource {
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

class ProjectsLocalDataSourceImpl implements ProjectsLocalDataSource {
  final List<ProjectTemplateModel> _templates = ProjectTemplateType.values
      .map(
        (t) => ProjectTemplateModel(
          id: t.name,
          name: t.templateName,
          description: t.description,
          iconKey: t.iconKey,
          defaultFields: t.defaultFields,
        ),
      )
      .toList();

  final List<ProjectModel> _projects = [
    ProjectModel(
      id: 'proj_demo',
      name: 'Demo Project',
      projectId: 'DEMO',
      description: 'Demonstration project showcasing YouTrack capabilities.',
      isArchived: false,

      templateType: .kanban,
      ownerId: 'admin',
      createdAt: DateTime(2026, 7, 20),
      isFavorite: true,
    ),
    ProjectModel(
      id: 'proj_fingerprint',
      name: 'fingerprint',
      projectId: 'FIN',
      description: 'Biometric fingerprint authentication subsystem.',
      isArchived: false,

      templateType: ProjectTemplateType.kanban,
      ownerId: 'admin',
      createdAt: DateTime(2026, 7, 22),
      isFavorite: false,
    ),
    ProjectModel(
      id: 'proj_test',
      name: 'Test project',
      projectId: 'TP',
      description: 'Primary testing environment for new workflow features.',
      isArchived: false,

      templateType: ProjectTemplateType.kanban,
      ownerId: 'admin',
      createdAt: DateTime(2026, 7, 24),
      isFavorite: false,
    ),
  ];

  final List<ProjectMemberModel> _members = [
    const ProjectMemberModel(
      id: 'm1',
      projectId: 'proj_test',
      // name: 'AD',
      // email: 'osmflutterdeveloper@gmail.com',
      roles: ['System Admin', 'Contributor', 'Project Admin'],
      isOwner: true,
      userId: 'hello',
    ),
    const ProjectMemberModel(
      id: 'm2',
      projectId: 'proj_test',
      roles: ['Contributor'],
      isOwner: false,
      userId: 'sdfjk',
    ),
  ];

  @override
  Future<List<ProjectModel>> getProjects() async {
    return List.from(_projects);
  }

  @override
  Future<List<ProjectTemplateModel>> getProjectTemplates() async {
    return List.from(_templates);
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final project = _projects.firstWhere(
      (p) => p.id == id || p.projectId == id,
      orElse: () => throw Exception('Project not found with ID: $id'),
    );
    return project;
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    _projects.insert(0, project);
    return project;
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      return project;
    }
    throw Exception('Project not found');
  }

  @override
  Future<void> archiveProject(String id) async {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _projects[index];
      _projects[index] = ProjectModel(
        id: p.id,
        name: p.name,
        projectId: p.projectId,
        description: p.description,
        isArchived: true,
        templateType: p.templateType,
        ownerId: p.ownerId,
        createdAt: p.createdAt,
        isFavorite: p.isFavorite,
      );
    }
  }

  @override
  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<ProjectMemberModel>> getProjectMembers(String projectId) async {
    return _members
        .where((m) => m.projectId == projectId || projectId.isEmpty)
        .toList();
  }

  @override
  Future<ProjectMemberModel> addProjectMember(ProjectMemberModel member) async {
    _members.add(member);
    return member;
  }
}
