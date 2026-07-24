import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:issues_tracking/features/dashboards/data/datasources/dashboard_remote_data_source.dart";
import "package:issues_tracking/features/dashboards/data/repositories/dashboard_repository_impl.dart";
import "package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart";
import "package:issues_tracking/features/dashboards/domain/usecases/get_dashboards.dart";
import "package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart";

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
