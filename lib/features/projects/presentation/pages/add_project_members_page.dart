import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_shell_page.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/projects_breadcrumb_header.dart';
import '../cubits/project_creation_cubit.dart';
import '../cubits/project_details_cubit.dart';

/// صفحة 5: إضافة أعضاء الفريق بعد إنشاء المشروع
class AddProjectMembersPage extends StatefulWidget {
  final String projectId;

  const AddProjectMembersPage({
    super.key,
    required this.projectId,
  });

  @override
  State<AddProjectMembersPage> createState() => _AddProjectMembersPageState();
}

class _AddProjectMembersPageState extends State<AddProjectMembersPage> {
  final TextEditingController _memberController = TextEditingController();

  @override
  void dispose() {
    _memberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProjectCreationCubit, ProjectCreationState>(
      builder: (context, state) {
        final project = state.createdProject;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectsHeader(
              breadcrumbs: [
                BreadcrumbItem(title: localization.projectsTitle),
                BreadcrumbItem(title: localization.addPeopleTitle),
              ],
            ),
            // ── المحتوى ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingAllMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You can add existing users or invite new ones by email address.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    // حقل إضافة الأعضاء
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _memberController,
                            decoration: InputDecoration(
                              hintText: localization.selectUsersHint,
                              prefixIcon: const Icon(
                                AppIcons.personAdd,
                                size: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.smallBorderRadius,
                              ),
                            ),
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                context
                                    .read<ProjectCreationCubit>()
                                    .addPendingMember(value.trim());
                                _memberController.clear();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        FilledButton(
                          onPressed: () {
                            final value = _memberController.text.trim();
                            if (value.isNotEmpty) {
                              context
                                  .read<ProjectCreationCubit>()
                                  .addPendingMember(value);
                              _memberController.clear();
                            }
                          },
                          child: const Icon(AppIcons.add, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    // عرض الأعضاء المضافين
                    if (state.pendingMembers.isNotEmpty) ...[
                      Wrap(
                        spacing: AppSpacing.small,
                        runSpacing: AppSpacing.small,
                        children: state.pendingMembers.map((member) {
                          return Chip(
                            avatar: CircleAvatar(
                              backgroundColor: colors.primaryContainer,
                              child: Text(
                                member.name.isNotEmpty
                                    ? member.name[0].toUpperCase()
                                    : '?',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),
                            label: Text(member.email),
                            deleteIcon: const Icon(AppIcons.close, size: 14),
                            onDeleted: () {
                              // يمكن إضافة منطق الحذف هنا
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                    ],
                    // معلومات الترخيص
                    Container(
                      padding: AppSpacing.paddingAllSmall,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: AppRadius.smallBorderRadius,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            AppIcons.people,
                            size: 16,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Text(
                            localization.userLicensesLabel,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    // معلومات المشروع
                    if (project != null) ...[
                      Text(
                        localization.ownedByLabel(project.owner),
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      Text(
                        localization.createdOnLabel(
                          '${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}',
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.extraLarge),
                    // أزرار التنقل
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => context.go(AppRouteKeys.createProject),
                          child: Text(localization.backButton),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        FilledButton(
                          onPressed: () {
                            context.read<ProjectDetailsCubit>().loadProject(widget.projectId);
                            context.go(AppRouteKeys.projectDetailsPath(widget.projectId));
                          },
                          child: Text(localization.nextButton),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context.read<ProjectDetailsCubit>().loadProject(widget.projectId);
                            context.go(AppRouteKeys.projectDetailsPath(widget.projectId));
                          },
                          child: Text(localization.skipSetupButton),
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
