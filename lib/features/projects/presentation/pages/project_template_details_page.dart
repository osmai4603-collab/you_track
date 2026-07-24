import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import '../cubits/project_creation_cubit.dart';

/// صفحة 3: تفاصيل القالب المختار وحقوله الافتراضية
class ProjectTemplateDetailsPage extends StatelessWidget {
  final VoidCallback onUseTemplate;
  final VoidCallback onCancel;

  const ProjectTemplateDetailsPage({
    super.key,
    required this.onUseTemplate,
    required this.onCancel,
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
                    onPressed: onCancel,
                    icon: const Icon(AppIcons.arrowBack, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    template.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
                          onPressed: onUseTemplate,
                          child: Text(localization.useThisTemplateButton),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        OutlinedButton(
                          onPressed: onCancel,
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
