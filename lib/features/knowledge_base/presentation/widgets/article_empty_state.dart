import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';

class ArticleEmptyState extends StatelessWidget {
  final String role; // TODO: Can be removed later as role is no longer used for permissions

  const ArticleEmptyState({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final userSession = context.watch<UserSession>();
    final canCreate = userSession.hasPermission(Permission.articleCreateArticle);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No articles available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          if (canCreate) ...[
            Text(
              'Create the first article to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Article'),
            ),
          ] else
            Text(
              'Articles will appear here once created by a team member',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
            ),
        ],
      ),
    );
  }
}
