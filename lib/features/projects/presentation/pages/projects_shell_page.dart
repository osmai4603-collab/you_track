import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/projects_list_cubit.dart';
import '../cubits/project_creation_cubit.dart';
import '../cubits/project_details_cubit.dart';
import '../cubits/project_members_cubit.dart';
import 'projects_list_page.dart';
import 'project_template_selection_page.dart';
import 'project_template_details_page.dart';
import 'create_project_form_page.dart';
import 'add_project_members_page.dart';
import 'project_details_page.dart';
import 'project_members_page.dart';

/// الصفحة الرئيسية التي تدير التنقل الداخلي بين جميع صفحات قسم المشاريع.
/// تستخدم Navigator داخلي لتجنب تعقيد GoRouter مع الصفحات الفرعية المتعددة.
class ProjectsShellPage extends StatefulWidget {
  const ProjectsShellPage({super.key});

  @override
  State<ProjectsShellPage> createState() => _ProjectsShellPageState();
}

enum ProjectsView {
  list,
  templateSelection,
  templateDetails,
  createForm,
  addMembers,
  projectDetails,
  projectMembers,
}

class _ProjectsShellPageState extends State<ProjectsShellPage> {
  ProjectsView _currentView = ProjectsView.list;
  String? _selectedProjectId;
  String? _selectedTemplateId;

  void _navigateTo(ProjectsView view, {String? projectId, String? templateId}) {
    setState(() {
      _currentView = view;
      if (projectId != null) _selectedProjectId = projectId;
      if (templateId != null) _selectedTemplateId = templateId;
    });
  }

  void _goBack() {
    setState(() {
      switch (_currentView) {
        case ProjectsView.templateSelection:
          _currentView = ProjectsView.list;
          break;
        case ProjectsView.templateDetails:
          _currentView = ProjectsView.templateSelection;
          break;
        case ProjectsView.createForm:
          _currentView = ProjectsView.templateDetails;
          break;
        case ProjectsView.addMembers:
          _currentView = ProjectsView.createForm;
          break;
        case ProjectsView.projectDetails:
          _currentView = ProjectsView.list;
          break;
        case ProjectsView.projectMembers:
          _currentView = ProjectsView.projectDetails;
          break;
        case ProjectsView.list:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case ProjectsView.list:
        return ProjectsListPage(
          key: const ValueKey('list'),
          onCreateProject: () => _navigateTo(ProjectsView.templateSelection),
          onProjectTap: (id) {
            context.read<ProjectDetailsCubit>().loadProject(id);
            _navigateTo(ProjectsView.projectDetails, projectId: id);
          },
        );
      case ProjectsView.templateSelection:
        return ProjectTemplateSelectionPage(
          key: const ValueKey('templates'),
          onTemplateTap: (template) {
            context.read<ProjectCreationCubit>().selectTemplate(template);
            _navigateTo(ProjectsView.templateDetails, templateId: template.id);
          },
          onBack: _goBack,
        );
      case ProjectsView.templateDetails:
        return ProjectTemplateDetailsPage(
          key: const ValueKey('templateDetails'),
          onUseTemplate: () => _navigateTo(ProjectsView.createForm),
          onCancel: _goBack,
        );
      case ProjectsView.createForm:
        return CreateProjectFormPage(
          key: const ValueKey('createForm'),
          onProjectCreated: (project) {
            context.read<ProjectsListCubit>().addProjectLocally(project);
            _navigateTo(ProjectsView.addMembers, projectId: project.id);
          },
          onCancel: _goBack,
        );
      case ProjectsView.addMembers:
        return AddProjectMembersPage(
          key: const ValueKey('addMembers'),
          onSkip: () {
            _navigateTo(ProjectsView.projectDetails);
            if (_selectedProjectId != null) {
              context.read<ProjectDetailsCubit>().loadProject(_selectedProjectId!);
            }
          },
          onBack: _goBack,
          onNext: () {
            _navigateTo(ProjectsView.projectDetails);
            if (_selectedProjectId != null) {
              context.read<ProjectDetailsCubit>().loadProject(_selectedProjectId!);
            }
          },
        );
      case ProjectsView.projectDetails:
        return ProjectDetailsPage(
          key: const ValueKey('projectDetails'),
          onBack: () => _navigateTo(ProjectsView.list),
          onManageMembers: () {
            if (_selectedProjectId != null) {
              context.read<ProjectMembersCubit>().loadMembers(_selectedProjectId!);
            }
            _navigateTo(ProjectsView.projectMembers);
          },
        );
      case ProjectsView.projectMembers:
        return ProjectMembersPage(
          key: const ValueKey('projectMembers'),
          projectId: _selectedProjectId ?? '',
          onBack: _goBack,
        );
    }
  }
}
