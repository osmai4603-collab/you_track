import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:issues_tracking/features/dashboards/data/datasources/dashboard_remote_data_source.dart";
import "package:issues_tracking/features/dashboards/data/repositories/dashboard_repository_impl.dart";
import "package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart";
import "package:issues_tracking/features/dashboards/domain/usecases/get_dashboards.dart";
import "package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart";
import "package:issues_tracking/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart";

import 'package:issues_tracking/features/issues/data/datasources/issues_mock_data_source.dart';
import 'package:issues_tracking/features/issues/data/repositories/issues_repository_impl.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issue_by_id.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';

import 'package:issues_tracking/features/app/data/datasources/app_settings_local_data_source.dart';
import 'package:issues_tracking/features/app/data/repositories/app_settings_repository_impl.dart';
import 'package:issues_tracking/features/app/domain/repositories/app_settings_repository.dart';
import 'package:issues_tracking/features/app/domain/usecases/get_app_settings.dart';
import 'package:issues_tracking/features/app/domain/usecases/save_app_settings.dart';
import 'package:issues_tracking/features/app/presentation/cubit/app_cubit.dart';

import 'package:issues_tracking/features/projects/data/datasources/projects_local_data_source.dart';
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

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Supabase.instance.client);

  // 2. App Feature Initialization
  _initAppFeature();
  _initDashboardsFeature();
  _initIssuesFeature();
  _initProjectsFeature();
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
  sl.registerFactory(() => AppCubit(
    getAppSettings: sl(),
    saveAppSettings: sl(),
  ));
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
  sl.registerFactory(() => DashboardBloc(
    getDashboards: sl(),
    repository: sl(),
  ));

  sl.registerFactory(() => YouTrackShellCubit());
}

void _initIssuesFeature() {
  // Data Sources
  sl.registerLazySingleton<IssuesMockDataSource>(
    () => IssuesMockDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<IssuesRepository>(
    () => IssuesRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetIssues(sl()));
  sl.registerLazySingleton(() => GetIssueById(sl()));

  // Blocs
  sl.registerFactory(() => IssuesBloc(
    getIssues: sl(),
    repository: sl(),
  ));
}

void _initProjectsFeature() {
  // Data Sources
  sl.registerLazySingleton<ProjectsLocalDataSource>(
    () => ProjectsLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(localDataSource: sl()),
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
  sl.registerFactory(() => ProjectsListCubit(
    getProjectsUseCase: sl(),
    archiveProjectUseCase: sl(),
    deleteProjectUseCase: sl(),
    updateProjectUseCase: sl(),
  ));
  sl.registerFactory(() => ProjectCreationCubit(
    getProjectTemplatesUseCase: sl(),
    createProjectUseCase: sl(),
    addProjectMemberUseCase: sl(),
  ));
  sl.registerFactory(() => ProjectDetailsCubit(
    getProjectByIdUseCase: sl(),
  ));
  sl.registerFactory(() => ProjectMembersCubit(
    getProjectMembersUseCase: sl(),
    addProjectMemberUseCase: sl(),
  ));
}

