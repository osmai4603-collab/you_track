import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
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
  final TextEditingController _startingNumberController = TextEditingController(text: '1');
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoGenerateId = true;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _startingNumberController.dispose();
    _descriptionController.dispose();
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
      description: _descriptionController.text,
      startingNumber: int.tryParse(_startingNumberController.text) ?? 1,
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
            AppRouteKeys.projectDetailsPath(state.createdProject!.id),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: .symmetric(horizontal: AppSpacing.extraLarge, vertical: AppSpacing.large),
          child: SingleChildScrollView(
            child: Column(
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
                Padding(
                  padding:  .symmetric(horizontal: AppSpacing.extraLarge),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: AppSpacing.paddingAllMedium,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Default Project',
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Personalize your project to help other users understand its purpose and scope. You can update these values from the General Info tab in the project settings if needed.'
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                  style: textTheme.bodySmall?.copyWith(fontWeight: .bold, color: colors.onSurface),
                                  onChanged: _onNameChanged,
                                  decoration: InputDecoration(
                                    hintText: localization.projectNameHint,

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
                                const SizedBox(height: AppSpacing.small),
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: _idController,
                                    style: textTheme.bodySmall?.copyWith(fontWeight: .bold, color: colors.onSurface),
                                    onChanged: (value) {
                                      _autoGenerateId = false;
                                      context.read<ProjectCreationCubit>().updateFormInfo(
                                        name: _nameController.text,
                                        key: value,
                                        description: _descriptionController.text,
                                        startingNumber: int.tryParse(_startingNumberController.text) ?? 1,
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: localization.projectIdHint,

                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'ID is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Text(
                                  'Used as a prefix for issue IDs (e.g., TP-1, TP-2)',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
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
                                // ── More Settings ──────────────────────────────
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: Text(
                                    'More Settings',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  children: [

                                    const SizedBox(height: AppSpacing.small),
                                    Align(
                                      alignment: AlignmentDirectional.centerStart,
                                      child: Text(
                                        'Starting number',
                                        style: textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.extraSmall),
                                    Align(
                                      alignment: .centerStart,
                                      child: SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: _startingNumberController,
                                          style: textTheme.bodySmall?.copyWith(fontWeight: .bold, color: colors.onSurface),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            final num = int.tryParse(value) ?? 1;
                                            context.read<ProjectCreationCubit>().updateFormInfo(
                                              name: _nameController.text,
                                              key: _idController.text,
                                              startingNumber: num,
                                            );
                                          },
                                          decoration: const InputDecoration(
                                            hintText: '1',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Starting number is required';
                                            }
                                            if (int.tryParse(value.trim()) == null) {
                                              return 'Must be a number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: .centerStart,
                                      child: Text(
                                        'Used to generate the ID for the first issue in the project',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.large),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Description',
                                        style: textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.small),
                                    TextFormField(
                                      controller: _descriptionController,
                                      style: textTheme.bodySmall?.copyWith(fontWeight: .bold, color: colors.onSurface),
                                      maxLines: 5,
                                      onChanged: (value) {
                                        context.read<ProjectCreationCubit>().updateFormInfo(
                                          name: _nameController.text,
                                          key: _idController.text,
                                          description: value,
                                        );
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Add a description for your project...',
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.small),
                                  ],
                                ),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          state.errorMessage!,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.error,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(AppIcons.copy),
                                        padding: .all(5),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: state.errorMessage!));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
