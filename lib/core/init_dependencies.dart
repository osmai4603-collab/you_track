import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:issues_tracking/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:issues_tracking/features/auth/data/datasources/auth_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:issues_tracking/features/auth/domain/repositories/auth_repository.dart';
import 'package:issues_tracking/features/auth/domain/usecases/login_use_case.dart';
import 'package:issues_tracking/features/auth/presentation/cubits/login_cubit.dart';
import 'package:issues_tracking/features/issues/data/datasources/issues_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/issues/data/datasources/tag_sqlite_datasource_impl.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_templates_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:issues_tracking/features/dashboards/data/datasources/dashboard_remote_data_source.dart';
import 'package:issues_tracking/features/dashboards/data/datasources/dashboard_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/dashboards/data/repositories/dashboard_repository_impl.dart';
import "package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart";
import "package:issues_tracking/features/dashboards/domain/usecases/get_dashboards.dart";
import "package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart";
import "package:issues_tracking/features/app/presentation/cubit/youtrack_shell_cubit.dart";
import 'package:issues_tracking/core/services/supabase_storage_service.dart';

import 'package:issues_tracking/features/issues/data/datasources/issues_remote_data_source.dart';
import 'package:issues_tracking/features/issues/data/repositories/issues_repository_impl.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_builds_use_case.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issue_by_id.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';

import 'package:issues_tracking/features/app/data/datasources/app_settings_local_data_source.dart';
import 'package:issues_tracking/features/app/data/repositories/app_settings_repository_impl.dart';
import 'package:issues_tracking/features/app/domain/repositories/app_settings_repository.dart';
import 'package:issues_tracking/features/app/domain/usecases/get_app_settings.dart';
import 'package:issues_tracking/features/app/domain/usecases/save_app_settings.dart';
import 'package:issues_tracking/features/app/presentation/cubit/app_cubit.dart';
import 'package:issues_tracking/features/projects/data/datasources/projects_local_data_source.dart';
import 'package:issues_tracking/features/projects/data/datasources/projects_remote_data_source.dart';
import 'package:issues_tracking/features/projects/data/datasources/projects_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:issues_tracking/features/projects/domain/repositories/projects_repository.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_sprints_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_by_id_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/create_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/update_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/archive_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/delete_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_members_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/add_project_member_use_case.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_creation_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';

import 'package:issues_tracking/features/custom_fields/data/datasources/custom_fields_remote_data_source.dart';
import 'package:issues_tracking/features/custom_fields/data/repositories/custom_fields_repository_impl.dart';
import 'package:issues_tracking/features/custom_fields/domain/repositories/custom_fields_repository.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/get_custom_fields_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/add_custom_field_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/update_custom_field_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/delete_custom_fields_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/reorder_custom_fields_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/update_field_visibility_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/update_field_access_control_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/replace_field_value_use_case.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/update_advanced_field_settings_use_case.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/custom_fields_cubit.dart';

import 'package:issues_tracking/features/custom_fields/data/datasources/custom_field_remote_data_source.dart';
import 'package:issues_tracking/features/custom_fields/data/repositories/custom_field_repository_impl.dart';
import 'package:issues_tracking/features/custom_fields/domain/repositories/custom_field_repository.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/validate_custom_field_name.dart';
import 'package:issues_tracking/features/custom_fields/domain/usecases/create_custom_field.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/cubits/custom_field_panel_cubit.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/cubits/tab_selection_cubit.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/cubits/form_state_cubit.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/cubits/privacy_state_cubit.dart';

import 'package:issues_tracking/features/version_control/data/datasources/version_control_remote_data_source.dart';
import 'package:issues_tracking/features/version_control/data/repositories/version_control_repository_impl.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/get_integrations_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/create_integration_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/update_integration_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/delete_integration_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/test_connection_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/manage_user_mapping_use_case.dart';
import 'package:issues_tracking/features/version_control/domain/usecases/sync_commits_use_case.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';

import 'package:issues_tracking/features/time_tracking/data/datasources/time_tracking_remote_data_source.dart';
import 'package:issues_tracking/features/time_tracking/data/repositories/time_tracking_repository_impl.dart';
import 'package:issues_tracking/features/time_tracking/domain/repositories/time_tracking_repository.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/get_time_tracking_config.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/save_time_tracking_config.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/get_available_period_fields.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/get_work_types.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/add_work_type.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/update_work_type.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/delete_work_type.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/reorder_work_types.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/get_custom_work_item_attributes.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/add_custom_work_item_attribute.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/update_custom_work_item_attribute.dart';
import 'package:issues_tracking/features/time_tracking/domain/usecases/delete_custom_work_item_attribute.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart';

import 'package:issues_tracking/features/knowledge_base/data/datasources/article_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_comment_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_notification_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/repositories/article_repository_impl.dart';
import 'package:issues_tracking/features/knowledge_base/data/repositories/article_comment_repository_impl.dart';
import 'package:issues_tracking/features/knowledge_base/data/repositories/article_notification_repository_impl.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_notification_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_tree.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_article_by_id.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/create_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/update_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/publish_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/reorder_articles.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/search_articles.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/save_draft.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_draft.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/add_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/resolve_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/delete_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_comments_for_article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/subscribe_to_notifications.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_comment_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_toc_cubit.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_search_cubit.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_notification_cubit.dart';

import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';
import 'package:issues_tracking/features/issues/data/datasources/tag_remote_datasource.dart';
import 'package:issues_tracking/features/issues/data/repositories/tags_repository_impl.dart';
import 'package:issues_tracking/features/issues/domain/repositories/tags_repository.dart';
import 'package:issues_tracking/features/issues/domain/usecases/create_tag.dart';
import 'package:issues_tracking/features/issues/domain/usecases/stream_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_project_members.dart';
import 'package:issues_tracking/features/issues/domain/usecases/is_tag_name_unique.dart';
import 'package:issues_tracking/features/issues/domain/usecases/associate_tag_with_issue.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/new_tag_cubit.dart';

import 'package:issues_tracking/features/agile_boards/data/datasources/agile_boards_supabase_data_source.dart';
import 'package:issues_tracking/features/agile_boards/data/repositories/agile_boards_repository_impl.dart';
import 'package:issues_tracking/features/agile_boards/domain/repositories/agile_boards_repository.dart';
import 'package:issues_tracking/features/agile_boards/domain/use_cases/get_board_details_use_case.dart';
import 'package:issues_tracking/features/agile_boards/domain/use_cases/move_card_use_case.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_bloc.dart';

import 'package:issues_tracking/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:issues_tracking/features/groups/data/datasources/groups_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/groups/data/repositories/groups_repository_impl.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_groups.dart';
import 'package:issues_tracking/features/groups/domain/usecases/create_group.dart';
import 'package:issues_tracking/features/groups/domain/usecases/assign_role.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_group_roles.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_group_members.dart';
import 'package:issues_tracking/features/groups/domain/usecases/add_group_members.dart';
import 'package:issues_tracking/features/groups/domain/usecases/add_group_projects.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_group_by_id.dart';
import 'package:issues_tracking/features/groups/domain/usecases/remove_group_members.dart';
import 'package:issues_tracking/features/groups/domain/usecases/update_group.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';

import 'package:issues_tracking/features/roles/data/datasources/roles_remote_data_source.dart';
import 'package:issues_tracking/features/roles/data/datasources/roles_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/roles/data/repositories/roles_repository_impl.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';
import 'package:issues_tracking/features/roles/domain/usecases/get_roles.dart';
import 'package:issues_tracking/features/roles/domain/usecases/create_role.dart';
import 'package:issues_tracking/features/roles/domain/usecases/update_role.dart';
import 'package:issues_tracking/features/roles/domain/usecases/delete_role.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';

import 'package:issues_tracking/features/users/data/datasources/users_remote_data_source.dart';
import 'package:issues_tracking/features/users/data/datasources/users_sqlite_data_source_impl.dart';
import 'package:issues_tracking/features/users/data/repositories/users_repository_impl.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';
import 'package:issues_tracking/features/users/domain/usecases/create_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/delete_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/ban_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/update_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/merge_users.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';

// ignore: non_constant_identifier_names
final get_it = GetIt.instance;

Future<void> initDependencies({bool isOffline = false}) async {
  // 1. Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  get_it.registerLazySingleton(() => sharedPreferences);
  get_it.registerLazySingleton(() => Supabase.instance.client);
  get_it.registerLazySingleton<SupabaseClient>(
    () => SupabaseClient(
      'https://jadgeemsdhhtrgnieumt.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImphZGdlZW1zZGhodHJnbmlldW10Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NDgxMTYyNSwiZXhwIjoyMTAwMzg3NjI1fQ.SA5mntHuB2a8M93fHTiFL0ktO_Ray53jAEdRLKYoYfg',
    ),
    instanceName: 'adminClient',
  );
  get_it.registerLazySingleton<Box<dynamic>>(() => Hive.box('article_drafts'));
  get_it.registerLazySingleton(
    () => SupabaseStorageService(supabaseClient: get_it()),
  );

  // 2. App Feature Initialization
  _initAppFeature(isOffline: isOffline);
  _initDashboardsFeature(isOffline: isOffline);
  _initIssuesFeature(isOffline: isOffline);
  _initProjectsFeature(isOffline: isOffline);
  _initCustomFieldsFeature(isOffline: isOffline);
  _initVersionControlFeature(isOffline: isOffline);
  _initTimeTrackingFeature(isOffline: isOffline);
  _initAuthFeature(isOffline: isOffline);
  _initKnowledgeBaseFeature(isOffline: isOffline);
  _initAgileBoardsFeature(isOffline: isOffline);
  _initGroupsFeature(isOffline: isOffline);
  _initRolesFeature(isOffline: isOffline);
  _initUsersFeature(isOffline: isOffline);
}

void _initAppFeature({required bool isOffline}) {
  // Data Sources
  get_it.registerLazySingleton<AppSettingsLocalDataSource>(
    () => AppSettingsLocalDataSourceImpl(get_it()),
  );

  // Repositories
  get_it.registerLazySingleton<AppSettingsRepository>(
    () => AppSettingsRepositoryImpl(get_it()),
  );

  // UseCases
  get_it.registerLazySingleton(() => GetAppSettings(get_it()));
  get_it.registerLazySingleton(() => SaveAppSettings(get_it()));

  // Cubits
  get_it.registerFactory(
    () => AppCubit(getAppSettings: get_it(), saveAppSettings: get_it()),
  );
}

void _initDashboardsFeature({required bool isOffline}) {
  // Data sources
  get_it.registerLazySingleton<DashboardRemoteDataSource>(
    () => isOffline
        ? DashboardSqliteDataSourceImpl(get_it())
        : DashboardRemoteDataSourceImpl(get_it()),
  );

  // Repositories
  get_it.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(get_it()),
  );

  // UseCases
  get_it.registerLazySingleton(() => GetDashboards(get_it()));

  // Blocs
  get_it.registerFactory(
    () => DashboardBloc(getDashboards: get_it(), repository: get_it()),
  );

  get_it.registerFactory(() => YouTrackShellCubit());
}

void _initIssuesFeature({required bool isOffline}) {
  // Data Sources
  get_it.registerLazySingleton<IssuesRemoteDataSource>(
    () => isOffline
        ? IssuesSqliteDataSourceImpl(get_it())
        : IssuesRemoteDataSourceImpl(get_it()),
  );
  get_it.registerLazySingleton<TagRemoteDatasource>(
    () => isOffline
        ? TagSqliteDatasourceImpl(get_it())
        : TagRemoteDatasourceImpl(get_it()),
  );

  // Repositories
  get_it.registerLazySingleton<IssuesRepository>(
    () => IssuesRepositoryImpl(get_it()),
  );
  get_it.registerLazySingleton<TagsRepository>(
    () => TagsRepositoryImpl(get_it()),
  );

  // UseCases
  get_it.registerLazySingleton(() => GetIssues(get_it()));
  get_it.registerLazySingleton(() => StreamIssues(get_it()));
  get_it.registerLazySingleton(() => GetIssueById(get_it()));
  get_it.registerLazySingleton(() => CreateTag(get_it()));
  get_it.registerLazySingleton(() => GetProjectMembers(get_it()));
  get_it.registerLazySingleton(() => IsTagNameUnique(get_it()));
  get_it.registerLazySingleton(() => AssociateTagWithIssue(get_it()));

  // Blocs
  get_it.registerFactory(
    () => IssuesBloc(
      getIssues: get_it(),
      streamIssues: get_it(),
      repository: get_it(),
    ),
  );
  get_it.registerFactory(
    () => IssueFormCubit(
      repository: get_it(),
      getSprintsUseCase: get_it(),
      getBuildsUseCase: get_it(),
      getProjectsUseCase: get_it(),
      getProjectMembersUseCase: get_it(),
    ),
  );
  get_it.registerFactory(
    () => NewTagCubit(
      createTagUseCase: get_it(),
      getProjectMembersUseCase: get_it(),
      isTagNameUniqueUseCase: get_it(),
      associateTagUseCase: get_it(),
    ),
  );
}

void _initProjectsFeature({required bool isOffline}) {
  // Data Sources
  get_it.registerLazySingleton<ProjectsLocalDataSource>(
    () => ProjectsLocalDataSourceImpl(),
  );
  get_it.registerLazySingleton<ProjectsRemoteDataSource>(
    () => isOffline
        ? ProjectsSqliteDataSourceImpl(get_it())
        : ProjectsRemoteDataSourceImpl(get_it()),
  );

  // Repositories
  get_it.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(
      remoteDataSource: get_it(),
      localDataSource: get_it(),
    ),
  );

  // UseCases
  get_it.registerLazySingleton(() => GetProjectsUseCase(get_it()));
  get_it.registerLazySingleton(() => GetProjectMembersUseCase(get_it()));
  get_it.registerLazySingleton(() => GetSprintsUseCase(get_it()));
  get_it.registerLazySingleton(() => GetBuildsUseCase(get_it()));
  get_it.registerLazySingleton(() => GetProjectByIdUseCase(get_it()));
  get_it.registerLazySingleton(() => CreateProjectUseCase(get_it()));
  get_it.registerLazySingleton(() => UpdateProjectUseCase(get_it()));
  get_it.registerLazySingleton(() => ArchiveProjectUseCase(get_it()));
  get_it.registerLazySingleton(() => DeleteProjectUseCase(get_it()));
  get_it.registerLazySingleton(() => AddProjectMemberUseCase(get_it()));
  get_it.registerLazySingleton(() => GetProjectTemplatesUseCase(get_it()));

  // Cubits
  get_it.registerFactory(
    () => ProjectsListCubit(
      getProjectsUseCase: get_it(),
      archiveProjectUseCase: get_it(),
      deleteProjectUseCase: get_it(),
      updateProjectUseCase: get_it(),
    ),
  );
  get_it.registerFactory(
    () => ProjectCreationCubit(
      createProjectUseCase: get_it(),
      addProjectMemberUseCase: get_it(),
    ),
  );
  get_it.registerFactory(
    () => ProjectDetailsCubit(getProjectByIdUseCase: get_it()),
  );
  get_it.registerFactory(
    () => ProjectMembersCubit(
      getProjectMembersUseCase: get_it(),
      addProjectMemberUseCase: get_it(),
    ),
  );
}

void _initCustomFieldsFeature({required bool isOffline}) {
  get_it.registerLazySingleton<CustomFieldsRemoteDataSource>(
    () => CustomFieldsRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<CustomFieldsRepository>(
    () => CustomFieldsRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetCustomFieldsUseCase(get_it()));
  get_it.registerLazySingleton(() => AddCustomFieldUseCase(get_it()));
  get_it.registerLazySingleton(() => UpdateCustomFieldUseCase(get_it()));
  get_it.registerLazySingleton(() => DeleteCustomFieldsUseCase(get_it()));
  get_it.registerLazySingleton(() => ReorderCustomFieldsUseCase(get_it()));
  get_it.registerLazySingleton(() => UpdateFieldVisibilityUseCase(get_it()));
  get_it.registerLazySingleton(() => UpdateFieldAccessControlUseCase(get_it()));
  get_it.registerLazySingleton(() => ReplaceFieldValueUseCase(get_it()));
  get_it.registerLazySingleton(
    () => UpdateAdvancedFieldSettingsUseCase(get_it()),
  );

  get_it.registerFactory(
    () => CustomFieldsCubit(
      getFieldsUseCase: get_it(),
      addFieldUseCase: get_it(),
      updateFieldUseCase: get_it(),
      deleteFieldsUseCase: get_it(),
      reorderFieldsUseCase: get_it(),
      updateVisibilityUseCase: get_it(),
      updateAccessControlUseCase: get_it(),
      replaceFieldValueUseCase: get_it(),
      updateAdvancedSettingsUseCase: get_it(),
    ),
  );

  get_it.registerLazySingleton<CustomFieldRemoteDataSource>(
    () => CustomFieldRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<CustomFieldRepository>(
    () => CustomFieldRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => ValidateCustomFieldName(get_it()));
  get_it.registerLazySingleton(() => CreateCustomField(get_it()));

  get_it.registerFactory(() => CustomFieldPanelCubit());
  get_it.registerFactory(() => TabSelectionCubit());
  get_it.registerFactory(
    () => FormStateCubit(
      validateFieldName: get_it(),
      createCustomField: get_it(),
    ),
  );
  get_it.registerFactory(() => PrivacyStateCubit());
}

void _initVersionControlFeature({required bool isOffline}) {
  get_it.registerLazySingleton<VersionControlRemoteDataSource>(
    () => VersionControlRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<VersionControlRepository>(
    () => VersionControlRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetIntegrationsUseCase(get_it()));
  get_it.registerLazySingleton(() => CreateIntegrationUseCase(get_it()));
  get_it.registerLazySingleton(() => UpdateIntegrationUseCase(get_it()));
  get_it.registerLazySingleton(() => DeleteIntegrationUseCase(get_it()));
  get_it.registerLazySingleton(() => TestConnectionUseCase(get_it()));
  get_it.registerLazySingleton(() => ManageUserMappingUseCase(get_it()));
  get_it.registerLazySingleton(() => SyncCommitsUseCase(get_it()));

  get_it.registerFactory(
    () => VcsIntegrationsCubit(
      getIntegrationsUseCase: get_it(),
      createIntegrationUseCase: get_it(),
      updateIntegrationUseCase: get_it(),
      deleteIntegrationUseCase: get_it(),
      testConnectionUseCase: get_it(),
      manageUserMappingUseCase: get_it(),
      syncCommitsUseCase: get_it(),
    ),
  );
}

void _initTimeTrackingFeature({required bool isOffline}) {
  get_it.registerLazySingleton<TimeTrackingRemoteDataSource>(
    () => TimeTrackingRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<TimeTrackingRepository>(
    () => TimeTrackingRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetTimeTrackingConfig(get_it()));
  get_it.registerLazySingleton(() => SaveTimeTrackingConfig(get_it()));
  get_it.registerLazySingleton(() => GetAvailablePeriodFields(get_it()));
  get_it.registerLazySingleton(() => GetWorkTypes(get_it()));
  get_it.registerLazySingleton(() => AddWorkType(get_it()));
  get_it.registerLazySingleton(() => UpdateWorkType(get_it()));
  get_it.registerLazySingleton(() => DeleteWorkType(get_it()));
  get_it.registerLazySingleton(() => ReorderWorkTypes(get_it()));
  get_it.registerLazySingleton(() => GetCustomAttributes(get_it()));
  get_it.registerLazySingleton(() => AddCustomAttribute(get_it()));
  get_it.registerLazySingleton(() => UpdateCustomAttribute(get_it()));
  get_it.registerLazySingleton(() => DeleteCustomAttribute(get_it()));

  get_it.registerFactory(
    () => TimeTrackingConfigCubit(
      getConfigUseCase: get_it(),
      saveConfigUseCase: get_it(),
      getAvailablePeriodFieldsUseCase: get_it(),
    ),
  );
}

void _initKnowledgeBaseFeature({required bool isOffline}) {
  get_it.registerLazySingleton<ArticleRemoteDataSource>(
    () => ArticleRemoteDataSourceImpl(get_it()),
  );
  get_it.registerLazySingleton<ArticleLocalDataSource>(
    () => ArticleLocalDataSourceImpl(get_it()),
  );
  get_it.registerLazySingleton<ArticleCommentRemoteDataSource>(
    () => ArticleCommentRemoteDataSourceImpl(get_it()),
  );
  get_it.registerLazySingleton<ArticleNotificationRemoteDataSource>(
    () => ArticleNotificationRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(
      remoteDataSource: get_it(),
      localDataSource: get_it(),
    ),
  );
  get_it.registerLazySingleton<ArticleCommentRepository>(
    () => ArticleCommentRepositoryImpl(remoteDataSource: get_it()),
  );
  get_it.registerLazySingleton<ArticleNotificationRepository>(
    () => ArticleNotificationRepositoryImpl(remoteDataSource: get_it()),
  );

  get_it.registerLazySingleton(() => GetArticleTree(get_it()));
  get_it.registerLazySingleton(() => GetArticleById(get_it()));
  get_it.registerLazySingleton(() => CreateArticle(get_it()));
  get_it.registerLazySingleton(() => UpdateArticle(get_it()));
  get_it.registerLazySingleton(() => PublishArticle(get_it()));
  get_it.registerLazySingleton(() => DeleteArticle(get_it()));
  get_it.registerLazySingleton(() => ReorderArticles(get_it()));
  get_it.registerLazySingleton(() => SearchArticles(get_it()));
  get_it.registerLazySingleton(() => SaveDraft(get_it()));
  get_it.registerLazySingleton(() => GetDraft(get_it()));
  get_it.registerLazySingleton(() => AddComment(get_it()));
  get_it.registerLazySingleton(() => ResolveComment(get_it()));
  get_it.registerLazySingleton(() => DeleteComment(get_it()));
  get_it.registerLazySingleton(() => GetCommentsForArticle(get_it()));
  get_it.registerLazySingleton(() => SubscribeToNotifications(get_it()));

  get_it.registerFactory(
    () => ArticleTreeBloc(
      getArticleTree: get_it(),
      deleteArticle: get_it(),
      reorderArticles: get_it(),
    ),
  );
  get_it.registerFactory(
    () => ArticleEditorBloc(
      createArticle: get_it(),
      updateArticle: get_it(),
      publishArticle: get_it(),
      saveDraft: get_it(),
      getDraft: get_it(),
    ),
  );
  get_it.registerFactory(
    () => ArticleCommentBloc(
      getComments: get_it(),
      addComment: get_it(),
      resolveComment: get_it(),
      deleteComment: get_it(),
    ),
  );
  get_it.registerFactory(() => ArticleTocCubit());
  get_it.registerFactory(() => ArticleSearchCubit(searchArticles: get_it()));
  get_it.registerFactory(
    () => ArticleNotificationCubit(subscribeToNotifications: get_it()),
  );
}

void _initAuthFeature({required bool isOffline}) {
  get_it.registerLazySingleton<AuthRemoteDataSource>(
    () => isOffline
        ? AuthSqliteDataSourceImpl(get_it())
        : AuthRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => LoginUseCase(get_it()));

  get_it.registerFactory(() => LoginCubit(loginUseCase: get_it()));

  get_it.registerLazySingleton<UserSession>(() => UserSession());
}

void _initAgileBoardsFeature({required bool isOffline}) {
  get_it.registerLazySingleton<AgileBoardsRemoteDataSource>(
    () => AgileBoardsSupabaseDataSource(get_it()),
  );

  get_it.registerLazySingleton<AgileBoardsRepository>(
    () => AgileBoardsRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetBoardDetailsUseCase(get_it()));
  get_it.registerLazySingleton(() => MoveCardUseCase(get_it()));

  get_it.registerFactory(
    () => AgileBoardsBloc(
      getBoardDetailsUseCase: get_it(),
      moveCardUseCase: get_it(),
    ),
  );
}

void _initGroupsFeature({required bool isOffline}) {
  get_it.registerLazySingleton<GroupsRemoteDataSource>(
    () => isOffline
        ? GroupsSqliteDataSourceImpl(get_it())
        : GroupsRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<GroupsRepository>(
    () => GroupsRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetGroups(get_it()));
  get_it.registerLazySingleton(() => CreateGroup(get_it()));
  get_it.registerLazySingleton(() => AssignRole(get_it()));
  get_it.registerLazySingleton(() => GetGroupRoles(get_it()));
  get_it.registerLazySingleton(() => GetGroupMembers(get_it()));
  get_it.registerLazySingleton(() => AddGroupMembers(get_it()));
  get_it.registerLazySingleton(() => RemoveGroupMembers(get_it()));
  get_it.registerLazySingleton(() => AddGroupProjects(get_it()));
  get_it.registerLazySingleton(() => GetGroupById(get_it()));
  get_it.registerLazySingleton(() => UpdateGroup(get_it()));

  get_it.registerFactory(
    () => GroupsBloc(
      getGroups: get_it(),
      createGroup: get_it(),
      assignRole: get_it(),
      getGroupById: get_it(),
      addGroupMembers: get_it(),
      addGroupProjects: get_it(),
      updateGroup: get_it(),
    ),
  );
}

void _initRolesFeature({required bool isOffline}) {
  get_it.registerLazySingleton<RolesRemoteDataSource>(
    () => isOffline
        ? RolesSqliteDataSourceImpl(get_it())
        : RolesRemoteDataSourceImpl(get_it()),
  );

  get_it.registerLazySingleton<RolesRepository>(
    () => RolesRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetRoles(get_it()));
  get_it.registerLazySingleton(() => CreateRole(get_it()));
  get_it.registerLazySingleton(() => UpdateRole(get_it()));
  get_it.registerLazySingleton(() => DeleteRole(get_it()));

  get_it.registerFactory(
    () => RolesBloc(
      getRoles: get_it(),
      createRole: get_it(),
      updateRole: get_it(),
      deleteRole: get_it(),
    ),
  );
}

void _initUsersFeature({required bool isOffline}) {
  get_it.registerLazySingleton<UsersRemoteDataSource>(
    () => isOffline
        ? UsersSqliteDataSourceImpl(get_it())
        : UsersRemoteDataSourceImpl(
            get_it(),
            adminClient: get_it(instanceName: 'adminClient'),
          ),
  );

  get_it.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(get_it()),
  );

  get_it.registerLazySingleton(() => GetUsers(get_it()));
  get_it.registerLazySingleton(() => CreateUser(get_it()));
  get_it.registerLazySingleton(() => DeleteUser(get_it()));
  get_it.registerLazySingleton(() => BanUser(get_it()));
  get_it.registerLazySingleton(() => UpdateUser(get_it()));
  get_it.registerLazySingleton(() => MergeUsers(get_it()));

  get_it.registerFactory(
    () => UsersBloc(
      getUsers: get_it(),
      createUser: get_it(),
      deleteUser: get_it(),
      banUser: get_it(),
      updateUser: get_it(),
      mergeUsers: get_it(),
      addGroupMembers: get_it(),
      removeGroupMembers: get_it(),
      getGroups: get_it(),
      getGroupMembers: get_it(),
    ),
  );
}
