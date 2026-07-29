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
  final List<ProjectTemplateModel> _templates = [
    const ProjectTemplateModel(
      id: 'default',
      name: 'Default',
      description:
          'Standard issue tracking template with default system fields.',
      iconKey: 'folder',
      defaultFields: {
        'Priority': 'Normal',
        'Type': 'Task',
        'State': 'Submitted',
        'Assignee': 'Unassigned',
        'Subsystem': 'No Subsystem',
        'Fix Versions': 'Unscheduled',
        'Affected versions': 'Unknown',
        'Fixed in build': 'Next Build',
      },
    ),
    const ProjectTemplateModel(
      id: 'scrum',
      name: 'Scrum',
      description:
          'Scrum agile development template with sprints, backlog, and story points.',
      iconKey: 'view_week',
      defaultFields: {
        'Priority': 'Normal',
        'Type': 'User Story',
        'State': 'Backlog',
        'Sprint': 'Sprint 1',
        'Story Points': '0',
      },
    ),
    const ProjectTemplateModel(
      id: 'kanban',
      name: 'Kanban',
      description:
          'Kanban continuous workflow management template with WIP limits.',
      iconKey: 'view_kanban',
      defaultFields: {
        'Priority': 'Normal',
        'Type': 'Task',
        'State': 'To Do',
        'WIP Limit': '5',
      },
    ),
    const ProjectTemplateModel(
      id: 'task_management',
      name: 'Task Management',
      description:
          'Simplified project management template for teams tracking simple tasks.',
      iconKey: 'check_box',
      defaultFields: {
        'Priority': 'Normal',
        'Type': 'Task',
        'State': 'Open',
        'Due Date': 'Not Set',
      },
    ),
    const ProjectTemplateModel(
      id: 'helpdesk',
      name: 'Helpdesk',
      description: 'Customer support and ticket management template.',
      iconKey: 'headset_mic',
      defaultFields: {
        'Priority': 'High',
        'Type': 'Ticket',
        'State': 'New',
        'SLA': '24 Hours',
      },
    ),
    const ProjectTemplateModel(
      id: 'project_management',
      name: 'Project Management',
      description:
          'Comprehensive project management with milestones and dependencies.',
      iconKey: 'account_tree',
      defaultFields: {
        'Priority': 'Normal',
        'Type': 'Feature',
        'State': 'Planning',
      },
    ),
    const ProjectTemplateModel(
      id: 'demo',
      name: 'Demo',
      description: 'Sample template pre-filled with demo data for exploration.',
      iconKey: 'play_circle_outline',
      defaultFields: {
        'Priority': 'Normal',
        'Type': 'Demo Issue',
        'State': 'Open',
      },
    ),
    const ProjectTemplateModel(
      id: 'marketing',
      name: 'Marketing',
      description:
          'Campaign tracking and content management template for marketing teams.',
      iconKey: 'campaign',
      defaultFields: {
        'Priority': 'Medium',
        'Type': 'Campaign',
        'State': 'Draft',
      },
    ),
  ];

  final List<ProjectModel> _projects = [
    ProjectModel(
      id: 'proj_demo',
      name: 'Demo Project',
      projectKey: 'DEMO',
      description: 'Demonstration project showcasing YouTrack capabilities.',
      isArchived: false,
      isTemplate: false,
      templateId: 'demo',
      ownerId: 'admin',
      createdAt: DateTime(2026, 7, 20),
      isFavorite: true,
    ),
    ProjectModel(
      id: 'proj_fingerprint',
      name: 'fingerprint',
      projectKey: 'FIN',
      description: 'Biometric fingerprint authentication subsystem.',
      isArchived: false,
      isTemplate: false,
      templateId: 'default',
      ownerId: 'admin',
      createdAt: DateTime(2026, 7, 22),
      isFavorite: false,
    ),
    ProjectModel(
      id: 'proj_test',
      name: 'Test project',
      projectKey: 'TP',
      description: 'Primary testing environment for new workflow features.',
      isArchived: false,
      isTemplate: false,
      templateId: 'default',
      ownerId: 'admin',
      createdAt: DateTime(2026, 7, 24),
      isFavorite: false,
    ),
  ];

  final List<ProjectMemberModel> _members = [
    const ProjectMemberModel(
      id: 'm1',
      projectId: 'proj_test',
      name: 'AD',
      email: 'osmflutterdeveloper@gmail.com',
      roles: ['System Admin', 'Contributor', 'Project Admin'],
      isOwner: true,
    ),
    const ProjectMemberModel(
      id: 'm2',
      projectId: 'proj_test',
      name: 'Registered Users',
      email: 'users@youtrack.local',
      roles: ['Contributor'],
      isOwner: false,
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
      (p) => p.id == id || p.projectKey == id,
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
        projectKey: p.projectKey,
        description: p.description,
        isArchived: true,
        isTemplate: p.isTemplate,
        templateId: p.templateId,
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
