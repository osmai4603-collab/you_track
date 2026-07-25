import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
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

class _ProjectsListPageState extends State<ProjectsListPage> {
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
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // ProjectsHeader(
        //   breadcrumbs: [BreadcrumbItem(title: localization.projectsTitle)],
        //   trailing: Row(
        //     spacing: AppSpacing.small,
        //     children: [
        //       SizedBox(
        //         width: 300,
        //         height: 32,
        //         child: TextField(
        //           controller: _searchController,
        //           onChanged: (value) {
        //             context.read<ProjectsListCubit>().searchProjects(value);
        //           },
        //           decoration: InputDecoration(
        //             hintText: localization.filterProjectsHint,
        //             prefixIcon: const Icon(AppIcons.search, size: 16),
        //             contentPadding: const EdgeInsets.symmetric(
        //               horizontal: AppSpacing.small,
        //             ),
        //             border: OutlineInputBorder(
        //               borderRadius: AppRadius.smallBorderRadius,
        //               borderSide: BorderSide(color: colors.outlineVariant),
        //             ),
        //           ),
        //         ),
        //       ),
        //       FilledButton(
        //         onPressed: () => context.go(AppRouteKeys.projectTemplates),
        //         child: Text(localization.createProject),
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: BlocBuilder<ProjectsListCubit, ProjectsListState>(
            builder: (context, state) {
              if (state.status == ProjectsListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == ProjectsListStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? '',
                    style: textTheme.bodyMedium?.copyWith(color: colors.error),
                  ),
                );
              }

              final projects = state.filteredProjects;
              if (projects.isEmpty) {
                return Center(
                  child: Text(
                    localization.noIssuesFoundBody,
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
                      final project = projects[index];
                      return Material(
                        color: colors.surface,
                        child: InkWell(
                          onTap: () {
                            context.read<ProjectDetailsCubit>().loadProject(
                              project.id,
                            );
                            context.go(
                              AppRouteKeys.projectDetailsPath(project.id),
                            );
                          },
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
                                        : colors.onSurfaceVariant.withValues(
                                            alpha: 0.5,
                                          ),
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<ProjectsListCubit>()
                                        .toggleFavorite(project);
                                  },
                                ),
                                const SizedBox(width: AppSpacing.small),
                                // أيقونة المشروع
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        _projectColors[project.id.hashCode
                                                .abs() %
                                            _projectColors.length],
                                    borderRadius: AppRadius.smallBorderRadius,
                                  ),
                                  child: Center(
                                    child: Text(
                                      project.name.isNotEmpty
                                          ? project.name
                                                .substring(
                                                  0,
                                                  project.name.length > 2
                                                      ? 2
                                                      : project.name.length,
                                                )
                                                .toUpperCase()
                                          : '',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.small),
                                // اسم المشروع والمعرف
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.name,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        project.projectKey,
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // الأعضاء
                                if (project.memberInitials.isNotEmpty)
                                  _buildMembersAvatars(
                                    project.memberInitials,
                                    textTheme,
                                    colors,
                                  ),
                                const SizedBox(width: AppSpacing.small),
                                // القائمة المنسدلة للإجراءات
                                _buildProjectMenu(
                                  project,
                                  localization,
                                  colors,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembersAvatars(
    List<String> initials,
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    const double avatarSize = 24.0;
    const double overlap = 8.0;
    final displayCount = initials.length > 3 ? 3 : initials.length;
    final extraCount = initials.length > 3 ? initials.length - 3 : 0;

    return SizedBox(
      height: avatarSize,
      width:
          (avatarSize * displayCount) -
          (overlap * (displayCount - 1)) +
          (extraCount > 0 ? avatarSize - overlap : 0),
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _projectColors[(initials[i].hashCode).abs() %
                          _projectColors.length],
                  border: Border.all(color: colors.surface, width: 2),
                ),
                child: Center(
                  child: Text(
                    initials[i],
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          if (extraCount > 0)
            Positioned(
              left: displayCount * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfaceContainerHighest,
                  border: Border.all(color: colors.surface, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$extraCount',
                    style: textTheme.labelSmall?.copyWith(fontSize: 10),
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
      borderRadius: .circular(8.0),
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
          value: 'agileBoards',
          child: Text(localization.agileBoardsTitle, style: style),
        ),
        AppPopupMenuItem(
          value: 'ganttCharts',
          child: Text(localization.ganttCharts, style: style),
        ),
        AppPopupMenuItem(
          value: 'knowledgeBase',
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
      case 'archive':
        cubit.archiveProject(projectId);
        break;
      case 'delete':
        cubit.deleteProject(projectId);
        break;
      // edit, clone, convertToTemplate يمكن إضافتها لاحقاً
    }
  }
}
