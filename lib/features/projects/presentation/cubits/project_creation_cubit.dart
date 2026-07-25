import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_member_entity.dart';
import '../../domain/entities/project_template_entity.dart';
import '../../domain/usecases/add_project_member_use_case.dart';
import '../../domain/usecases/create_project_use_case.dart';
import '../../domain/usecases/get_project_templates_use_case.dart';

enum ProjectCreationStatus { initial, loading, templatesLoaded, projectCreated, failure }

class ProjectCreationState extends Equatable {
  final ProjectCreationStatus status;
  final List<ProjectTemplateEntity> templates;
  final ProjectTemplateEntity? selectedTemplate;
  final String projectName;
  final String projectKey;
  final String projectDescription;
  final int startingNumber;
  final ProjectEntity? createdProject;
  final List<ProjectMemberEntity> pendingMembers;
  final String? errorMessage;

  const ProjectCreationState({
    this.status = ProjectCreationStatus.initial,
    this.templates = const [],
    this.selectedTemplate,
    this.projectName = '',
    this.projectKey = '',
    this.projectDescription = '',
    this.startingNumber = 1,
    this.createdProject,
    this.pendingMembers = const [],
    this.errorMessage,
  });

  ProjectCreationState copyWith({
    ProjectCreationStatus? status,
    List<ProjectTemplateEntity>? templates,
    ProjectTemplateEntity? selectedTemplate,
    String? projectName,
    String? projectKey,
    String? projectDescription,
    int? startingNumber,
    ProjectEntity? createdProject,
    List<ProjectMemberEntity>? pendingMembers,
    String? errorMessage,
  }) {
    return ProjectCreationState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      projectName: projectName ?? this.projectName,
      projectKey: projectKey ?? this.projectKey,
      projectDescription: projectDescription ?? this.projectDescription,
      startingNumber: startingNumber ?? this.startingNumber,
      createdProject: createdProject ?? this.createdProject,
      pendingMembers: pendingMembers ?? this.pendingMembers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        templates,
        selectedTemplate,
        projectName,
        projectKey,
        projectDescription,
        startingNumber,
        createdProject,
        pendingMembers,
        errorMessage,
      ];
}

class ProjectCreationCubit extends Cubit<ProjectCreationState> {
  final GetProjectTemplatesUseCase _getProjectTemplatesUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final AddProjectMemberUseCase _addProjectMemberUseCase;

  ProjectCreationCubit({
    required GetProjectTemplatesUseCase getProjectTemplatesUseCase,
    required CreateProjectUseCase createProjectUseCase,
    required AddProjectMemberUseCase addProjectMemberUseCase,
  })  : _getProjectTemplatesUseCase = getProjectTemplatesUseCase,
        _createProjectUseCase = createProjectUseCase,
        _addProjectMemberUseCase = addProjectMemberUseCase,
        super(const ProjectCreationState());

  Future<void> loadTemplates() async {
    emit(state.copyWith(status: ProjectCreationStatus.loading));
    final result = await _getProjectTemplatesUseCase(params: const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProjectCreationStatus.failure,
        errorMessage: failure.message,
      )),
      (templates) => emit(state.copyWith(
        status: ProjectCreationStatus.templatesLoaded,
        templates: templates,
        selectedTemplate: templates.isNotEmpty ? templates.first : null,
      )),
    );
  }

  void selectTemplate(ProjectTemplateEntity template) {
    emit(state.copyWith(selectedTemplate: template));
  }

  void updateFormInfo({required String name, required String key, String? description, int? startingNumber}) {
    emit(state.copyWith(
      projectName: name,
      projectKey: key.toUpperCase(),
      projectDescription: description,
      startingNumber: startingNumber,
    ));
  }

  Future<void> submitCreateProject() async {
    if (state.projectName.trim().isEmpty || state.projectKey.trim().isEmpty) {
      emit(state.copyWith(
        status: ProjectCreationStatus.failure,
        errorMessage: 'الرجاء إدخال اسم ومعرف المشروع',
      ));
      return;
    }

    emit(state.copyWith(status: ProjectCreationStatus.loading));

    final newProject = ProjectEntity(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: state.projectName.trim(),
      projectKey: state.projectKey.trim().toUpperCase(),
      description: state.projectDescription.isNotEmpty
          ? state.projectDescription.trim()
          : state.selectedTemplate?.description,
      isArchived: false,
      isTemplate: false,
      templateId: state.selectedTemplate?.id ?? 'default',
      owner: 'admin',
      createdAt: DateTime.now(),
    );

    final result = await _createProjectUseCase(params: CreateProjectParams(project: newProject));
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProjectCreationStatus.failure,
        errorMessage: failure.message,
      )),
      (created) {
        emit(state.copyWith(
          status: ProjectCreationStatus.projectCreated,
          createdProject: created,
        ));
      },
    );
  }

  void addPendingMember(String emailOrName) {
    if (emailOrName.trim().isEmpty || state.createdProject == null) return;
    final member = ProjectMemberEntity(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      projectId: state.createdProject!.id,
      name: emailOrName.contains('@') ? emailOrName.split('@').first : emailOrName,
      email: emailOrName.contains('@') ? emailOrName : '$emailOrName@youtrack.local',
      roles: const ['Contributor'],
    );
    final updated = [...state.pendingMembers, member];
    emit(state.copyWith(pendingMembers: updated));
    _addProjectMemberUseCase(params: AddProjectMemberParams(member: member));
  }
}
