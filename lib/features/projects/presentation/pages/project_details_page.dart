import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import '../cubits/project_details_cubit.dart';

/// صفحة 6: عرض تفاصيل المشروع مع التبويبات الداخلية والشريط الجانبي
class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectDetailsCubit>().loadProject(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tabs = [
      'Issues',
      'Agile Boards',
      'Gantt Charts',
      'Knowledge Base',
      'Settings',
    ];
    final tabIcons = [
      AppIcons.issues,
      AppIcons.board,
      AppIcons.ganttChart,
      AppIcons.knowledgeBase,
      AppIcons.settings,
    ];

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, state) {
        Widget content;

        if (state.status == ProjectDetailsStatus.loading) {
          content = Center(
            key: const ValueKey('project-details-loading'),
            child: SizedBox(
              width: 480,
              child: ShimmerLoading.list(itemCount: 6),
            ),
          );
        } else if (state.status == ProjectDetailsStatus.failure) {
          content = Center(
            key: const ValueKey('project-details-error'),
            child: SelectableText(
              state.errorMessage ?? 'Error',
              style: textTheme.bodyMedium?.copyWith(color: colors.error),
            ),
          );
        } else {
          final project = state.project;
          if (project == null) {
            content = Center(
              key: const ValueKey('project-details-loading'),
              child: SizedBox(
                width: 480,
                child: ShimmerLoading.list(itemCount: 6),
              ),
            );
          } else {
            content = Column(
              key: const ValueKey('project-details-loaded'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: colors.outlineVariant, width: 0.5),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = state.activeTabIndex == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.extraSmall,
                          ),
                          child: InkWell(
                            onTap: () {
                              context.read<ProjectDetailsCubit>().changeTab(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.small,
                                vertical: AppSpacing.small,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? colors.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    tabIcons[index],
                                    size: 14,
                                    color: isSelected
                                        ? colors.primary
                                        : colors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: AppSpacing.extraSmall),
                                  Text(
                                    tabs[index],
                                    style: textTheme.labelSmall?.copyWith(
                                      color: isSelected
                                          ? colors.primary
                                          : colors.onSurfaceVariant,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                Expanded(
                  child: _buildTabContent(
                    context,
                    state,
                    colors,
                    textTheme,
                    localization,
                  ),
                ),
              ],
            );
          }
        }

        return AnimatedContentSwitcher(child: content);
      },
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    ProjectDetailsState state,
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
  ) {
    switch (state.activeTabIndex) {
      case 0:
        return _buildIssuesTab(context, state, colors, textTheme, localization);
      case 1:
        return _buildAgileBoardsTab(context, colors, textTheme, localization);
      default:
        return Center(
          child: Text(
            'Coming soon...',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        );
    }
  }

  Widget _buildIssuesTab(
    BuildContext context,
    ProjectDetailsState state,
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: TextField(
            onChanged: (value) {
              context.read<ProjectDetailsCubit>().searchIssues(value);
            },
            decoration: InputDecoration(
              hintText: 'Search for text or add a filter',
              prefixIcon: const Icon(AppIcons.search, size: 16),
              border: OutlineInputBorder(
                borderRadius: AppRadius.smallBorderRadius,
              ),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AppIcons.issues, size: 48, color: colors.outlineVariant),
                const SizedBox(height: AppSpacing.medium),
                Text(
                  localization.noIssuesFoundBody,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                TextButton(
                  onPressed: () {},
                  child: Text(localization.editSearchQueryButton),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgileBoardsTab(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
  ) {
    final boardTypes = [
      (localization.scrumBoardTitle, AppIcons.viewWeek),
      (localization.kanbanBoardTitle, AppIcons.viewKanban),
      (localization.versionBasedBoardTitle, AppIcons.accountTree),
      (localization.customBoardTitle, AppIcons.board),
      (localization.personalBoardTitle, AppIcons.people),
    ];

    return Padding(
      padding: AppSpacing.paddingAllMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.agileBoardsTitle,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.medium),
          ...boardTypes.map((board) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: Material(
                color: colors.surfaceContainerLow,
                borderRadius: AppRadius.smallBorderRadius,
                child: InkWell(
                  borderRadius: AppRadius.smallBorderRadius,
                  onTap: () {},
                  child: Padding(
                    padding: AppSpacing.paddingAllSmall,
                    child: Row(
                      children: [
                        Icon(board.$2, size: 20, color: colors.primary),
                        const SizedBox(width: AppSpacing.medium),
                        Text(board.$1, style: textTheme.bodyMedium),
                        const Spacer(),
                        Icon(
                          AppIcons.arrowForward,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
