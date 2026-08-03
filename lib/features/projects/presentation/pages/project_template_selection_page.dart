import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/enums/project_template_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import '../cubits/project_creation_cubit.dart';

/// صفحة 2: اختيار قالب المشروع
class ProjectTemplateSelectionPage extends StatefulWidget {
  const ProjectTemplateSelectionPage({super.key});

  @override
  State<ProjectTemplateSelectionPage> createState() =>
      _ProjectTemplateSelectionPageState();
}

class _ProjectTemplateSelectionPageState
    extends State<ProjectTemplateSelectionPage> {
  IconData _getIconForKey(String iconKey) {
    switch (iconKey) {
      case 'folder':
        return AppIcons.folder;
      case 'view_week':
        return AppIcons.viewWeek;
      case 'view_kanban':
        return AppIcons.viewKanban;
      case 'check_box':
        return AppIcons.checkBox;
      case 'headset_mic':
        return AppIcons.headsetMic;
      case 'account_tree':
        return AppIcons.accountTree;
      case 'play_circle_outline':
        return AppIcons.playCircle;
      case 'campaign':
        return AppIcons.campaign;
      default:
        return AppIcons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // ProjectsHeader(
          //   breadcrumbs: [
          //     BreadcrumbItem(
          //       title: localization.projectsTitle,
          //       onTap: (ctx) => ctx.go(AppRouteKeys.projects),
          //     ),
          //     BreadcrumbItem(title: localization.selectTemplateTitle),
          //   ],
          // ),
          Expanded(
            child: BlocBuilder<ProjectCreationCubit, ProjectCreationState>(
              builder: (context, state) {
                Widget content;

                if (state.status == ProjectCreationStatus.loading) {
                  content = Center(
                    key: const ValueKey('project-template-loading'),
                    child: SizedBox(width: 480, child: ShimmerLoading.list(itemCount: 6)),
                  );
                } else {
                  content = Padding(
                    key: const ValueKey('project-template-loaded'),
                  padding: AppSpacing.paddingAllMedium,
                  child: Column(
                    spacing: AppSpacing.medium,
                    crossAxisAlignment: .start,
                    children: [
                      const SizedBox(height: AppSpacing.medium),
                      Text(
                        'Create a project with one of these templates or',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Each template defines a preconfigured project with relevant fields, agile boards, and workflows so you can get right to work. All aspects can be fully customized at any time to fit your team's specific needs.",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: .w500,
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSpacing.medium,
                                mainAxisSpacing: AppSpacing.medium,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: ProjectTemplateType.values.length,
                          itemBuilder: (context, index) {
                            final template = ProjectTemplateType.values[index];
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Card(
                                margin: EdgeInsets.zero,
                                // color: colors.surfaceContainerLow,
                                elevation: 0.2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.mediumBorderRadius,
                                  side: BorderSide(
                                    color: colors.outline,
                                    width: 1,
                                  ),
                                ),
                                // borderRadius: AppRadius.mediumBorderRadius,
                                child: InkWell(
                                  borderRadius: AppRadius.mediumBorderRadius,
                                  onTap: () {
                                    context
                                        .read<ProjectCreationCubit>()
                                        .selectTemplate(template);
                                    context.go(
                                      AppRouteKeys.templateDetailsPath(
                                        template.name,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: AppSpacing.paddingAllMedium,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: colors.secondary,
                                            borderRadius:
                                                AppRadius.smallBorderRadius,
                                          ),
                                          child: Icon(
                                            _getIconForKey(template.iconKey),
                                            color: colors.onSecondary,
                                            size: 40,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppSpacing.medium,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                template.name,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(
                                                height: AppSpacing.extraSmall,
                                              ),
                                              Text(
                                                template.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: colors
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => context.go(AppRouteKeys.projects),
                        child: Text(localization.cancelButton),
                      ),
                    ],
                  ),
                  );
                }

                return AnimatedContentSwitcher(child: content);
              },
            ),
          ),
        ],
      ),
    );
  }
}
