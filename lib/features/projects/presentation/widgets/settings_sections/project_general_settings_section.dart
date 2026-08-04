import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/multi_group_selection_dialog.dart';
import 'package:issues_tracking/features/projects/domain/usecases/update_project_use_case.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';

import '../project_icon.dart';

class ProjectGeneralSettingsSection extends StatefulWidget {
  const ProjectGeneralSettingsSection({super.key});

  @override
  State<ProjectGeneralSettingsSection> createState() =>
      _ProjectGeneralSettingsSectionState();
}

class _ProjectGeneralSettingsSectionState
    extends State<ProjectGeneralSettingsSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _idController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadMembers();
    _loadGroups();
  }

  void _loadMembers() {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<ProjectMembersCubit>().loadMembers(projectId);
    }
  }

  void _loadGroups() {
    context.read<GroupsBloc>().add(const LoadGroups());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _defaultVisibility;
  List<String> _recommendedVisibility = [];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ProjectDetailsCubit, ProjectDetailsState>(
      listener: (context, state) {
        if (state.status == ProjectDetailsStatus.success &&
            state.project != null) {
          _nameController.text = state.project!.name;
          _idController.text = state.project!.projectKey;
          _descriptionController.text = state.project!.description ?? '';
          _defaultVisibility = state.project!.visibility;
          _recommendedVisibility = [...state.project!.recommendedVisibility];
        }
      },
      builder: (context, state) {
        Widget content;
        if (state.status == ProjectDetailsStatus.loading) {
          content = Center(
            key: const ValueKey('project-general-loading'),
            child: ShimmerLoading.list(itemCount: 10),
          );
        } else {
          content = Stack(
            key: const ValueKey('project-general-loaded'),
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoBanner(colors, textTheme),
                    const SizedBox(height: AppSpacing.extraLarge),
                    _buildProjectNameField(colors, textTheme, state),
                    const SizedBox(height: AppSpacing.large),
                    _buildProjectIdField(colors, textTheme),
                    const SizedBox(height: AppSpacing.large),
                    _buildDescriptionField(colors, textTheme),
                    const SizedBox(height: AppSpacing.extraLarge),
                    _buildVisibilitySection(colors, textTheme),
                    const SizedBox(height: AppSpacing.extraLarge),
                    _buildActionButtons(colors, textTheme),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton(
                  onPressed: _onSave,
                  backgroundColor: colors.primary,
                  child: const Icon(AppIcons.check, color: Colors.white),
                ),
              ),
            ],
          );
        }

        return AnimatedContentSwitcher(child: content);
      },
    );
  }

  Future<void> _onSave() async {
    final project = context.read<ProjectDetailsCubit>().state.project;
    if (project == null) return;

    final description = _descriptionController.text.trim();
    final updated = project.copyWith(
      name: _nameController.text.trim(),
      description: description.trim().isEmpty ? null : description,
      visibility: _defaultVisibility,
      recommendedVisibility: _recommendedVisibility,
    );

    final result = await get_it<UpdateProjectUseCase>()(
      params: UpdateProjectParams(project: updated),
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText('Failed to save: ${failure.message}'),
          ),
        );
      },
      (saved) {
        context.read<ProjectDetailsCubit>().loadProject(saved.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: SelectableText('Project settings saved')),
        );
      },
    );
  }

  void _onCancel() {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<ProjectDetailsCubit>().loadProject(projectId);
    }
  }

  Widget _buildInfoBanner(ColorScheme colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF), // Custom YouTrack-like blue
        borderRadius: AppRadius.smallBorderRadius,
        border: Border.all(color: const Color(0xFFDDE3F5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF444444),
                ),
                children: [
                  const TextSpan(
                    text:
                        'These settings let you add or change information stored when the project was created. Visibility settings determine which people who have access to the project can view specific items. ',
                  ),
                  TextSpan(
                    text: 'Learn more →',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(AppIcons.close, size: 18),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectNameField(
    ColorScheme colors,
    TextTheme textTheme,
    ProjectDetailsState state,
  ) {
    return Row(
      children: [
        ProjectIcon(projectCode: state.project?.projectKey ?? ''),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                'Project name',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter project name',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectIdField(ColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project ID',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.extraSmall),
            Icon(Icons.info_outline, size: 16, color: colors.onSurfaceVariant),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        SizedBox(
          width: 150,
          child: TextField(
            controller: _idController,
            readOnly: true, // IDs are usually immutable after creation
            decoration: const InputDecoration(
              hintText: 'Enter project ID',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: 10,
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.small),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.outlineVariant),
            borderRadius: AppRadius.smallBorderRadius,
          ),
          child: Column(
            children: [
              // Toolbar placeholder
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  border: Border(
                    bottom: BorderSide(color: colors.outlineVariant),
                  ),
                ),
                child: Row(
                  spacing: AppSpacing.small,
                  children: [
                    Text('Normal text', style: textTheme.labelMedium),
                    const Icon(Icons.arrow_drop_down, size: 18),
                    const SizedBox(width: AppSpacing.small),
                    const Icon(Icons.format_bold, size: 18),
                    const Icon(Icons.format_italic, size: 18),
                    const Icon(Icons.format_strikethrough, size: 18),
                    const Icon(Icons.format_quote, size: 18),
                    const Icon(Icons.code, size: 18),
                    const Icon(Icons.link, size: 18),
                    const Icon(Icons.format_list_bulleted, size: 18),
                    const Icon(Icons.format_list_numbered, size: 18),
                    const Icon(Icons.table_chart_outlined, size: 18),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        border: Border.all(color: colors.outlineVariant),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Visual', style: textTheme.labelSmall),
                    ),
                    Text(
                      'Markdown',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    const Icon(Icons.text_fields, size: 18),
                    const Icon(Icons.help_outline, size: 18),
                  ],
                ),
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      'Provide a description that explains what this project is meant to organize or accomplish (optional)',
                  hintStyle: TextStyle(fontSize: 13),
                  contentPadding: EdgeInsets.all(AppSpacing.medium),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? hint,
    required String? helperText,
    required String? value,
    required Map<String, String> itemLabels,
    required ValueChanged<String?> onChanged,
    required ColorScheme colors,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.small),
        SizedBox(
          width: 300,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            hint: hint == null ? null : Text(hint),
            decoration: const InputDecoration(
              isDense: true,

              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: 10,
              ),
              border: OutlineInputBorder(),
            ),
            items: itemLabels.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilitySection(ColorScheme colors, TextTheme textTheme) {
    final groupsState = context.watch<GroupsBloc>().state;
    final groups = groupsState is GroupsLoaded
        ? groupsState.groups
        : <GroupEntity>[];

    final defaultVisibilityItems = <String, String>{
      for (final group in groups) group.id: group.name,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visibility',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.large),
        _buildDropdownField(
          hint: 'None',

          label: 'Default visibility',
          helperText:
              'Determines who can see issues in this project by default.',
          value: _defaultVisibility,
          itemLabels: defaultVisibilityItems,
          colors: colors,
          textTheme: textTheme,
          onChanged: (value) {
            if (value != null) {
              setState(() => _defaultVisibility = value);
            }
          },
        ),
        const SizedBox(height: AppSpacing.large),
        _buildRecommendedVisibilityField(colors, textTheme, groups),
      ],
    );
  }

  Widget _buildRecommendedVisibilityField(
    ColorScheme colors,
    TextTheme textTheme,
    List<GroupEntity> groups,
  ) {
    final selectedNames = _recommendedVisibility
        .map((id) => _groupNameById(id, groups))
        .where((name) => name != null)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended visibility options',
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          'Select the groups that should be suggested as visibility options when creating issues.',
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.small),
        SizedBox(
          width: 300,
          child: OutlinedButton(
            onPressed: () => _showRecommendedVisibilityDialog(groups),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.smallBorderRadius,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedNames.isEmpty
                        ? 'Select groups'
                        : selectedNames.join(', '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedNames.isEmpty
                          ? colors.onSurfaceVariant
                          : colors.onSurface,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showRecommendedVisibilityDialog(
    List<GroupEntity> groups,
  ) async {
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (ctx) => MultiGroupSelectionDialog(
        groups: groups,
        selectedIds: _recommendedVisibility.toSet(),
      ),
    );
    if (result != null) {
      setState(() => _recommendedVisibility = result.toList());
    }
  }

  String? _groupNameById(String? id, List<GroupEntity> groups) {
    if (id == null || id == 'None') return id;
    for (final group in groups) {
      if (group.id == id) return group.name;
    }
    return id;
  }

  Widget _buildActionButtons(ColorScheme colors, TextTheme textTheme) {
    return Row(
      children: [
        FilledButton(onPressed: _onSave, child: const Text('Save')),
        const SizedBox(width: AppSpacing.medium),
        OutlinedButton(
          onPressed: _onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
