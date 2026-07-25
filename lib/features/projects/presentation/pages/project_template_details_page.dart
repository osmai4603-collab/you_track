import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_shell_page.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/projects_breadcrumb_header.dart';
import '../cubits/project_creation_cubit.dart';

/// صفحة 3: تفاصيل القالب المختار وحقوله الافتراضية
class ProjectTemplateDetailsPage extends StatelessWidget {
  final String templateId;

  const ProjectTemplateDetailsPage({
    super.key,
    required this.templateId,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProjectCreationCubit, ProjectCreationState>(
      builder: (context, state) {
        final template = state.selectedTemplate;
        if (template == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectsHeader(
              breadcrumbs: [
                BreadcrumbItem(
                  title: localization.projectsTitle,
                  onTap: (ctx) => ctx.go(AppRouteKeys.projects),
                ),
                BreadcrumbItem(
                  title: localization.selectTemplateTitle,
                  onTap: (ctx) => ctx.go(AppRouteKeys.projectTemplates),
                ),
                BreadcrumbItem(title: template.name),
              ],
            ),
            // ── المحتوى ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingAllMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // وصف القالب
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingAllMedium,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: AppRadius.mediumBorderRadius,
                      ),
                      child: Text(
                        template.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    // الحقول الافتراضية
                    Text(
                      'Default Fields',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    ...template.defaultFields.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.extraSmall,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 160,
                              child: Text(
                                entry.key,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.medium),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.small,
                                vertical: AppSpacing.extraSmall,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: AppRadius.extraSmallBorderRadius,
                              ),
                              child: Text(
                                entry.value,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.extraLarge),
                    // أزرار الإجراء
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () => context.go(AppRouteKeys.createProject),
                          child: Text(localization.useThisTemplateButton),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        OutlinedButton(
                          onPressed: () => context.go(AppRouteKeys.projectTemplates),
                          child: Text(localization.cancelButton),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
