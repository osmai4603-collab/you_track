import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/services/navigation/app_navigation.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/pages/article_editor_page.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/pages/knowledge_base_page.dart';

final class KnowledgeBaseNavigation extends AppNavigation {
  KnowledgeBaseNavigation() : super(routes: _routes);

  static String? _projectIdOf(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    return extra?['projectId'] as String? ??
        state.uri.queryParameters['projectId'];
  }

  static Widget _withTreeBloc(GoRouterState state, Widget child) {
    final projectId = _projectIdOf(state);
    return BlocProvider(
      create: (context) =>
          get_it<ArticleTreeBloc>()..add(LoadArticleTree(projectId)),
      child: child,
    );
  }

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.knowldgeBase,
      builder: (context, state) {
        return KnowledgeBasePage(projectId: _projectIdOf(state));
      },
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (_, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final parentId = extra?['parentId'] as String?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: _withTreeBloc(
                state,
                ArticleEditorPage(
                  projectId: _projectIdOf(state),
                  parentId: parentId,
                ),
              ),
              transitionsBuilder: AppNavigation.fadeTransition,
            );
          },
        ),
        GoRoute(
          path: ':articleId/edit',
          pageBuilder: (_, state) {
            final articleId = state.pathParameters['articleId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: _withTreeBloc(
                state,
                ArticleEditorPage(
                  projectId: _projectIdOf(state),
                  articleId: articleId,
                ),
              ),
              transitionsBuilder: AppNavigation.fadeTransition,
            );
          },
        ),
      ],
    ),
  ];
}
