import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/project_template_enum.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_member_entity.dart';
import '../../domain/usecases/add_project_member_use_case.dart';
import '../../domain/usecases/create_project_use_case.dart';

enum ProjectCreationStatus {
  initial,
  loading,
  templatesLoaded,
  projectCreated,
  failure,
}

class ProjectCreationState extends Equatable {
  final ProjectCreationStatus status;
  final ProjectTemplateType selectedTemplate;
  final String projectName;
  final String projectKey;
  final String projectDescription;
  final int startingNumber;
  final ProjectEntity? createdProject;
  final List<ProjectMemberEntity> pendingMembers;
  final String? errorMessage;

  const ProjectCreationState({
    this.status = ProjectCreationStatus.initial,
    this.selectedTemplate = .kanban,
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
    ProjectTemplateType? selectedTemplate,
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
  final CreateProjectUseCase _createProjectUseCase;
  final AddProjectMemberUseCase _addProjectMemberUseCase;

  ProjectCreationCubit({
    required this._createProjectUseCase,
    required this._addProjectMemberUseCase,
  }) : super(const ProjectCreationState());

  void selectTemplate(ProjectTemplateType template) {
    emit(state.copyWith(selectedTemplate: template));
  }

  void updateFormInfo({
    required String name,
    required String key,
    String? description,
    int? startingNumber,
  }) {
    emit(
      state.copyWith(
        projectName: name,
        projectKey: key.toUpperCase(),
        projectDescription: description,
        startingNumber: startingNumber,
      ),
    );
  }

  Future<void> submitCreateProject() async {
    if (state.projectName.trim().isEmpty || state.projectKey.trim().isEmpty) {
      emit(
        state.copyWith(
          status: ProjectCreationStatus.failure,
          errorMessage: 'الرجاء إدخال اسم ومعرف المشروع',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ProjectCreationStatus.loading));

    final userSession = get_it<UserSession>();

    final newProject = ProjectEntity(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: state.projectName.trim(),
      projectId: state.projectKey.trim().toUpperCase(),
      description: state.projectDescription.isNotEmpty
          ? state.projectDescription.trim()
          : state.selectedTemplate.description,
      isArchived: false,

      templateType: state.selectedTemplate,
      ownerId: userSession.currentUser?.id ?? 'unknown',
      createdAt: DateTime.now(),
    );

    final result = await _createProjectUseCase(
      params: CreateProjectParams(project: newProject),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProjectCreationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (created) {
        emit(
          state.copyWith(
            status: ProjectCreationStatus.projectCreated,
            createdProject: created,
          ),
        );
      },
    );
  }

  void addPendingMember(String emailOrName) {
    if (emailOrName.trim().isEmpty || state.createdProject == null) return;
    final member = ProjectMemberEntity(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      projectId: state.createdProject!.id,
      // name: emailOrName.contains('@')
      //     ? emailOrName.split('@').first
      //     : emailOrName,
      // email: emailOrName.contains('@')
      //     ? emailOrName
      //     : '$emailOrName@youtrack.local',
      isOwner: false,
      roles: const ['Contributor'],
      userId: '',
    );
    final updated = [...state.pendingMembers, member];
    emit(state.copyWith(pendingMembers: updated));
    _addProjectMemberUseCase(params: AddProjectMemberParams(member: member));
  }
}
