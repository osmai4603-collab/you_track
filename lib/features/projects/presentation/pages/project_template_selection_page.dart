import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import '../../domain/entities/project_template_entity.dart';
import '../cubits/project_creation_cubit.dart';

/// صفحة 2: اختيار قالب المشروع
class ProjectTemplateSelectionPage extends StatefulWidget {
  final void Function(ProjectTemplateEntity template) onTemplateTap;
  final VoidCallback onBack;

  const ProjectTemplateSelectionPage({
    super.key,
    required this.onTemplateTap,
    required this.onBack,
  });

  @override
  State<ProjectTemplateSelectionPage> createState() =>
      _ProjectTemplateSelectionPageState();
}

class _ProjectTemplateSelectionPageState
    extends State<ProjectTemplateSelectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectCreationCubit>().loadTemplates();
  }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colors.outlineVariant, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(AppIcons.arrowBack, size: 18),
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                '${localization.projectsTitle} / ${localization.selectTemplateTitle}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // ── قائمة القوالب ──────────────────────────────
        Expanded(
          child: BlocBuilder<ProjectCreationCubit, ProjectCreationState>(
            builder: (context, state) {
              if (state.status == ProjectCreationStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.templates.isEmpty) {
                return const Center(child: Text('No templates available'));
              }

              return Padding(
                padding: AppSpacing.paddingAllMedium,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.medium,
                    mainAxisSpacing: AppSpacing.medium,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: state.templates.length,
                  itemBuilder: (context, index) {
                    final template = state.templates[index];
                    return Material(
                      color: colors.surfaceContainerLow,
                      borderRadius: AppRadius.mediumBorderRadius,
                      child: InkWell(
                        borderRadius: AppRadius.mediumBorderRadius,
                        onTap: () => widget.onTemplateTap(template),
                        child: Padding(
                          padding: AppSpacing.paddingAllMedium,
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: colors.primaryContainer,
                                  borderRadius: AppRadius.smallBorderRadius,
                                ),
                                child: Icon(
                                  _getIconForKey(template.iconKey),
                                  color: colors.onPrimaryContainer,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.medium),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      template.name,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSpacing.extraSmall,
                                    ),
                                    Text(
                                      template.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
