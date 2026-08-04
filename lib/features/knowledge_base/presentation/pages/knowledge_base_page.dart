import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_state.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_notification_cubit.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_search_cubit.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_toc_cubit.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_tree_sidebar.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_content_viewer.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_toc_panel.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_skeleton_loader.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_empty_state.dart';

class KnowledgeBasePage extends StatelessWidget {
  final String? projectId;
  final String role;

  const KnowledgeBasePage({
    super.key,
    required this.projectId,
    this.role = 'visitor',
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              get_it<ArticleTreeBloc>()..add(LoadArticleTree(projectId)),
        ),
        BlocProvider(create: (_) => get_it<ArticleTocCubit>()),
        BlocProvider(
          create: (_) =>
              get_it<ArticleNotificationCubit>()..subscribe('current-user-id'),
        ),
        BlocProvider(create: (_) => get_it<ArticleSearchCubit>()),
      ],
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 280,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: const ArticleTreeSidebar(),
              ),
            ),
            Expanded(
              child: BlocBuilder<ArticleTreeBloc, ArticleTreeState>(
                builder: (context, state) {
                  if (state is ArticleTreeLoading) {
                    return const ArticleSkeletonLoader();
                  }
                  if (state is ArticleTreeError) {
                    return Center(child: SelectableText(state.message));
                  }
                  if (state is ArticleTreeLoaded) {
                    if (state.selectedArticleId == null) {
                      return ArticleEmptyState(
                        role: role,
                        projectId: projectId,
                      );
                    }
                    final selected = state.articles.firstWhere(
                      (a) => a.id == state.selectedArticleId,
                    );
                    return ArticleContentViewer(
                      content: selected.contentMarkdown,
                    );
                  }
                  return const ArticleSkeletonLoader();
                },
              ),
            ),
            const ArticleTocPanel(),
          ],
        ),
      ),
    );
  }
}
