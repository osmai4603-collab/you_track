import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
import 'package:issues_tracking/core/widgets/project_chip.dart';
import 'package:issues_tracking/core/widgets/text_hover_widget.dart';
import 'package:issues_tracking/core/widgets/youtrack_state.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import '../cubits/projects_list_cubit.dart';
import '../cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';

final List<Color> _projectColors = const [
  Color(0xFF4285F4), // Blue
  Color(0xFFE91E63), // Pink
  Color(0xFF9C27B0), // Purple
  Color(0xFF009688), // Teal
  Color(0xFFFF9800), // Orange
  Color(0xFF673AB7), // Deep Purple
];

class ProjectsListPage extends StatefulWidget {
  const ProjectsListPage({super.key});

  @override
  State<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends YouTrackState<ProjectsListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProjectsListCubit>().loadProjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsListCubit, ProjectsListState>(
      builder: (context, state) {
        if (state.status == ProjectsListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProjectsListStatus.failure) {
          return Center(
            child: SelectableText(
              state.errorMessage ?? '',
              style: textTheme.bodyMedium?.copyWith(color: colors.error),
            ),
          );
        }

        final projects = state.filteredProjects;
        if (projects.isEmpty) {
          return Center(
            child: Text(
              localization.noProjectsFound,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          );
        }

        return Align(
          child: SizedBox(
            width: 800,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.extraSmall,
              ),
              itemCount: projects.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: colors.outlineVariant.withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                return ProjectListTile(projectEntity: projects[index]);
              },
            ),
          ),
        );
      },
    );
  }
}

class ProjectListTile extends StatefulWidget {
  final ProjectEntity projectEntity;
  const ProjectListTile({super.key, required this.projectEntity});

  @override
  State<ProjectListTile> createState() => _ProjectListTileState();
}

class _ProjectListTileState extends YouTrackState<ProjectListTile> {
  late ProjectEntity project;
  bool isStarred = false;

  @override
  void initState() {
    super.initState();
    project = widget.projectEntity;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: _onTapProject,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          child: Row(
            children: [
              // المفضلة
              IconButton(
                icon: Icon(
                  project.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: project.isFavorite
                      ? Colors.amber
                      : colors.onSurfaceVariant.withValues(alpha: 0.5),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {
                  context.read<ProjectsListCubit>().toggleFavorite(project);
                },
              ),
              const SizedBox(width: AppSpacing.small),
              // أيقونة المشروع
              ProjectChip(
                colors: colors,
                textTheme: textTheme,
                shortKey: project.projectKey,
                textColor:
                    _projectColors[Random(0).nextInt(_projectColors.length)],
              ),

              const SizedBox(width: AppSpacing.small),
              // اسم المشروع والمعرف
              Expanded(
                child: TextHoverWidget(
                  text: project.name,
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  styleHover: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.secondary,
                  ),
                ),
              ),
              // الأعضاء
              if (project.members.isNotEmpty)
                _buildMembersAvatars(project.members, textTheme, colors),
              const SizedBox(width: AppSpacing.small),
              // القائمة المنسدلة للإجراءات
              _buildProjectMenu(project, localization, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersAvatars(
    List<ProjectMemberEntity> initials,
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    const double avatarSize = 40.0;

    return SizedBox(
      height: avatarSize,

      child: Row(
        spacing: 8,
        children: [
          ...List.generate(initials.length <= 3 ? initials.length : 3, (index) {
            final member = initials[index];
            return Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _projectColors[initials.length % _projectColors.length],
                border: Border.all(color: colors.surface, width: 2),
              ),

              child: Center(
                child: Text(
                  member.name,
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
          if (initials.length > 3)
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _projectColors[(initials.length + 1) %
                        _projectColors.length],
                border: Border.all(color: colors.surface, width: 2),
              ),
              child: Center(
                child: Text(
                  '+ ${initials.length - 3}',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildProjectMenu(
    ProjectEntity project,
    AppLocalizations localization,
    ColorScheme colors,
  ) {
    final style = Theme.of(context).textTheme.labelSmall;

    return PopupMenuButton<String>(
      color: colors.surfaceContainerLow,
      constraints: const BoxConstraints(maxWidth: 250),
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: const Icon(AppIcons.moreVert),
      ),
      onSelected: (action) => _handleAction(action, project.id),
      itemBuilder: (context) => [
        AppPopupMenuItem(
          value: 'overview',
          child: Text(localization.overview, style: style),
        ),
        AppPopupMenuItem(
          value: 'issues',
          child: Text(localization.issues, style: style),
        ),
        AppPopupMenuItem(
          value: 'agile-boards',
          child: Text(localization.agileBoardsTitle, style: style),
        ),
        AppPopupMenuItem(
          value: 'ganttCharts',
          child: Text(localization.ganttCharts, style: style),
        ),
        AppPopupMenuItem(
          value: 'knowledge-base',
          child: Text(localization.knowledgeBase, style: style),
        ),
        AppPopupMenuItem(
          value: 'settings',
          child: Text(localization.settings, style: style),
        ),
        const PopupMenuDivider(),
        AppPopupMenuItem(
          enabled: false,
          child: Text(
            localization.projectActionsHeader,
            style: style?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppPopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(AppIcons.edit),
              const SizedBox(width: AppSpacing.small),
              Text(localization.editProjectButton, style: style),
            ],
          ),
        ),
        AppPopupMenuItem(
          value: 'clone',
          child: Row(
            children: [
              const Icon(AppIcons.copy, size: 16),
              const SizedBox(width: AppSpacing.small),
              Text(localization.cloneProjectButton, style: style),
            ],
          ),
        ),
        AppPopupMenuItem(
          value: 'archive',
          child: Row(
            children: [
              const Icon(AppIcons.archive, size: 16),
              const SizedBox(width: AppSpacing.small),
              Text(localization.archiveProjectButton, style: style),
            ],
          ),
        ),
        AppPopupMenuItem(
          value: 'convertToTemplate',
          child: Row(
            children: [
              const Icon(AppIcons.template, size: 16),
              const SizedBox(width: AppSpacing.small),
              Text(localization.convertToTemplateButton, style: style),
            ],
          ),
        ),
        const PopupMenuDivider(),
        AppPopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(AppIcons.delete, size: 16, color: colors.error),
              const SizedBox(width: AppSpacing.small),
              Text(
                localization.deleteProjectButton,
                style: style?.copyWith(color: colors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(String action, String projectId) {
    final cubit = context.read<ProjectsListCubit>();
    switch (action) {
      case 'overview':
        context.go(AppRouteKeys.projectDetailsPath(projectId));
        break;
      case 'issues':
        context.go(AppRouteKeys.projectIssuesPath(projectId));
        break;
      case 'agile-boards':
        context.go(AppRouteKeys.projectAgileBoardsPath(projectId));
        break;
      case 'knowledge-base':
        context.go(AppRouteKeys.projectKnowledgeBasePath(projectId));
        break;
      case 'settings':
        context.go(AppRouteKeys.projectSettingsPath(projectId));
        break;
      case 'archive':
        cubit.archiveProject(projectId);
        break;
      case 'delete':
        cubit.deleteProject(projectId);
        break;
      // edit, clone, convertToTemplate يمكن إضافتها لاحقاً
    }
  }

  void _onTapProject() {
    context.read<ProjectDetailsCubit>().loadProject(project.id);
    context.go(AppRouteKeys.projectDetailsPath(project.id));
  }
}
