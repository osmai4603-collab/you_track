import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_shell_page.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/projects_breadcrumb_header.dart';
import '../cubits/projects_list_cubit.dart';
import '../cubits/project_creation_cubit.dart';

/// صفحة 4: نموذج إدخال اسم ومعرف المشروع الجديد
class CreateProjectFormPage extends StatefulWidget {
  const CreateProjectFormPage({super.key});

  @override
  State<CreateProjectFormPage> createState() => _CreateProjectFormPageState();
}

class _CreateProjectFormPageState extends State<CreateProjectFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoGenerateId = true;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    if (_autoGenerateId && value.isNotEmpty) {
      // توليد معرف تلقائي من الأحرف الأولى
      final words = value.trim().split(RegExp(r'\s+'));
      String key = '';
      if (words.length == 1) {
        key = words[0].substring(0, words[0].length > 3 ? 3 : words[0].length);
      } else {
        key = words.map((w) => w.isNotEmpty ? w[0] : '').join();
      }
      _idController.text = key.toUpperCase();
    }
    context.read<ProjectCreationCubit>().updateFormInfo(
      name: value,
      key: _idController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ProjectCreationCubit, ProjectCreationState>(
      listener: (context, state) {
        if (state.status == ProjectCreationStatus.projectCreated &&
            state.createdProject != null) {
          context.read<ProjectsListCubit>().addProjectLocally(
            state.createdProject!,
          );
          context.go(
            AppRouteKeys.addProjectMembersPath(state.createdProject!.id),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectsHeader(
              breadcrumbs: [
                BreadcrumbItem(
                  title: localization.projectsTitle,
                  onTap: (ctx) => ctx.go(AppRouteKeys.projects),
                ),
                BreadcrumbItem(title: localization.createProject),
              ],
            ),
            // ── نموذج الإدخال ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingAllMedium,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // حقل الاسم
                      Text(
                        localization.projectNameLabel,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      TextFormField(
                        controller: _nameController,
                        onChanged: _onNameChanged,
                        decoration: InputDecoration(
                          hintText: localization.projectNameHint,
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.smallBorderRadius,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.large),
                      // حقل المعرف
                      Text(
                        localization.projectIdLabel,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      Text(
                        'Used as a prefix for issue IDs (e.g., TP-1, TP-2)',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _idController,
                          onChanged: (value) {
                            _autoGenerateId = false;
                            context.read<ProjectCreationCubit>().updateFormInfo(
                              name: _nameController.text,
                              key: value,
                            );
                          },
                          decoration: InputDecoration(
                            hintText: localization.projectIdHint,
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.smallBorderRadius,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'ID is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      // معاينة المعرفات
                      if (_idController.text.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.medium),
                        Wrap(
                          spacing: AppSpacing.small,
                          children: List.generate(3, (i) {
                            return Chip(
                              label: Text(
                                '${_idController.text.toUpperCase()}-${i + 1}',
                                style: textTheme.labelSmall,
                              ),
                              backgroundColor: colors.surfaceContainerHighest,
                            );
                          }),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.extraLarge),
                      // أزرار الإجراء
                      Row(
                        children: [
                          FilledButton(
                            onPressed:
                                state.status == ProjectCreationStatus.loading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<ProjectCreationCubit>()
                                          .submitCreateProject();
                                    }
                                  },
                            child: state.status == ProjectCreationStatus.loading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(localization.createProjectButton),
                          ),
                          const SizedBox(width: AppSpacing.small),
                          OutlinedButton(
                            onPressed: () =>
                                context.go(AppRouteKeys.projectTemplates),
                            child: Text(localization.cancelButton),
                          ),
                        ],
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          state.errorMessage!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
