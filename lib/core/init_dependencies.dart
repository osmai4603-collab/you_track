import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:issues_tracking/features/dashboards/data/datasources/dashboard_remote_data_source.dart";
import "package:issues_tracking/features/dashboards/data/repositories/dashboard_repository_impl.dart";
import "package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart";
import "package:issues_tracking/features/dashboards/domain/usecases/get_dashboards.dart";
import "package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart";
import "package:issues_tracking/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart";

import 'package:issues_tracking/features/issues/data/datasources/issues_remote_data_source.dart';
import 'package:issues_tracking/features/issues/data/repositories/issues_repository_impl.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
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
import 'package:issues_tracking/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:issues_tracking/features/projects/domain/repositories/projects_repository.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_templates_use_case.dart';
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
import 'package:issues_tracking/features/custom_fields/presentation/cubits/custom_fields_cubit.dart';

import 'package:issues_tracking/features/custom_field/data/datasources/custom_field_remote_data_source.dart';
import 'package:issues_tracking/features/custom_field/data/repositories/custom_field_repository_impl.dart';
import 'package:issues_tracking/features/custom_field/domain/repositories/custom_field_repository.dart';
import 'package:issues_tracking/features/custom_field/domain/usecases/validate_custom_field_name.dart';
import 'package:issues_tracking/features/custom_field/domain/usecases/create_custom_field.dart';
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

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton<Box<dynamic>>(() => Hive.box('article_drafts'));

  // 2. App Feature Initialization
  _initAppFeature();
  _initDashboardsFeature();
  _initIssuesFeature();
  _initProjectsFeature();
  _initCustomFieldsFeature();
  _initCustomFieldFeature();
  _initVersionControlFeature();
  _initTimeTrackingFeature();
  _initKnowledgeBaseFeature();
}

void _initAppFeature() {
  // Data Sources
  sl.registerLazySingleton<AppSettingsLocalDataSource>(
    () => AppSettingsLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AppSettingsRepository>(
    () => AppSettingsRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetAppSettings(sl()));
  sl.registerLazySingleton(() => SaveAppSettings(sl()));

  // Cubits
  sl.registerFactory(
    () => AppCubit(getAppSettings: sl(), saveAppSettings: sl()),
  );
}

void _initDashboardsFeature() {
  // Data Sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetDashboards(sl()));

  // Blocs
  sl.registerFactory(
    () => DashboardBloc(getDashboards: sl(), repository: sl()),
  );

  sl.registerFactory(() => YouTrackShellCubit());
}

void _initIssuesFeature() {
  // Data Sources
  sl.registerLazySingleton<IssuesRemoteDataSource>(
    () => IssuesRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<IssuesRepository>(() => IssuesRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => GetIssues(sl()));
  sl.registerLazySingleton(() => GetIssueById(sl()));

  // Blocs
  sl.registerFactory(() => IssuesBloc(getIssues: sl(), repository: sl()));
  sl.registerFactory(() => IssueFormCubit(repository: sl()));
}

void _initProjectsFeature() {
  // Data Sources
  sl.registerLazySingleton<ProjectsLocalDataSource>(
    () => ProjectsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectTemplatesUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));
  sl.registerLazySingleton(() => ArchiveProjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectMembersUseCase(sl()));
  sl.registerLazySingleton(() => AddProjectMemberUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ProjectsListCubit(
      getProjectsUseCase: sl(),
      archiveProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
      updateProjectUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ProjectCreationCubit(
      getProjectTemplatesUseCase: sl(),
      createProjectUseCase: sl(),
      addProjectMemberUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ProjectDetailsCubit(getProjectByIdUseCase: sl()));
  sl.registerFactory(
    () => ProjectMembersCubit(
      getProjectMembersUseCase: sl(),
      addProjectMemberUseCase: sl(),
    ),
  );
}

void _initCustomFieldsFeature() {
  sl.registerLazySingleton<CustomFieldsRemoteDataSource>(
    () => CustomFieldsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CustomFieldsRepository>(
    () => CustomFieldsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetCustomFieldsUseCase(sl()));
  sl.registerLazySingleton(() => AddCustomFieldUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCustomFieldUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCustomFieldsUseCase(sl()));
  sl.registerLazySingleton(() => ReorderCustomFieldsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFieldVisibilityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFieldAccessControlUseCase(sl()));
  sl.registerLazySingleton(() => ReplaceFieldValueUseCase(sl()));

  sl.registerFactory(
    () => CustomFieldsCubit(
      getFieldsUseCase: sl(),
      addFieldUseCase: sl(),
      updateFieldUseCase: sl(),
      deleteFieldsUseCase: sl(),
      reorderFieldsUseCase: sl(),
      updateVisibilityUseCase: sl(),
      updateAccessControlUseCase: sl(),
      replaceFieldValueUseCase: sl(),
    ),
  );
}

void _initCustomFieldFeature() {
  // Data Sources
  sl.registerLazySingleton<CustomFieldRemoteDataSource>(
    () => CustomFieldRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<CustomFieldRepository>(
    () => CustomFieldRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => ValidateCustomFieldName(sl()));
  sl.registerLazySingleton(() => CreateCustomField(sl()));

  // Cubits
  sl.registerFactory(() => CustomFieldPanelCubit());
  sl.registerFactory(() => TabSelectionCubit());
  sl.registerFactory(
    () => FormStateCubit(validateFieldName: sl(), createCustomField: sl()),
  );
  sl.registerFactory(() => PrivacyStateCubit());
}

void _initVersionControlFeature() {
  sl.registerLazySingleton<VersionControlRemoteDataSource>(
    () => VersionControlRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<VersionControlRepository>(
    () => VersionControlRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetIntegrationsUseCase(sl()));
  sl.registerLazySingleton(() => CreateIntegrationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateIntegrationUseCase(sl()));
  sl.registerLazySingleton(() => DeleteIntegrationUseCase(sl()));
  sl.registerLazySingleton(() => TestConnectionUseCase(sl()));
  sl.registerLazySingleton(() => ManageUserMappingUseCase(sl()));
  sl.registerLazySingleton(() => SyncCommitsUseCase(sl()));

  sl.registerFactory(
    () => VcsIntegrationsCubit(
      getIntegrationsUseCase: sl(),
      createIntegrationUseCase: sl(),
      updateIntegrationUseCase: sl(),
      deleteIntegrationUseCase: sl(),
      testConnectionUseCase: sl(),
      manageUserMappingUseCase: sl(),
      syncCommitsUseCase: sl(),
    ),
  );
}

void _initTimeTrackingFeature() {
  sl.registerLazySingleton<TimeTrackingRemoteDataSource>(
    () => TimeTrackingRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TimeTrackingRepository>(
    () => TimeTrackingRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetTimeTrackingConfig(sl()));
  sl.registerLazySingleton(() => SaveTimeTrackingConfig(sl()));
  sl.registerLazySingleton(() => GetAvailablePeriodFields(sl()));
  sl.registerLazySingleton(() => GetWorkTypes(sl()));
  sl.registerLazySingleton(() => AddWorkType(sl()));
  sl.registerLazySingleton(() => UpdateWorkType(sl()));
  sl.registerLazySingleton(() => DeleteWorkType(sl()));
  sl.registerLazySingleton(() => ReorderWorkTypes(sl()));
  sl.registerLazySingleton(() => GetCustomAttributes(sl()));
  sl.registerLazySingleton(() => AddCustomAttribute(sl()));
  sl.registerLazySingleton(() => UpdateCustomAttribute(sl()));
  sl.registerLazySingleton(() => DeleteCustomAttribute(sl()));

  sl.registerFactory(
    () => TimeTrackingConfigCubit(
      getConfigUseCase: sl(),
      saveConfigUseCase: sl(),
      getAvailablePeriodFieldsUseCase: sl(),
    ),
  );
}

void _initKnowledgeBaseFeature() {
  sl.registerLazySingleton<ArticleRemoteDataSource>(
    () => ArticleRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ArticleLocalDataSource>(
    () => ArticleLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ArticleCommentRemoteDataSource>(
    () => ArticleCommentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ArticleNotificationRemoteDataSource>(
    () => ArticleNotificationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<ArticleCommentRepository>(
    () => ArticleCommentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ArticleNotificationRepository>(
    () => ArticleNotificationRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetArticleTree(sl()));
  sl.registerLazySingleton(() => GetArticleById(sl()));
  sl.registerLazySingleton(() => CreateArticle(sl()));
  sl.registerLazySingleton(() => UpdateArticle(sl()));
  sl.registerLazySingleton(() => PublishArticle(sl()));
  sl.registerLazySingleton(() => DeleteArticle(sl()));
  sl.registerLazySingleton(() => ReorderArticles(sl()));
  sl.registerLazySingleton(() => SearchArticles(sl()));
  sl.registerLazySingleton(() => SaveDraft(sl()));
  sl.registerLazySingleton(() => GetDraft(sl()));
  sl.registerLazySingleton(() => AddComment(sl()));
  sl.registerLazySingleton(() => ResolveComment(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));
  sl.registerLazySingleton(() => GetCommentsForArticle(sl()));
  sl.registerLazySingleton(() => SubscribeToNotifications(sl()));

  sl.registerFactory(
    () => ArticleTreeBloc(
      getArticleTree: sl(),
      deleteArticle: sl(),
      reorderArticles: sl(),
    ),
  );
  sl.registerFactory(
    () => ArticleEditorBloc(
      createArticle: sl(),
      updateArticle: sl(),
      publishArticle: sl(),
      saveDraft: sl(),
      getDraft: sl(),
    ),
  );
  sl.registerFactory(() => ArticleCommentBloc(
        getComments: sl(),
        addComment: sl(),
        resolveComment: sl(),
        deleteComment: sl(),
      ));
  sl.registerFactory(() => ArticleTocCubit());
  sl.registerFactory(() => ArticleSearchCubit(searchArticles: sl()));
  sl.registerFactory(() => ArticleNotificationCubit(
        subscribeToNotifications: sl(),
      ));
}
