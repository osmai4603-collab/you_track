import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:issues_tracking/core/localization/app_localizations.dart';

import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_template_entity.dart';
import 'package:issues_tracking/features/projects/domain/repositories/projects_repository.dart';
import 'package:issues_tracking/features/projects/domain/usecases/add_project_member_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/archive_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/create_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/delete_project_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_project_templates_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';
import 'package:issues_tracking/features/projects/domain/usecases/update_project_use_case.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_creation_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/pages/create_project_form_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_shell_page.dart';

class DummyProjectsRepository implements ProjectsRepository {
  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async =>
      const Right([]);

  @override
  Future<Either<Failure, List<ProjectTemplateEntity>>>
      getProjectTemplates() async => const Right([]);

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById(String id) async =>
      const Left(ServerFailure('not implemented'));

  @override
  Future<Either<Failure, ProjectEntity>> createProject(
          ProjectEntity project) async =>
      const Left(ServerFailure('not implemented'));

  @override
  Future<Either<Failure, ProjectEntity>> updateProject(
          ProjectEntity project) async =>
      const Left(ServerFailure('not implemented'));

  @override
  Future<Either<Failure, Unit>> archiveProject(String id) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Unit>> deleteProject(String id) async =>
      const Right(unit);

  @override
  Future<Either<Failure, List<ProjectMemberEntity>>> getProjectMembers(
          String projectId) async =>
      const Right([]);

  @override
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(
          ProjectMemberEntity member) async =>
      const Left(ServerFailure('not implemented'));
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      anonKey: 'test-anon-key',
    );
  });

  testWidgets(
    'navigating directly to /projects/new renders CreateProjectFormPage',
    (tester) async {
      final repo = DummyProjectsRepository();

      final router = GoRouter(
        initialLocation: AppRouteKeys.createProject,
        routes: [
          GoRoute(
            path: AppRouteKeys.createProject,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ProjectCreationCubit(
                    getProjectTemplatesUseCase:
                        GetProjectTemplatesUseCase(repo),
                    createProjectUseCase: CreateProjectUseCase(repo),
                    addProjectMemberUseCase: AddProjectMemberUseCase(repo),
                  ),
                ),
                BlocProvider(
                  create: (_) => ProjectsListCubit(
                    getProjectsUseCase: GetProjectsUseCase(repo),
                    archiveProjectUseCase: ArchiveProjectUseCase(repo),
                    deleteProjectUseCase: DeleteProjectUseCase(repo),
                    updateProjectUseCase: UpdateProjectUseCase(repo),
                  ),
                ),
              ],
              child: Scaffold(
                body: ProjectsShellPage(
                  child: const CreateProjectFormPage(),
                ),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CreateProjectFormPage), findsOneWidget);
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));

      router.dispose();
    },
  );
}
