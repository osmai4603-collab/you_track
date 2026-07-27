import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/get_integrations_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/create_integration_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/update_integration_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/delete_integration_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/test_connection_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/manage_user_mapping_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/sync_commits_use_case.dart';

part 'vcs_integrations_state.dart';

class VcsIntegrationsCubit extends Cubit<VcsIntegrationsState> {
  final GetIntegrationsUseCase getIntegrationsUseCase;
  final CreateIntegrationUseCase createIntegrationUseCase;
  final UpdateIntegrationUseCase updateIntegrationUseCase;
  final DeleteIntegrationUseCase deleteIntegrationUseCase;
  final TestConnectionUseCase testConnectionUseCase;
  final ManageUserMappingUseCase manageUserMappingUseCase;
  final SyncCommitsUseCase syncCommitsUseCase;

  VcsIntegrationsCubit({
    required this.getIntegrationsUseCase,
    required this.createIntegrationUseCase,
    required this.updateIntegrationUseCase,
    required this.deleteIntegrationUseCase,
    required this.testConnectionUseCase,
    required this.manageUserMappingUseCase,
    required this.syncCommitsUseCase,
  }) : super(const VcsIntegrationsInitial());

  String _currentProjectId = '';

  Future<void> loadIntegrations(String projectId) async {
    _currentProjectId = projectId;
    emit(const VcsIntegrationsLoading());
    final result = await getIntegrationsUseCase(
        params: GetIntegrationsParams(projectId));
    result.fold(
      (failure) => emit(VcsIntegrationsError(failure.message)),
      (integrations) => emit(VcsIntegrationsLoaded(integrations)),
    );
  }

  Future<void> createIntegration(VcsIntegrationEntity integration) async {
    emit(const VcsIntegrationsLoading());
    final result = await createIntegrationUseCase(
        params: CreateIntegrationParams(integration));
    result.fold(
      (failure) => emit(VcsIntegrationsError(failure.message)),
      (_) => loadIntegrations(_currentProjectId),
    );
  }

  Future<void> updateIntegration(VcsIntegrationEntity integration) async {
    emit(const VcsIntegrationsLoading());
    final result = await updateIntegrationUseCase(
        params: UpdateIntegrationParams(integration));
    result.fold(
      (failure) => emit(VcsIntegrationsError(failure.message)),
      (_) => loadIntegrations(_currentProjectId),
    );
  }

  Future<void> deleteIntegration(String integrationId) async {
    emit(const VcsIntegrationsLoading());
    final result = await deleteIntegrationUseCase(
        params: DeleteIntegrationParams(integrationId));
    result.fold(
      (failure) => emit(VcsIntegrationsError(failure.message)),
      (_) => loadIntegrations(_currentProjectId),
    );
  }

  Future<VcsIntegrationEntity?> testConnection(String integrationId) async {
    final result = await testConnectionUseCase(
        params: TestConnectionParams(integrationId));
    return result.fold(
      (failure) {
        emit(VcsIntegrationsError(failure.message));
        return null;
      },
      (integration) => integration,
    );
  }

  Future<List<VcsUserMappingEntity>> loadUserMappings(
      String integrationId) async {
    final result = await manageUserMappingUseCase(
        params: ManageUserMappingParams(integrationId: integrationId));
    return result.fold(
      (failure) {
        emit(VcsIntegrationsError(failure.message));
        return <VcsUserMappingEntity>[];
      },
      (mappings) => mappings,
    );
  }

  Future<void> addUserMapping(VcsUserMappingEntity mapping) async {
    final result = await manageUserMappingUseCase(
        params: ManageUserMappingParams(
      integrationId: mapping.integrationId,
      newMapping: mapping,
    ));
    result.fold(
      (failure) => emit(VcsIntegrationsError(failure.message)),
      (_) {},
    );
  }

  Future<void> deleteUserMapping(String integrationId, String mappingId) async {
    final result = await manageUserMappingUseCase(
        params: ManageUserMappingParams(
      integrationId: integrationId,
      deleteMappingId: mappingId,
    ));
    result.fold(
      (failure) => emit(VcsIntegrationsError(failure.message)),
      (_) {},
    );
  }

  Future<List<VcsCommitEntity>> loadCommits(String integrationId,
      {String? taskId}) async {
    final result = await syncCommitsUseCase(
        params: SyncCommitsParams(integrationId: integrationId, taskId: taskId));
    return result.fold(
      (failure) {
        emit(VcsIntegrationsError(failure.message));
        return <VcsCommitEntity>[];
      },
      (commits) => commits,
    );
  }
}
